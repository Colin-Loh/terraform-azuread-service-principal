service_principals = [
  {
    name = "SPN-ONE"
    permissions = [
      {
        api       = "MicrosoftGraph",
        delegated = ["User.ReadWrite"]
      },
      {
        api         = "PowerBiService",
        application = ["Tenant.Read.All", "Tenant.ReadWrite.All"]
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
        api         = "MicrosoftGraph",
        application = ["User.ReadWrite.All", "User.Read.All"]
      },
      {
        api       = "DynamicsCrm",
        delegated = ["user_impersonation"]
      },
      {
        api         = "PowerBiService",
        application = ["Tenant.Read.All"]
      }
    ]
  }
]


## The module will convert the service_principals list(object) to the following format: 
## You can remove the local block in the module if you prefer to use the following format: 

# service_principals = {
#   "SPN-ONE" = {
#     permissions = [
#       {
#         Permission = "MicrosoftGraph",
#         Role       = [],
#         Scope      = ["User.ReadWrite"]
#       },
#       {
#         Permission = "PowerBiService",
#         Role       = ["Tenant.Read.All", "Tenant.ReadWrite.All"]
#       }
#     ]
#   },
#   "SPN-THREE" = {
#     permissions = [
#       {
#         Permission = "MicrosoftGraph",
#         Role       = ["User.ReadWrite.All", "User.Read.All"]
#       },
#       {
#         Permission = "DynamicsCrm",
#         Role = []
#         Scope      = ["user_impersonation"]
#       },
#       {
#         Permission = "PowerBiService",
#         Role       = ["Tenant.Read.All"]
#       }
#     ]
#   }
# }
