data "azuread_application_published_app_ids" "well_known" {}
data "azuread_client_config" "current" {}

# NOTE: that each service_principal will always have a MicrosoftGraph Role scope to User.Read.All to allow data oauth call, this will be listed as default

# Creates a SPN for the existing Microsoft Enterprise Application
# Each SPN will have 1 : M Microsoft Enterprise Application
# We can only create one SPN per Microsoft Enterprise or else there will be an error

resource "azuread_service_principal" "well_known" {
  for_each = toset(flatten([
    for spn in var.service_principal : [
      for perm in spn.permissions : perm.api
    ]
  ]))


  client_id    = data.azuread_application_published_app_ids.well_known.result[each.value]
  use_existing = true
}

resource "azuread_application" "this" {
  for_each = merge({
    for spn in var.service_principal :
    spn.name => spn
  })

  display_name = each.key
  owners       = [data.azuread_client_config.current.object_id]

  dynamic "required_resource_access" {
    for_each = each.value.permissions

    content {
      resource_app_id = data.azuread_application_published_app_ids.well_known.result[required_resource_access.value.api]

      dynamic "resource_access" {
        for_each = can(required_resource_access.value.application) ? toset(required_resource_access.value.application) : toset([])

        content {
          id   = azuread_service_principal.well_known[required_resource_access.value.api].app_role_ids[resource_access.value]
          type = "Role"
        }
      }

      dynamic "resource_access" {
        for_each = can(required_resource_access.value.delegated) ? toset(required_resource_access.value.delegated) : toset([])

        content {
          id   = azuread_service_principal.well_known[required_resource_access.value.api].oauth2_permission_scope_ids[resource_access.value]
          type = "Scope"
        }
      }
    }
  }
}

resource "azuread_service_principal" "principal_id" {
  for_each = merge({
    for spn in var.service_principal :
    spn.name => spn
  })

  client_id = azuread_application.this[each.key].client_id
}

resource "azuread_app_role_assignment" "admin_consent" {
  for_each = {
    for i in flatten([
      for k, v in var.service_principal : [
        for perm in v.permissions : [
          for application in perm.application : {
            spn        = v.name
            role       = application
            permission = perm.api
          } if length(perm.application) > 0
        ]
      ]
    ]) : format("%s_%s", i.spn, i.role) => i
  }

  principal_object_id = azuread_service_principal.principal_id[each.value.spn].object_id
  resource_object_id  = azuread_service_principal.well_known[each.value.permission].object_id
  app_role_id         = azuread_service_principal.well_known[each.value.permission].app_role_ids[each.value.role]
}
