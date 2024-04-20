data "azuread_application_published_app_ids" "well_known" {}
data "azuread_client_config" "current" {}

# NOTE: that each service_principal will always have a MicrosoftGraph Role scope to User.Read.All to allow data oauth call, this will be listed as default

# Creates a SPN for the existing Microsoft Enterprise Application
# Each SPN will have 1 : M Microsoft Enterprise Application
# Key will need to be Unique, can't be SPN-NAME so we will do SPN-NAME_MicrosoftGraph

resource "azuread_service_principal" "resource_id" {
  for_each = { 
    for perm in var.service_principal.permissions : 
    format("%s_%s", var.service_principal.name, perm.Permission) => perm 
  }

  client_id    = data.azuread_application_published_app_ids.well_known.result[each.value.Permission]
  use_existing = true
}

# We have to use service_principal and not our local block because SPN-NAME is the key and not SPN-NAME_MicrosoftGraph.. etc 

resource "azuread_application" "this" {
  display_name = var.service_principal.name
  owners       = [data.azuread_client_config.current.object_id]

  dynamic "required_resource_access" {
    for_each = var.service_principal.permissions

    content {
      resource_app_id = data.azuread_application_published_app_ids.well_known.result[required_resource_access.value.Permission]

      dynamic "resource_access" {
        for_each = can(required_resource_access.value.Role) ? toset(required_resource_access.value.Role) : toset([])

        content {
          id   = azuread_service_principal.resource_id[format("%s_%s", var.service_principal.name, required_resource_access.value.Permission)].app_role_ids[resource_access.value]
          type = "Role"
        }
      }

      dynamic "resource_access" {
        for_each = can(required_resource_access.value.Scope) ? toset(required_resource_access.value.Scope) : toset([])

        content {
          id   = azuread_service_principal.resource_id[format("%s_%s", var.service_principal.name, required_resource_access.value.Permission)].oauth2_permission_scope_ids[resource_access.value]
          type = "Scope"
        }
      }
    }
  }
}

# Create SPN in the Enterprise Application that we just created

resource "azuread_service_principal" "principal_id" {
  client_id = azuread_application.this.client_id
}


resource "azuread_app_role_assignment" "admin_consent" {
  for_each = {
    for i in flatten([
        for perm in var.service_principal.permissions : [
            for role in perm.Role : {
                spn = var.service_principal.name
                role = role
                permission = perm.Permission
              } if length(perm.Role) > 0
            ]
    ]) : format("%s_%s", i.spn, i.role) => i
  }

  principal_object_id = azuread_service_principal.principal_id.object_id
  resource_object_id  = azuread_service_principal.resource_id[format("%s_%s", var.service_principal.name, each.value.permission)].object_id
  app_role_id         = azuread_service_principal.resource_id[format("%s_%s", var.service_principal.name, each.value.permission)].app_role_ids[each.value.role]
}

