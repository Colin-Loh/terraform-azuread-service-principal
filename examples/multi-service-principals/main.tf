module "service_principal" {
  for_each = {
    for sp in var.service_principals :
    sp.name => sp
  }
  
  source = "../.."

  service_principal = {
    name       = each.key
    permissions = each.value.permissions
  }
}
