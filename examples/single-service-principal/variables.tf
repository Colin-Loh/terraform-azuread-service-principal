variable "service_principals" {
  type = list(object({
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
  }))
  description = <<-DESC
    (Required) Defines a list of service principals with specific permissions.

    Attributes:
    - `name`        (Required): The name of the service principal.
    - `permissions` (Required): A list of permission objects defining access controls for the service principal.
      - `Permission` (Required): The permission type, e.g., 'MicrosoftGraph', 'DynamicsCrm'.
      - `Role`       (Optional): A list of roles associated with the permission. Defaults to an empty list if not specified.
      - `Scope`      (Optional): A list of scopes associated with the permission. Defaults to an empty list if not specified.
  DESC

  validation {
    condition = alltrue([
      for sp in var.service_principals : alltrue([
        for perm in sp.permissions : (
          length(perm.Role) > 0 || length(perm.Scope) > 0
        )
      ])
    ])
    error_message = "Err: Each permission must have at least one 'Role' or one 'Scope' defined."
  }
}
