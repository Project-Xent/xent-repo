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

The Xent packages are released in lockstep. `cwinrt` keeps its independent
version because it is also usable outside Xent.

## Consume

```lua
add_repositories("xent-repo https://github.com/Project-Xent/xent-repo.git")
add_requires("fluxent 0.3.0") -- pulls xent-core + xent-kit + cwinrt transitively

target("app")
    add_files("src/*.c")
    add_packages("fluxent")
```

For a UI app you typically also `add_requires("xent-kit")` for the `xtk_*` builders
and drive the window with fluxent's `flux_run(cfg, model, update, view)`.

## Notes

- v0.3.0 recipes pin the immutable release commits.
- `xent-kit` and `fluxent` consume dependencies through
  `add_requires`/`add_packages`; package recipes do not duplicate their build
  graphs.
- `cwinrt` gates its generator, tests, and samples behind `is_main`; the recipe
  builds only the runtime and committed bindings.
