<div class="ompdoc-api-breadcrumbs">
<a href="../../">Oh My Prvd</a>
<a href="../">Core</a>
</div>

<div class="ompdoc-api-tags">
<span>type</span>
<span>since v0.1</span>
</div>

# Provider

Provides a specific functionality for a game. This type is not useful outside of
Oh My Prvd itself; prefer to use [`use(provider)`](../providers/use.md) for
more precise types.

=== "Luau"

    ```Lua
    export type Provider<T> = T & {
      loadOrder: number?,

      onInit: ((self: Provider<T>) -> Promise?)?,
      onStart: (self: Provider<T>) -> ()?
    }
    ```

=== "TypeScript"

    ```TypeScript
    export type Provider<T extends object> = T & {
      loadOrder?: number,
      onInit?(): void | Promise<void>,
      onStart?(): void
    }
    ```

---

## Members

### loadOrder `#!lua : number`

Determines when to initialize the provider. Defaults to one. This member is not
generally useful, as Oh My Prvd will figure out a load order with dependency
injection.

### onInit `#!lua : (self: Provider<T>) -> Promise?`

Runs sequentially before any other lifecycle methods, methods are expected to be
infallible and preferably non-yielding.

If it returns a promise, Oh My Prvd will await for the promise to resolve.

### onStart `#!lua : (self: Provider<T>) -> ()`

Runs concurrently *after* all other lifecycle methods have been registered. This
means failures and yields do not affect other providers.

---

## Learn More

- [Providers tutorial](../../../learn/providers.md)
