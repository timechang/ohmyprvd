--!strict
--!nolint LocalShadow

--[[

  Copyright 2024 Team Fireworks

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the “Software”), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so,subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.

]]

local RunService = game:GetService("RunService")

local package = script.Parent.Parent
local types = require(package.types)

export type Error = types.Error

local ERROR_MESSAGES_URL = "team-fireworks.github.io/ohmyprvd/latest/reference/general/error-messages#"

local MESSAGES: { [string]: string } = table.freeze {
  alreadyIgnited = "cannot ignite more than once",
  cannotRegister = "cannot register provider; %s",
  cannotUseNonProvider = "`use()` must be given a provider",
  initError = "cannot initialize %s; %s",
  invalidLoadParent = "loadX must be given an instance",
  invalidOnIgnitionCallback = "`onIgnition` must be given callbacks",
  lifecycleEvent = "running lifecycle event %s",
  registerAfterIgnition = "cannot register providers after ignition",
  requireError = "cannot require %s; %s",
  serverRenderLifecycle = "cannot use `:render` lifecycle from the server",
  unknown = "unknown error: %s",
  useAfterIgnition = "cannot use other providers after ignition",
  usedBeforeIgnition = 'cannot use provider "%s" prior to ignition',
}

local TIPS: { [string]: string } = table.freeze {
  unknown = "this indicates oh my prvd isn't reporting errors correctly, please file an issue",
  usedBeforeIgnition = "ohmyprvd will inject the dependency for you during runtime, its safe to use the provider inside a lifecycle method",
}

local Log = {}

local function fmtMessage(id: string, level: string, trace: string?, ...: unknown)
  local message = MESSAGES[id]
  if not message then
    local unknownMessage = table.clone(MESSAGES.unknown)
    unknownMessage = unknownMessage:format(id)
    message = unknownMessage
    id = "unknown"
  end

  local formatted = `[ohmyprvd {level}({id})]: {message}`
  if select("#", ...) > 0 then
    formatted:format(...)
  end
  if TIPS[id] then
    formatted ..= `\nhelp: {TIPS[id]}`
  end
  if level ~= "info" and RunService:IsStudio() then
    formatted ..= `\nlearn more: {ERROR_MESSAGES_URL}{id:lower()}`
  end
  if trace then
    formatted ..= `\nstack trace:\n{(trace:gsub("\n", "\n    "))}`
  end

  return (formatted:gsub("\n", "\n    "))
end

function Log.throw(id: string, trace: string?, ...: unknown): never
  task.spawn(error, fmtMessage(id, "error", trace or debug.traceback(nil, 2), ...), 0)
  task.defer(coroutine.close, coroutine.running())
  return coroutine.yield()
end

function Log.warn(id: string, ...: unknown)
  warn(fmtMessage(id, "warning", nil, ...))
end

function Log.info(id: string, ...: unknown)
  print(fmtMessage(id, "info", nil, ...))
end

--[[
  An `xpcall` handler used to extract useful information such as stack traces
  and messages.
]]
function Log.parseError(err: string): Error
  return {
    type = "Error",
    raw = err,
    message = err:gsub("^.+:%d+:%s*", ""),
    trace = debug.traceback(nil, 2),
  }
end

--[[
  Passes the condition if it is truthy, otherwise throws an error with the log
  module. Behaves like a modified `assert`.
]]
function Log.expect<T>(condition: T, id: string, trace: string?, ...: unknown): T
  if condition then
    return condition
  end
  return Log.throw(id, trace, ...)
end

table.freeze(Log)
return Log
