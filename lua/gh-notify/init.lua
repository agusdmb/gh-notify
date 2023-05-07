local gh = require("gh-notify.gh")
local telescope = require("gh-notify.telescope")

local M = {}

local notified_prs = {}

local function compare_prs(prs, other_prs)
  local new_prs = {}
  if #prs > 0 then
    for _, pr in ipairs(prs) do
      if not other_prs[pr.number] then
        new_prs[pr.number] = { title = pr.title, url = pr.url }
      end
    end
  end
  return new_prs
end

local function notify_new_prs(new_prs)
  for _, pr in pairs(new_prs) do
    vim.notify(string.format("New PR: %s (%s)", pr.title, pr.url))
  end
end

local add_new_prs = function(new_prs)
  for pr_number, pr in pairs(new_prs) do
    notified_prs[pr_number] = { title = pr.title, url = pr.url }
  end
end


local function check_for_new_prs(user)
  local prs = gh.get_prs(user)
  local new_prs = compare_prs(prs, notified_prs)

  notify_new_prs(new_prs)
  add_new_prs(new_prs)
end

function M.open_telescope()
  telescope.open_telescope(notified_prs)
end

function M.setup(opts)
  local user = gh.get_gh_username()

  local interval = opts.interval or 60
  local start_after = opts.start_after or 10

  local timer = vim.loop.new_timer()
  if not timer then
    vim.notify("Failed to create timer", vim.log.levels.ERROR)
    return
  end
  timer:start(start_after * 1000, interval * 1000, vim.schedule_wrap(function() check_for_new_prs(user) end))

  vim.cmd([[command! -nargs=0 GhPRs lua require("gh-notify").open_telescope()]])
end

return M
