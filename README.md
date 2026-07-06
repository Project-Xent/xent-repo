# xent-repo

Standalone xmake package repository for the **Xent** UI stack (pure-C, 0BSD).

This replaces the old fork of `xmake-io/xmake-repo` — it carries **only** Xent's
own package recipes, nothing else.

## Packages

| package     | repo                                   | deps                                  | plat    |
|-------------|----------------------------------------|---------------------------------------|---------|
| `xent-core` | Project-Xent/xent-core                 | —                                     | any     |
| `xent-kit`  | Project-Xent/xent-kit                  | xent-core                             | any     |
| `cwinrt`    | Project-Xent/cwinrt                    | —                                     | windows |
| `fluxent`   | Project-Xent/fluxent                   | xent-core, xent-kit, cwinrt           | windows |

All pinned lockstep at `0.1.0`.

## Consume

```lua
add_repositories("xent-repo https://github.com/Project-Xent/xent-repo.git")
add_requires("fluxent")   -- pulls xent-core + xent-kit + cwinrt transitively

target("app")
    add_files("src/*.c")
    add_packages("fluxent")
```

For a UI app you typically also `add_requires("xent-kit")` for the `xtk_*` builders
and drive the window with fluxent's `flux_run(cfg, model, update, view)`.

## Notes

- Recipes currently pin `add_versions("0.1.0", <commit-sha>)`. Once the component
  repos are tagged `v0.1.0`, switch these to the tag (see repo task #5).
- `xent-kit` / `fluxent` recipes assume their project `xmake.lua` consumes deps via
  `add_requires`/`add_packages` (not the old `xtk_dep`/`flux_dep` sibling-clone hack).
- `cwinrt`'s `xmake.lua` gates its generator/tests/samples behind `is_main`; the recipe
  builds only the library targets (runtime + committed bindings).
