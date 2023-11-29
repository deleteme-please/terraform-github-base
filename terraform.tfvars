
template_repos = {
  "template1" = {
    description = "Template 1"
    teams = {
      admin = "meep"
      push  = ["bub", "blah"]
    }
    branch_protection = [{
      checks            = { contexts = ["ci tests"] }
      push_restrictions = { teams = ["bub", "blah"] }
    }]
  },
  "action-template" = {
    description = "Action Template"
    teams = {
      admin = "meep"
      push  = ["bub"]
    }
    branch_protection = [{
      checks            = { contexts = ["ci tests"] }
      push_restrictions = { teams = ["bub"] }
    }]
  }
}

repos = {
  "repo1" = {
    description = "Repository 1"
    template_config = {
      owner      = "teelium-test"
      repository = "template1"
    }
    teams = {
      admin = "meep"
      push  = ["bub"]
    }
    branch_protection = [{
      checks            = { contexts = ["ci tests"] }
      push_restrictions = { teams = ["bub"] }
    }]
  },
  "repo2" = {
    description = "Repository 2"
    visibility  = "public"
    template_config = {
      owner                = "teelium-test"
      repository           = "template1"
      include_all_branches = false
    }
    pages_config = {
      branch = "main"
      path   = "/docs"
    }
    teams = {
      admin = "meep"
      push  = ["blah"]
    }
    branch_protection = [{
      checks            = { contexts = ["ci tests"] }
      push_restrictions = { teams = ["blah"] }
    }]
  },
  "gitflow1" = {
    description = "gitflow 1"
    visibility  = "private"
    template_config = {
      owner                = "teelium-test"
      repository           = "template1"
      include_all_branches = false
    }
    pages_config = {
      branch = "main"
      path   = "/docs"
    }
    teams = {
      admin = "meep"
      push  = ["blah"]
    }
    default_branch = "develop"
    non_default_branches = ["main"]
    branch_protection = [{
      checks            = { contexts = ["ci tests"] }
      push_restrictions = { teams = ["blah"] }
    }, {
      checks            = { contexts = ["ci tests"] }
      push_restrictions = { teams = ["blah"] }
      pattern           = "develop"
    }]
  },
  "action1" = {
    description = "Action 1"
    visibility  = "private"
    actionable  = true
    template_config = {
      owner                = "teelium-test"
      repository           = "action-template"
      include_all_branches = false
    }
    teams = {
      admin = "meep"
      push  = ["blah", "bub"]
    }
    branch_protection = [{
      checks            = { contexts = ["ci tests"] }
      push_restrictions = { teams = ["blah", "bub"] }
    }]
  },
}
