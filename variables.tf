variable "github_token" {
  description = "GitHub token"
  type        = string
}

variable "owner" {
  description = "value of the owner"
  type        = string
  default     = "teelium-test"
}

variable "template_repos" {
  description = "Map of template repository configurations where key is the repository name and value is the configuration"
  type        = map(object({
    description     = optional(string, "")
    visibility      = optional(string, "private")
    archived        = optional(bool, false)
    template        = optional(bool, true)
    teams           = object({
      admin = string
      push  = set(string)
    })
    branch_protection = list(object({
      pattern = optional(string, "main")
      checks  = optional(object({
        strict   = optional(bool, true)
        contexts = set(string)
      }), null)
      pr_reviews = optional(
        object({
          require_code_owner_reviews = optional(bool, false)
        }),
        { require_code_owner_reviews = false }
      )
      push_restrictions = object({ teams = set(string) })
    }))
  }))
}

variable "repos" {
  description = "Map of repository configurations where key is the repository name and value is the configuration"
  type        = map(object({
    description     = optional(string, "")
    visibility      = optional(string, "private")
    actionable      = optional(bool, false)
    archived        = optional(bool, false)
    template        = optional(bool, false)
    template_config = optional(object({
      owner                = optional(string, "teelium-test")
      repository           = string
      include_all_branches = optional(bool, true)
    }), null)
    pages_config    = optional(object({
      branch = optional(string, "main")
      path   = string
    }), null)
    teams           = object({
      admin = string
      push  = set(string)
    })
    default_branch = optional(string, "main")
    non_default_branches = optional(set(string), null)
    branch_protection = list(object({
      pattern = optional(string, "main")
      checks  = optional(object({
        strict   = optional(bool, true)
        contexts = set(string)
      }), null)
      pr_reviews = optional(
        object({
          require_code_owner_reviews = optional(bool, false)
        }),
        { require_code_owner_reviews = false }
      )
      push_restrictions = object({ teams = set(string) })
    }))
  }))
}
