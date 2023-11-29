
variable "repo_name" {
  description = "Name of the repository"
  type        = string
}

variable "pattern" {
  description = "Branch pattern to apply protection to"
  type        = string
  default     = "main"
}

variable "checks" {
  description = "Checks to apply to the branch"
  type        = object({
    strict   = optional(bool, true)
    contexts = set(string)
  })
  default = {
    strict   = true
    contexts = ["ci tests"]
  }
}

variable "pr_reviews" {
  description = "Pull request reviews to apply to the branch"
  type        = object({
    require_code_owner_reviews = optional(bool, false)
  })
  default = {
    require_code_owner_reviews = false
  }
}

variable "push_restrictions" {
  description = "Push restrictions to apply to the branch"
  type        = object({
    teams = set(string)
  })
  default = {
    teams = []
  }
}
