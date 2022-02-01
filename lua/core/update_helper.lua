-- https://github.com/luan/nvim/blob/main/lua/update.lua
local jobs = require 'packer.jobs'
local a = require 'packer.async'
local result = require 'packer.result'
local await = a.wait
local async = a.sync
local fmt = string.format

local memo = { status = "" }

local function printerr(msg)
  vim.notify(msg, 'error', { title = 'Config Update' })
end

local function warn(msg)
  vim.notify(msg, 'warn', { title = 'Config Update' })
end

local function async_command(cmd, ignore_error)
  return async(function ()
    local r = result.ok()
    local opts = { capture_output = true, cwd = CONFIG_PATH }
    r
      :and_then(await, jobs.run(cmd, opts))
      :map_err(function(err)
        if not ignore_error then
          printerr(fmt('Failed to update config. %s: %s', cmd, err.output.data.stderr[1]))
        end
        return nil
      end)
      :map_ok(function(ok)
        return ok.output.data.stdout[1]
      end)

    return r.ok
  end)
end

local function remote_version()
  return await(async_command('git rev-parse @{u}'))
end

local function local_version()
  return await(async_command('git rev-parse @'))
end

local function merge_base()
  return await(async_command('git merge-base @ @{u}'))
end

local function update_check()
  memo.status = ''
  return async(function()
    await(async_command('git remote update'))
    await(async_command('git update-index -q --refresh'))
    local has_local_changes = await(async_command('git diff-index --quiet HEAD --', true)) == nil

    if has_local_changes then
      memo.status = '祝local changes'
      warn('Local changes detected. If these are user preferences, consider moving them to your user settings.')
      return -1
    elseif local_version() == remote_version() then
      memo.status = ''
      return 0
    elseif local_version() == merge_base() then
      memo.status = ' update available'
      warn('There is a new version of the nvim config available. Run :ConfigUpdate to update to the latest.')
      return 1
    elseif remote_version() == merge_base() then
      memo.status = 'ﴻ local commits'
      memo.local_commits = true
      warn('Local commits detected. You may want to push / send a PR / move your changes to user settings?')
      return -1
    end
    return -1
  end)
end

local M = {}

function M.status()
  return memo.status
end

function M.config_update()
  async(function()
    local has_update = await(update_check())
    if has_update == 0 then
      return
    elseif has_update == -1 then
      printerr('Local changes detected. Update aborted!')
      return
    end

    local did_update = await(async_command('git merge ' .. remote_version()))
    if did_update == -1 then
      printerr('Failed updating config. Try doing a git pull in the repository directly.')
      return
    end

    vim.defer_fn(function()
      package.loaded['plugins'] = nil
      require('plugins').sync()
    end, 1000)
  end)()
end

local timer = vim.loop.new_timer()
timer:start(1000, 3600 * 1000, function()
  update_check()()
end)


return M