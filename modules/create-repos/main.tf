module "create_repo" {
  source = "../create-repo"
  for_each = var.repos

  repo_name    = each.key
  repo_details = each.value
}

# output "name" {
#   value = module.create_repo.repo.name
# }

resource "github_repository" "repos" {
  for_each = { for repo in var.repos : repo.name => repo }

  name                   = each.value.name
  description            = each.value.description
  visibility             = each.value.visibility
  is_template            = each.value.template
  archived               = each.value.archived
  allow_merge_commit     = each.value.archived ? false : true
  allow_rebase_merge     = false
  allow_squash_merge     = false
  auto_init              = true
  delete_branch_on_merge = each.value.archived ? false : true

  dynamic "template" {
    for_each = each.value.template_config != null ? [1] : []
    content {
      owner                = each.value.template_config.owner
      repository           = each.value.template_config.repository
      include_all_branches = each.value.template_config.include_all_branches
    }
  }

  dynamic "pages" {
    for_each = each.value.pages_config != null ? [1] : []
    content {
      source {
        branch = each.value.pages_config.branch
        path   = each.value.pages_config.path
      }
    }
  }
}

resource "github_actions_repository_access_level" "test" {
  for_each = {
    for repo in var.repos : repo.name => repo if repo.actionable
  }

  access_level = "organization"
  repository   = github_repository.repos[each.key].name
}
