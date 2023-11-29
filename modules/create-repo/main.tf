
resource "github_repository" "repo" {
  name                   = var.repo_name
  description            = local.patched_details.description
  visibility             = local.patched_details.visibility
  is_template            = local.patched_details.template
  archived               = local.patched_details.archived
  allow_merge_commit     = local.patched_details.archived ? false : true
  allow_rebase_merge     = false
  allow_squash_merge     = false
  auto_init              = true
  delete_branch_on_merge = local.patched_details.archived ? false : true

  dynamic "template" {
    for_each = local.patched_details.template_config != null ? [1] : []
    content {
      owner                = local.patched_details.template_config.owner
      repository           = local.patched_details.template_config.repository
      include_all_branches = local.patched_details.template_config.include_all_branches
    }
  }

  dynamic "pages" {
    for_each = local.patched_details.pages_config != null ? [1] : []
    content {
      source {
        branch = local.patched_details.pages_config.branch
        path   = local.patched_details.pages_config.path
      }
    }
  }
}

resource "github_actions_repository_access_level" "test" {
  count        = local.patched_details.actionable ? 1 : 0
  access_level = "organization"
  repository   = github_repository.repo.name
}

# branch protection
module branch_protection {
  source = "../branch-protection"
  for_each = {
    for branch in local.patched_details.branch_protection : branch.pattern => branch
  }

  repo_name      = github_repository.repo.name
  pattern           = each.value.pattern
  checks            = each.value.checks
  pr_reviews        = each.value.pr_reviews
  push_restrictions = each.value.push_restrictions
}

resource "github_branch_default" "default"{
  repository = github_repository.repo.name
  branch     = local.patched_details.default_branch
}

resource "github_branch_default" "non_default"{
  for_each = { for branch in local.patched_details.non_default_branches : branch => branch }

  repository = github_repository.repo.name
  branch     = each.key
}

# team association
data "github_team" "admin_team" {
  slug = local.patched_details.teams.admin
}

data "github_team" "push_teams" {
  for_each = local.patched_details.teams.push
  slug     = each.value
}

resource "github_team_repository" "push_access" {
  count      = length(values(data.github_team.push_teams))
  team_id    = values(data.github_team.push_teams)[count.index].id
  repository = github_repository.repo.name
  permission = "push"
}

resource "github_team_repository" "admin_access" {
  team_id    = data.github_team.admin_team.id
  repository = github_repository.repo.name
  permission = "admin"
}
