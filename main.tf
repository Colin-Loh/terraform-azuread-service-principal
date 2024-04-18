provider "azurerm" {
  features {}
}

data "azuread_application_published_app_ids" "well_known" {}
data "azuread_client_config" "current" {}

locals {
  custom_spn = {
    "Dynamics-AND-Graph" = {
      apps = [
        {
          appId = "DynamicsCrm"
          permissions = [
            {
              id   = "user_impersonation"
              type = "Scope"
            }
          ]
        },
        {
          appId = "MicrosoftGraph"
          permissions = [
            {
              id   = "User.Read.All"
              type = "Role"
            },
            {
              id   = "User.ReadWrite.All"
              type = "Role"
            },
            {
              id   = "User.ReadWrite"
              type = "Scope"
            }
          ]
        }
      ]
    },
    "Dynamics-ONLY" = {
      apps = [
        {
          appId = "DynamicsCrm"
          permissions = [
            {
              id   = "user_impersonation"
              type = "Scope"
            }
          ]
        }
      ]
    },
    "PowerBi-AND-Graph" = {
      apps = [
        {
          appId = "PowerBiService"
          permissions = [
            {
              id   = "Tenant.Read.All"
              type = "Role"
            },
            {
              id   = "Tenant.ReadWrite.All"
              type = "Role"
            }
          ]
        },
        {
          appId = "MicrosoftGraph"
          permissions = [
            {
              id   = "User.Read.All"
              type = "Role"
            }
          ]
        }
      ]
    }
  }
}

locals {
  custom_app_permissions = merge([
    for spn_key, spn_value in local.custom_spn : {
      for app in spn_value.apps : "${spn_key}_${app.appId}" => {
        appId       = app.appId,
        all_perm     = app.permissions,
        application_perm = [for perm in app.permissions : perm.id if perm.type == "Role"],
        has_role = anytrue([for perm in app.permissions : perm.type == "Role"])
      }
    }
  ]...)
}

# Create Service Principal for the Enterprise Application (Microsoft provisioned)
resource "azuread_service_principal" "resource_id" {
  for_each = local.custom_app_permissions

  client_id    = data.azuread_application_published_app_ids.well_known.result[each.value.appId]
  use_existing = true
}

# Creates Enterrpise Application for our Custom SPN that we are creating 
resource "azuread_application" "this" {
  for_each = local.custom_spn

  display_name = each.key
  owners       = [data.azuread_client_config.current.object_id]

  dynamic "required_resource_access" {
    for_each = each.value.apps

    content {
      resource_app_id = data.azuread_application_published_app_ids.well_known.result[required_resource_access.value.appId]

      dynamic "resource_access" {
        for_each = required_resource_access.value.permissions

        content {
          id   = resource_access.value.type == "Role" ? azuread_service_principal.resource_id["${each.key}_${required_resource_access.value.appId}"].app_role_ids[resource_access.value.id] : azuread_service_principal.resource_id["${each.key}_${required_resource_access.value.appId}"].oauth2_permission_scope_ids[resource_access.value.id]
          type = resource_access.value.type
        }
      }
    }
  }
}

# # Create SPN in the Enterprise Application that we just created
resource "azuread_service_principal" "principal_id" {
  for_each = local.custom_spn

  client_id = azuread_application.this[each.key].client_id
}

locals {
  app_role_assignments = merge([
    for spn_key, spn_value in local.custom_app_permissions : {
      for perm in spn_value.application_perm : "${spn_key}_${perm}" => {
        principal_object_id = azuread_service_principal.principal_id[split("_", spn_key)[0]].object_id
        resource_object_id  = azuread_service_principal.resource_id[spn_key].object_id
        app_role_id         = azuread_service_principal.resource_id[spn_key].app_role_ids[perm]
      }
    }
  ]...)
}

# Granting Admin Consent for anything "Role" 
resource "azuread_app_role_assignment" "admin_consent" {
  for_each = local.app_role_assignments

  principal_object_id = each.value.principal_object_id
  resource_object_id  = each.value.resource_object_id
  app_role_id         = each.value.app_role_id
}
