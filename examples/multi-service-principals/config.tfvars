service_principals = [
  {
    name = "SPN-ONE"
    permissions = [
      {
        Permission = "MicrosoftGraph",
        Role       = []
        Scope      = ["User.ReadWrite"]
      },
      {
        Permission = "DynamicsCrm",
        Scope      = ["user_impersonation"]
      }
    ]
  },
  {
    name = "SPN-TWO"
  },
  {
    name = "SPN-THREE"
    permissions = [
      {
        Permission = "DynamicsCrm",
        Scope      = ["user_impersonation"]
      },
      {
        Permission = "MicrosoftGraph",
        Role       = ["User.ReadWrite.All", "User.Read.All"]
      },
      {
        Permission = "PowerBiService",
        Role       = ["Tenant.Read.All", "Tenant.ReadWrite.All"]
      }
    ]
  }
]