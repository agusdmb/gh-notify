local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

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
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        -- print(vim.inspect(selection))
        vim.api.nvim_put({ selection[1] }, "", false, true)
      end)
      return true
    end,
  }):find()
end

return M
