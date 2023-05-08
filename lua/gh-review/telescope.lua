local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local M = {}

function M.open_telescope(notified_prs)
  local prs = {}
  for _, pr_data in pairs(notified_prs) do
    table.insert(prs, { pr_data.url, pr_data.title, pr_data.body })
  end

  local opts = {
    previewer = true,
    layout_config = {
      width = 0.5,
      height = 0.75,
    },
    previewer_cutoff = 0.5,
    layout_strategy = 'vertical',
  }

  local new_previewer = previewers.new_buffer_previewer {
    get_buffer_by_name = function(_, entry)
      return entry.value
    end,
    define_preview = function(self, entry)
      entry.preview = vim.fn.substitute(entry.preview, "\r", "", "g")
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(entry.preview, "\n"))
      vim.api.nvim_buf_set_option(self.state.bufnr, 'filetype', 'markdown')
    end,
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
          preview = entry[3],
        }
      end,
    },
    previewer = new_previewer,
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
