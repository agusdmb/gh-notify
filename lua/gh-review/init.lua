local gh = require("gh-review.gh")
local telescope = require("gh-review.telescope")

local M = {}

local notified_prs = {}

local function compare_prs(prs, other_prs)
  local new_prs = {}
  if #prs > 0 then
    for _, pr in ipairs(prs) do
      if not other_prs[pr.number] then
        new_prs[pr.number] = { title = pr.title, url = pr.url, body = pr.body }
      end
    end
  end
  return new_prs
end

local function notify_new_prs(new_prs)
  for _, pr in pairs(new_prs) do
    vim.notify(string.format("New PR: %s", pr.title))
  end
end

local add_new_prs = function(new_prs)
  for pr_number, pr in pairs(new_prs) do
    notified_prs[pr_number] = { title = pr.title, url = pr.url, body = pr.body }
  end
end

local function _check_for_new_prs(prs)
  local new_prs = compare_prs(prs, notified_prs)

  notify_new_prs(new_prs)
  add_new_prs(new_prs)
end

function M.check_for_new_prs()
  if not M.username then
    M.set_username(M.check_for_new_prs)
    return
  end
  if not M.repo then
    M.set_repo(M.check_for_new_prs)
    return
  end
  gh.async_prs(M.username, M.repo, _check_for_new_prs)
end

function M.open_telescope()
  telescope.open_telescope(notified_prs)
end

function M.set_username(callback)
  gh.async_username(function(username)
    M.username = username
    if callback then
      callback()
    end
  end)
end

function M.set_repo(callback)
  gh.async_repo_name(function(repo)
    if not repo then
      return
    end
    M.repo = repo
    if callback then
      callback()
    end
  end)
end

function M.get_repo()
  return M.repo
end

local function initialize_loop()
  local timer = vim.loop.new_timer()
  if not timer then
    vim.notify("Failed to create timer", vim.log.levels.ERROR)
    return
  end
  timer:start(0, M.interval * 1000, vim.schedule_wrap(function() M.check_for_new_prs() end))
end

function M.setup(opts)
  M.interval = opts and opts.interval or 60
  M.set_username()
  M.set_repo(initialize_loop)
  vim.cmd([[command! -nargs=0 GhPRs lua require("gh-review").open_telescope()]])
end

return M
