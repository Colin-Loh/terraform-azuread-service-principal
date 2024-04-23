module "service_principal" {
  source = "../.."

  service_principals = {
    SPN-ONE = {
      permissions = [
        {
          api         = "MicrosoftGraph"
          delegated   = ["User.ReadWrite"]
        },
        {
          api         = "DynamicsCrm"
          delegated   = ["user_impersonation"]
        }
      ],
      web = {
        urls = {
          homePageURL  = "https://app.example.net"
          logoutURL    = "https://app.example.net/logout"
          redirectURLs = ["https://app.example.net/account", "https://app.example.net/account2"]

          grant = {
            useAccessTokens = true
            useIdTokens     = true
          }
        }
      }
    },
    SPN-TWO = {
      permissions = [
        {
          api         = "DynamicsCrm"
          delegated   = ["user_impersonation"]
        },
        {
          api         = "PowerBiService",
          application = ["Tenant.ReadWrite.All"]
        }
      ],
      web = {
        urls = {
          homePageURL  = "https://app.example.net"
          logoutURL    = "https://app.example.net/logout"
          redirectURLs = ["https://app.example.net/account", "https://app.example.net/account2"]
        }
      }
    },
    SPN-THREE = {}
  }
}
