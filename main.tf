terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "= 5.42.0"
    }
  }

  required_version = "1.4.2"
}

provider "github" {
  token = var.github_token
  owner = var.owner
}

# data "github_team" "push_teams" {
#   for_each = toset(["bub", "blah"])
#   slug     = each.value
# }

# data "github_team" "push_team" {
#   for_each = toset(["bub"])
#   slug     = each.value
# }

# output "push_teams_data" {
#   value = "${values(data.github_team.push_teams).*.id}"
# }

module "create_template_repos" {
  source = "./modules/create-repo"
  for_each = var.template_repos

  repo_name    = each.key
  repo_details = each.value
}

module "create_repos" {
  source = "./modules/create-repo"
  for_each = var.repos

  repo_name    = each.key
  repo_details = each.value
  depends_on = [module.create_template_repos]
}
