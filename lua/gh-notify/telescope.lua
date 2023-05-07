local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values

local M = {}

function M.open_telescope(notified_prs)
  local prs = {}
  for _, pr_data in pairs(notified_prs) do
    table.insert(prs, pr_data.title)
  end
  local opts = {}
  pickers.new(opts, {
    prompt_title = "PRs",
    finder = finders.new_table {
      results = prs
    },
    sorter = conf.generic_sorter(opts),
  }):find()
end

return M
