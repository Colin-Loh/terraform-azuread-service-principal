# module "service_principal" {
#   source = "../.."

#   service_principals = [
#     {
#       name = "SPN-ONE"
#       permissions = [
#         {
#           api         = "MicrosoftGraph",
#           application = ["User.ReadWrite.All", "User.Read.All"]
#           delegated   = ["User.ReadWrite"]
#         },
#         {
#           api       = "DynamicsCrm",
#           delegated = ["user_impersonation"]
#         }
#       ]
#     }
#   ]
# }


module "service_principal" {
  source = "../.."

  service_principals = {
    SPN-ONE = {
      permissions = [
        {
          api         = "MicrosoftGraph",
          application = ["User.ReadWrite.All", "User.Read.All"]
          delegated   = ["User.ReadWrite"]
        },
        {
          api       = "DynamicsCrm",
          delegated = ["user_impersonation"]
          application = []
        }
      ]
    },
  SPN-TWO = {
      permissions = [
        {
          api         = "MicrosoftGraph",
          application = ["User.ReadWrite.All", "User.Read.All"]
          delegated   = ["User.ReadWrite"]
        }
      ]
    }
  }
}


# locals {
#     service_principals = {
#     "SPN-ONE" = {
#       permissions = [
#         {
#           api         = "MicrosoftGraph",
#           application = ["User.ReadWrite.All", "User.Read.All"]
#           delegated   = ["User.ReadWrite"]
#         },
#         {
#           api       = "DynamicsCrm",
#           delegated = ["user_impersonation"]
#           application = []
#         }
#       ]
#     },
#     "SPN-TWO" = {
#       permissions = [
#         {
#           api         = "MicrosoftGraph",
#           application = ["User.ReadWrite.All", "User.Read.All"]
#           delegated   = ["User.ReadWrite"]
#         },
#         {
#           api       = "PowerBi",
#           delegated = ["user_impersonation"]
#           application = []
#         }
#       ]
#     }
#   }
# }

# locals {
#   test = toset({
#     for k, v in local.service_principals : {
#       for roles in v.permissions : [
#         for role in roles.application : role.api
#       ]
#     }
#   })
# }

# locals {
#   test = toset(flatten([
#     for k, v in local.service_principals : [
#       for values in v.permissions : values.api
#     ]
#   ]))
# }

# output test {
#   value = local.test
# }
