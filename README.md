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
| [azuread_service_principal.resource_id](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azuread_application_published_app_ids.well_known](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application_published_app_ids) | data source |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_service_principal"></a> [service\_principal](#input\_service\_principal) | Configuration for a single service principal. This object includes the name of the service principal<br>and a list of permissions specifying the access controls in Azure.<br><br>Attributes:<br>- `name` (Required): The name of the service principal.<br>- `permissions` (Required): A list of permission objects defining the types of access the service principal has.<br>  - `Permission` (Required): Specifies the type of Microsoft service (e.g., MicrosoftGraph, DynamicsCrm) the permission applies to.<br>  - `Role` (Optional): A list of roles under the specified permission. This list specifies what actions the service principal can perform.<br>  - `Scope` (Optional): A list of scopes under the specified permission. Scopes define the boundaries of the permission within the service. | <pre>object({<br>    name = string<br>    permissions = optional(list(object({<br>      Permission = string<br>      Role       = optional(list(string), [])<br>      Scope      = optional(list(string), [])<br>    })), [<br>      {<br>        Permission = "MicrosoftGraph",<br>        Role       = ["User.Read.All"],<br>        Scope      = []<br>      }<br>    ])<br>  })</pre> | n/a | yes |

## Outputs

No outputs.