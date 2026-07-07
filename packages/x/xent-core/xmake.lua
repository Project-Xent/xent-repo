package("xent-core")
    set_homepage("https://github.com/Project-Xent/xent-core")
    set_description("Pure-C layout, tree, text-shaping and semantics engine for the Xent UI stack.")
    set_license("0BSD")

    add_urls("https://github.com/Project-Xent/xent-core.git")
    add_versions("0.1.0", "ed95f79452d99201b7094dcad41f0460be8dc48c")
    add_versions("0.2.0", "8bc939cce4bb6a832d16bfa97e1723026514a06b")
    add_versions("0.2.1", "5ab0075ffcbf06dbe4be167be05415fe4c334cfe")

    -- Optional SIMD / ISPC paths are off by default (experimental); expose as configs.
    add_configs("simd", {description = "Enable experimental SIMD scaffolding", default = false, type = "boolean"})
    add_configs("ispc", {description = "Enable ISPC SIMD backend (requires ispc on PATH)", default = false, type = "boolean"})

    on_install(function (package)
        local configs = {}
        if package:config("simd") then configs.simd = true end
        if package:config("ispc") then configs.ispc = true end
        -- Only the `xent_core` static lib is a default target; tests/demos/benches are
        -- set_default(false), so this builds and installs just the library + headers.
        import("package.tools.xmake").install(package, configs)
        -- add_headerfiles flattens include/xent/*.h; restore the xent/ prefix.
        os.cp("include/xent", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:has_cfuncs("xent_create_context", {includes = "xent/xent.h"}))
    end)
