locals {
  patched_details = merge(var.repo_details, {
    description    = coalesce(var.repo_details.description, "")
    visibility     = coalesce(var.repo_details.visibility, "private")
    actionable     = coalesce(var.repo_details.actionable, false)
    archived       = coalesce(var.repo_details.archived, false)
    template       = coalesce(var.repo_details.template, false)
    default_branch = coalesce(var.repo_details.default_branch, "main")
  })
}

variable "repo_name" {
  description = "Repository name"
  type        = string
}

variable "repo_details" {
  description = "Repository details"
  type        = object({
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
    non_default_branches = optional(set(string), [])
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
  })
}
