variable "service_principals" {
  type = map(object({
    permissions = optional(list(object({
      api         = string
      application = optional(list(string), [])
      delegated   = optional(list(string), [])
      })),
      [
        {
          api         = "MicrosoftGraph"
          application = ["User.Read.All"]
          delegated   = []
        }
    ])
    web = optional(object({
      urls = optional(object({
        homePageURL  = optional(string, null)
        logoutURL    = optional(string, null)
        redirectURLs = optional(list(string), [])
        grant = optional(object({
          useAccessTokens = optional(bool)
          useIdTokens     = optional(bool)
        }), {})
      }), {})
    }), {})
  }))
  description = <<-DESC
    (Required) Defines service principals with specific permissions.

    Attributes:
    - `permissions` (Optional): A list of permission objects defining access controls for the service principal.
      - `api` (Optional): The permission type, e.g., 'MicrosoftGraph', 'DynamicsCrm'.
      - `application` (Optional): A list of roles associated with the permission. Defaults to an empty list if not specified.
      - `delegated` (Optional): A list of scopes associated with the permission. Defaults to an empty list if not specified.
      - `web` (Optional): Defines branding & properties of the application registration 
          - `homepageURL` (Optional): Home page or landing page of the application.
          - `logoutURL` (Optional): The URL that will be used by Microsoft's authorization service to sign out a user using front-channel, back-channel or SAML logout protocols.
          - `redirectURLs` (Optional) A set of URLs where user tokens are sent for sign-in, or the redirect URIs where OAuth 2.0 authorization codes and access tokens are sent. 
          - `grant` (Optional): Defines implicit grant
            - `useAccessTokens` (Optional): Whether this web application can request an access token using OAuth 2.0 implicit flow.
            - `useIdTokens` (Optional): Whether this web application can request an ID token using OAuth 2.0 implicit flow.
  DESC

  validation {
    condition = alltrue([
      for spn in var.service_principals : alltrue([
        for perm in spn.permissions : (
          length(perm.application) > 0 || length(perm.delegated) > 0
        )
      ])
    ])
    error_message = "Err: Each permission must have either 'Application' or one 'Delegated' permission defined."
  }

}
