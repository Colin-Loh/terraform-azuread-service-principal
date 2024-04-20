variable "service_principal" {
  type = object({
    name = string
    permissions = optional(list(object({
      Permission = string
      Role       = optional(list(string), [])
      Scope      = optional(list(string), [])
    })), [
      {
        Permission = "MicrosoftGraph",
        Role       = ["User.Read.All"],
        Scope      = []
      }
    ])
  })
  description = <<-DESC
    Configuration for a single service principal. This object includes the name of the service principal
    and a list of permissions specifying the access controls in Azure.

    Attributes:
    - `name` (Required): The name of the service principal.
    - `permissions` (Required): A list of permission objects defining the types of access the service principal has.
      - `Permission` (Required): Specifies the type of Microsoft service (e.g., MicrosoftGraph, DynamicsCrm) the permission applies to.
      - `Role` (Optional): A list of roles under the specified permission. This list specifies what actions the service principal can perform.
      - `Scope` (Optional): A list of scopes under the specified permission. Scopes define the boundaries of the permission within the service.
  DESC

  validation {
    condition = alltrue([
      for perm in var.service_principal.permissions : length(perm.Role) > 0 || length(perm.Scope) > 0
    ])
    error_message = "Err: Each permission must have at least one 'Role' or one 'Scope' defined."
  }
}
