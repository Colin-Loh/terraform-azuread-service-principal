data "azuread_application_published_app_ids" "well_known" {}
data "azuread_client_config" "current" {}


resource "azuread_service_principal" "well_known" {
  for_each = toset(flatten([
    for k, v in var.service_principals : [
      for values in v.permissions : values.api
    ]
  ]))

  client_id    = data.azuread_application_published_app_ids.well_known.result[each.value]
  use_existing = true
}

resource "azuread_application" "this" {
  for_each = var.service_principals

  display_name = each.key
  owners       = [data.azuread_client_config.current.object_id]

  dynamic "required_resource_access" {
    for_each = each.value.permissions

    content {
      resource_app_id = data.azuread_application_published_app_ids.well_known.result[required_resource_access.value.api]

      dynamic "resource_access" {
        for_each = required_resource_access.value.application

        content {
          id   = azuread_service_principal.well_known[required_resource_access.value.api].app_role_ids[resource_access.value]
          type = "Role"
        }
      }

      dynamic "resource_access" {
        for_each = required_resource_access.value.delegated

        content {
          id   = azuread_service_principal.well_known[required_resource_access.value.api].oauth2_permission_scope_ids[resource_access.value]
          type = "Scope"
        }
      }
    }
  }

  dynamic "web" {
    for_each = each.value.web

    content {
      homepage_url  = each.value.web.urls.homePageURL
      logout_url    = each.value.web.urls.logoutURL
      redirect_uris = each.value.web.urls.redirectURLs

      implicit_grant {
        access_token_issuance_enabled = each.value.web.urls.grant.useAccessTokens
        id_token_issuance_enabled     = each.value.web.urls.grant.useIdTokens
      }
    }
  }
}


resource "azuread_service_principal" "principal_id" {
  for_each = var.service_principals


  client_id = azuread_application.this[each.key].client_id
}

resource "azuread_app_role_assignment" "admin_consent" {
  for_each = {
    for i in flatten([
      for k, v in var.service_principals : [
        for perm in v.permissions : [
          for application in perm.application : {
            spn        = k
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
