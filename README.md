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
| <a name="input_service_principals"></a> [service\_principals](#input\_service\_principals) | (Required) Defines service principals with specific permissions.<br><br>Attributes:<br>- `permissions` (Optional): A list of permission objects defining access controls for the service principal.<br>  - `api` (Optional): The permission type, e.g., 'MicrosoftGraph', 'DynamicsCrm'.<br>  - `application` (Optional): A list of roles associated with the permission. Defaults to an empty list if not specified.<br>  - `delegated` (Optional): A list of scopes associated with the permission. Defaults to an empty list if not specified.<br>  - `web` (Optional): Defines branding & properties of the application registration <br>      - `homepageURL` (Optional): Home page or landing page of the application.<br>      - `logoutURL` (Optional): The URL that will be used by Microsoft's authorization service to sign out a user using front-channel, back-channel or SAML logout protocols.<br>      - `redirectURLs` (Optional) A set of URLs where user tokens are sent for sign-in, or the redirect URIs where OAuth 2.0 authorization codes and access tokens are sent. <br>      - `grant` (Optional): Defines implicit grant<br>        - `useAccessTokens` (Optional): Whether this web application can request an access token using OAuth 2.0 implicit flow.<br>        - `useIdTokens` (Optional): Whether this web application can request an ID token using OAuth 2.0 implicit flow. | <pre>map(object({<br>    permissions = optional(list(object({<br>      api         = string<br>      application = optional(list(string), [])<br>      delegated   = optional(list(string), [])<br>      })),<br>      [<br>        {<br>          api         = "MicrosoftGraph"<br>          application = ["User.Read.All"]<br>          delegated   = []<br>        }<br>    ])<br>    web = optional(object({<br>      urls = optional(object({<br>        homePageURL  = optional(string, null)<br>        logoutURL    = optional(string, null)<br>        redirectURLs = optional(list(string), [])<br>        grant = optional(object({<br>          useAccessTokens = optional(bool)<br>          useIdTokens     = optional(bool)<br>        }), {})<br>      }), {})<br>    }), {})<br>  }))</pre> | n/a | yes |

## Outputs

No outputs.