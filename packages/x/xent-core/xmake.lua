package("xent-core")
    set_homepage("https://github.com/Project-Xent/xent-core")
    set_description("Pure-C layout, tree, text and semantics engine for the Xent UI stack.")
    set_license("0BSD")

    add_urls("https://github.com/Project-Xent/xent-core.git")
    add_versions("0.1.0", "ed95f79452d99201b7094dcad41f0460be8dc48c")
    add_versions("0.2.0", "8bc939cce4bb6a832d16bfa97e1723026514a06b")
    add_versions("0.2.1", "5ab0075ffcbf06dbe4be167be05415fe4c334cfe")
    add_versions("0.3.0", "6e41aa7e8b9d8fc9d0b00c53a06829af6733e206")

    add_configs("simd", {description = "Enable SIMD paths", default = false, type = "boolean"})
    add_configs("ispc", {description = "Enable ISPC SIMD backend (requires ispc on PATH)", default = false, type = "boolean"})

    on_install(function (package)
        local configs = {}
        if package:config("simd") then configs.simd = true end
        if package:config("ispc") then configs.ispc = true end
        import("package.tools.xmake").install(package, configs)
        os.cp("include/xent", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:has_cfuncs("xent_create_context", {includes = "xent/xent.h"}))
    end)
