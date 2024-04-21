## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_app_role_assignment.admin_consent](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment) | resource |
| [azuread_application.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_service_principal.principal_id](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azuread_service_principal.well_known](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azuread_application_published_app_ids.well_known](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application_published_app_ids) | data source |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_service_principal"></a> [service\_principal](#input\_service\_principal) | (Required) Defines a list of service principals with specific permissions.<br><br>Attributes:<br>- `name`        (Required): The name of the service principal.<br>- `permissions` (Required): A list of permission objects defining access controls for the service principal.<br>  - `api` (Required): The permission type, e.g., 'MicrosoftGraph', 'DynamicsCrm'.<br>  - `application`       (Optional): A list of roles associated with the permission. Defaults to an empty list if not specified.<br>  - `delegated`      (Optional): A list of scopes associated with the permission. Defaults to an empty list if not specified. | <pre>list(object({<br>    name = string<br>    permissions = optional(list(object({<br>      api         = string<br>      application = optional(list(string), [])<br>      delegated   = optional(list(string), [])<br>      })), [<br>      {<br>        api         = "MicrosoftGraph",<br>        application = ["User.Read.All"],<br>        delegated   = []<br>      }<br>    ])<br>  }))</pre> | n/a | yes |

## Outputs

No outputs.