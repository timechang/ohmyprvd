# Oh My Prvd

<img src="../../assets/logo.svg" width="300px" align="right" alt="Logo"/>

![CI](https://github.com/team-fireworks/ohmyprvd/actions/workflows/ci.yml/badge.svg)

Oh My Prvd is a delightful framework modern Roblox game development.

Boring. Do it again.

***Oh My Prvd will not make you a front page developer, but you may feel like
one.***

Oh My Prvd accelerates the process with providers, connecting the top-level
design of your game. Choose to mix in networking and components as you need.
Enjoy a development experience that fades into the background, freeing you to
build faster and shout: **Oh, My Prvd!**

## Highlights

- Type-safe APIs for both Luau and TypeScript
- Featherlight, choose to mix in packages as you need
- Uses dependency injection for cleaner code organization
- Made to be extendable
- Non-intrusive lifecycle events for flexibility
- Designed for clarity with syntax inspired by Rust

Sparked your interest? [Get going in minutes with our on-rails
tutorial](https://team-fireworks.github.io/ohmyprvd/latest/get-started/).

> **Warning:** Oh My Prvd is in early development. Portions of the API may
> break, be changed, or outright deleted. There will be dragons.

## Code Sample

```Lua
local prvd = require("@pkg/ohmyprvd")
local CharacterProvider = require("./character-provider")

local CombatProvider = {
  characterProvider = prvd.use(CharacterProvider)
}

function CombatController.performMove(
  self: typeof(CombatController),
  move: CombatMove
)
  local character = self.characterProvider:awaitCharacter()
  -- do something with the character
end

return prvd.Provider("CombatProvider", CombatProvider)
```

```TypeScript
import { Provider, use } from "@rbxts/ohmyprvd"
import { CharacterProvider } from "./character-provider"

export const CombatProvider = Provider("CombatProvider", {
  characterProvider: use(CharacterProvider)

  performMove(move: CombatMove) {
    const character = this.characterProvider.awaitCharacter()
    // do something with the character
  }
})
```

## FAQ

### How do you say Oh My Prvd?

However you want:

- *Oh, my prvd!* for excitement
- *Oh, my providers!* for completeness
- *O-m-p!* for brevity
- *Ommp!* for power

### Who's that handsome gentlemen on the home page?

His name is Womp Womp:

<img src="../../assets/womp.png" alt="Womp Womp" height="256px" />
