# Ignition

With your providers defined, its time to ignite Oh My Prvd.

## Preloading

It's necessary to preload your providers to for Oh My Prvd to pick it up. For
convenience, you can use either `loadChildren()` or the `loadDescendants()`
function, which will load all providers from a parent's children or
descendants respectively:

=== "Luau"

    ```lua
    local prvd = require("@pkg/ohmyprvd")
    prvd.loadChildren(script.Providers)
    prvd.loadDescendants(script.Providers)
    ```

=== "TypeScript"

    ```ts
    import { loadChildren, loadDescendants } from "@rbxts/ohmyprvd"
    loadChildren(script.Providers)
    loadDescendants(script.Providers)
    ```

You can also pass a predicate function to filter the target modules:

=== "Luau"

    ```lua hl_lines="4-7"
    local prvd = require("@pkg/ohmyprvd")
    prvd.loadDescendants(
      script.Providers,
      function(module: ModuleScript)
        return module.Name:find("Provider$") ~= nil
      end
    )
    ```

=== "TypeScript"

    ```ts hl_lines="4-5"
    import { LoadMode, loadDescendants } from "@rbxts/ohmyprvd"
    loadDescendants(
      script.Providers,
      (module) => module.Name.find("Provider$") !== undefined
    )
    ```

## Ignite

Finally, ignite Oh My Prvd, and you're off to the races:

```TypeScript
prvd.ignite()
```

If another script requires Oh My Prvd to be ignited, `awaitIgnition()` can be
used, which will yield until Oh My Prvd is fully ignited:

```TypeScript
prvd.awaitIgnition()
```

Alternatively, if you need to bind to ignition, `onIgnition(callback)` can be
used, which will spawn the callback when Oh My Prvd has fully ignited:

=== "Luau"

    ```Lua
    prvd.onIgnition(function()
      print("ignited!")
    end)
    ```

=== "TypeScript"

    ```TypeScript
    prvd.onIgnition(() => print("ignited!"))
    ```