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

local types = require(script.Parent.types)

local methodHandlers: { [string]: { [{}]: (types.Provider<unknown>) -> () } } = {}
local providerHandlers: { [{}]: (types.Provider<unknown>) -> () } = {}
local useHandlers: { [{}]: (types.Provider<unknown>) -> () } = {}
local mods = {}

function mods.implementAllMethods(provider: types.Provider<unknown>)
  for method, handlers in pairs(methodHandlers) do
    local method = rawget(provider, method)
    if method == nil then
      continue
    end
    for _, handler in pairs(handlers) do
      handler(provider)
    end
  end
end

function mods.doMethodImplemented(method: string, provider: types.Provider<unknown>)
  if not methodHandlers[method] then
    return
  end
  for _, handler in pairs(methodHandlers[method]) do
    handler(provider)
  end
end

function mods.doProviderConstructed(provider: types.Provider<unknown>)
  if next(providerHandlers) == nil then
    return
  end
  for _, handler in pairs(providerHandlers) do
    handler(provider)
  end
end

function mods.doProviderUsed(provider: types.Provider<unknown>)
  if next(useHandlers) == nil then
    return
  end
  for _, handler in pairs(useHandlers) do
    handler(provider)
  end
end

--[[
  Called when a provider implements a method. Handlers are expected to be
  infallible and non-yielding. The handler receives the constructed provider.
  Commonly used to implement custom lifecycles by adding providers to a
  "watchlist" which will have its methods fired.
]]
function mods.onMethodImplemented(method: string, handler: (types.Provider<unknown>) -> ())
  if not methodHandlers[method] then
    methodHandlers[method] = {}
  end
  local identifier = table.freeze {}
  methodHandlers[method][identifier] = handler
end

--[[
  Called just before Oh My Prvd returns a newly constructed provider. Handlers
  are expected to be infallible and non-yielding. The handler receives the
  constructed provider.
]]
function mods.onProviderConstructed(handler: (types.Provider<unknown>) -> ())
  local identifier = table.freeze {}
  providerHandlers[identifier] = handler
end

--[[
  Called just before Oh My Prvd returns a used Provider. Handlers are expected
  to be infallible and non-yielding. The handler receives the used provider.
]]
function mods.onProviderUsed(handler: (types.Provider<unknown>) -> ())
  local identifier = table.freeze {}
  useHandlers[identifier] = handler
end

table.freeze(mods)
return mods
