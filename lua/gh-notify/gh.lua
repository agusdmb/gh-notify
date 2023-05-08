local Job = require "plenary.job"

local M = {}

function M.async_username(callback)
  Job:new {
    command = "gh",
    args = { "api", "user" },
    on_exit = function(job, code, signal)
      local result = job:result()[1]
      local data = vim.json.decode(result)
      callback(data.login)
    end
  }:start()
end

function M.async_prs(username, callback)
  Job:new {
    command = "gh",
    -- args = { "search", "prs", "repo", "Datascience", "--json", "number,title,url" },
    args = { "search", "prs", "--assignee", username, "--json", "number,title,url" },
    on_exit = function(job, code, signal)
      local result = job:result()[1]
      local data = vim.json.decode(result)
      callback(data)
    end
  }:start()
end

return M
