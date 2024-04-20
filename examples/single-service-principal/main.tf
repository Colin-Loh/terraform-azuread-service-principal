module "service_principal" {
  source = "../.."

  service_principal = {
    name       =  "SPN-ONE"
    permissions = [
      {
        Permission = "MicrosoftGraph",
        Role       = ["User.ReadWrite.All", "User.Read.All"]
        Scope      = ["User.ReadWrite"]
      },
      {
        Permission = "DynamicsCrm",
        Scope      = ["user_impersonation"]
      }
    ]
  }
}