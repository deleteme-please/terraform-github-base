variable "github_token" {
  description = "GitHub token"
  type        = string
  # not doom
  # default     = "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"
  # doom
  default = "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"
}

variable "owner" {
  description = "value of the owner"
  type        = string
  default     = "deleteme-please"
  # default = "tealium"
}

variable "repos" {
  description = "Map of repository configurations where key is the repository name and value is the configuration"
  type        = map(object({
    description     = string
    visibility      = string
    actionable      = bool
    archived        = bool
    template        = bool
    template_config = object({
      owner                = string
      repository           = string
      include_all_branches = bool
    })
    pages_config    = object({
      branch = string
      path   = string
    })
    teams           = object({
      admin = string
      push  = set(string)
    })
  }))
}
