variable "service_principals" {
  # type = object({
  #   permissions = optional(list(object({
  #     api         = string
  #     application = optional(list(string), [])
  #     delegated   = optional(list(string), [])
  #     })), [
  #     {
  #       api         = "MicrosoftGraph",
  #       application = ["User.Read.All"],
  #       delegated   = []
  #     }
  #   ])
  # })
  # description = <<-DESC
  #   (Required) Defines a list of service principals with specific permissions.

  #   Attributes:
  #   - `name`        (Required): The name of the service principal.
  #   - `permissions` (Required): A list of permission objects defining access controls for the service principal.
  #     - `api` (Required): The permission type, e.g., 'MicrosoftGraph', 'DynamicsCrm'.
  #     - `application`       (Optional): A list of roles associated with the permission. Defaults to an empty list if not specified.
  #     - `delegated`      (Optional): A list of scopes associated with the permission. Defaults to an empty list if not specified.
  # DESC

  # validation {
  #   condition = alltrue([
  #     for spn in var.service_principals : alltrue([
  #       for perm in spn.permissions : (
  #         length(perm.application) > 0 || length(perm.delegated) > 0
  #       )
  #     ])
  #   ])
  #   error_message = "Err: Each permission must have either 'Application' or one 'Delegated' permission defined."
  # }
}


