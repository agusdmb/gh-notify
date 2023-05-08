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

function M.async_prs(username, repo, callback)
  Job:new {
    command = "gh",
    args = {
      "search", "prs",
      "--repo", repo,
      "--review-requested", username,
      "--json", "number,title,url",
      "--state", "open",
    },
    on_exit = function(job, code, signal)
      local result = job:result()[1]
      local data = vim.json.decode(result)
      callback(data)
    end
  }:start()
end

function M.async_repo_name(callback)
  Job:new {
    command = "gh",
    args = { "repo", "view", "--json", "nameWithOwner" },
    on_exit = function(job, code, signal)
      local result = job:result()[1]
      if not result then
        callback(nil)
        return
      end
      local data = vim.json.decode(result)
      callback(data.nameWithOwner)
    end
  }:start()
end

return M
