
data "github_team" "pr_push_teams" {
  for_each = var.push_restrictions.teams
  slug     = each.value
}

resource "github_branch_protection" "protection" {
  repository_id  = var.repo_name
  pattern        = var.pattern
  enforce_admins = false

  required_status_checks {
    strict   = false
    contexts = var.checks.contexts
  }

  required_pull_request_reviews {
    dismiss_stale_reviews  = true
    require_code_owner_reviews = var.pr_reviews.require_code_owner_reviews
  }

  push_restrictions = values(data.github_team.pr_push_teams).*.node_id
}
