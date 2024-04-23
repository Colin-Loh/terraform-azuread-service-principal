service_principals = {
  "SPN-ONE" = {
    permissions = [
      {
        Permission = "MicrosoftGraph",
        Role       = [],
        Scope      = ["User.ReadWrite"]
      },
      {
        Permission = "PowerBiService",
        Role       = ["Tenant.Read.All", "Tenant.ReadWrite.All"]
      }
    ]
  },
  "SPN-THREE" = {
    permissions = [
      {
        Permission = "MicrosoftGraph",
        Role       = ["User.ReadWrite.All", "User.Read.All"]
      },
      {
        Permission = "DynamicsCrm",
        Role = []
        Scope      = ["user_impersonation"]
      },
      {
        Permission = "PowerBiService",
        Role       = ["Tenant.Read.All"]
      }
    ]
  }
}
