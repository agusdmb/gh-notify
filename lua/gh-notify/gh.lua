local M = {}

function M.get_gh_username()
  local handle = io.popen("gh api user")
  if not handle then
    vim.notify("Error running gh command", vim.log.levels.ERROR)
    return {}
  end

  local result = handle:read("*a")
  handle:close()
  local data = vim.json.decode(result)

  if not data then
    vim.notify("Failed to get GitHub username", vim.log.levels.ERROR)
    return
  end

  return data.login
end

function M.get_prs(user)
  local command = string.format("gh search prs --assignee %s --json number,title,url", user)
  local handle = io.popen(command)
  if not handle then
    vim.notify("Error running gh command", vim.log.levels.ERROR)
    return {}
  end

  local result = handle:read("*a")
  handle:close()

  return vim.json.decode(result)
end

return M
