module "service_principal" {
  source = "../.."

  service_principals = {
    ci-cd-epac-owner = {
      permissions = [
        {
          api         = "MicrosoftGraph"
          application   = ["Directory.Read.All", "Group.Read.All", "ServicePrincipalEndpoint.Read.All", "User.Read.All"]
        }
      ]
    },
    ci-cd-root-policy-reader = {
      permissions = [
        {
          api         = "MicrosoftGraph"
          application   = ["Directory.Read.All", "Group.Read.All", "ServicePrincipalEndpoint.Read.All", "User.Read.All"]
        }
      ]
    },
    ci-cd-root-policy-contributor = {},
    ci-cd-root-policy-administrator = {}
  }
}
