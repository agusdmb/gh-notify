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
    args = {
      "pr", "list",
      "--search", "review-requested:" .. username,
      "--json", "number,title,url,body,baseRefName,headRefName",
      "--state", "open",
    },
    on_exit = function(job, code, signal)
      local result = job:result()[1]
      local data = vim.json.decode(result)
      callback(data)
    end
  }:start()
end

return M
