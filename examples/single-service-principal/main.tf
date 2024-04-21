module "service_principal" {
  source = "../.."

  service_principal = [
    {
      name = "SPN-ONE"
      permissions = [
        {
          api         = "MicrosoftGraph",
          application = ["User.ReadWrite.All", "User.Read.All"]
          delegated   = ["User.ReadWrite"]
        },
        {
          api       = "DynamicsCrm",
          delegated = ["user_impersonation"]
        }
      ]
    }
  ]
}

