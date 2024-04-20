module "service_principal" {
  source = "../.."

  service_principal = {
    name       =  "SPN-WITH-NO-GRAPH"
    permissions = [
      {
        Permission = "DynamicsCrm",
        Scope      = ["user_impersonation"]
      }
    ]
  }
}
