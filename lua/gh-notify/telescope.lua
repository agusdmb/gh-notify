local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local M = {}

function M.open_telescope(notified_prs)
  local prs = {}
  for _, pr_data in pairs(notified_prs) do
    table.insert(prs, { pr_data.url, pr_data.title })
  end
  local opts = {
    previewer = false,
    layout_config = {
      width = 0.5,
      height = 0.5,
    },
  }
  pickers.new(opts, {
    prompt_title = "Select a PR to open",
    finder = finders.new_table {
      results = prs,
      entry_maker = function(entry)
        return {
          value = entry[1],
          display = entry[2],
          ordinal = entry[2],
        }
      end,
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        io.popen("open " .. selection["value"])
      end)
      return true
    end,
  }):find()
end

return M
