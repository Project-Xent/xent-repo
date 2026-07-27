package("fluxent")
    set_homepage("https://github.com/Project-Xent/fluxent")
    set_description("Windows rendering backend for the Xent UI stack (pure C, D2D/DirectWrite/DComp/D3D11).")
    set_license("0BSD")

    add_urls("https://github.com/Project-Xent/fluxent.git")
    add_versions("0.1.0", "b4a328c517d75e481040e5f2c82baa2c28c57009")
    add_versions("0.1.1", "5d89e8af67ece72c99febb50290bba8b05a9b6f0")
    add_versions("0.1.2", "cc11c4d841958d84e491a56e36daeb56e680f2b2")
    add_versions("0.2.0", "490e6f3f50939e79083ae2cada757799442148c7")
    add_versions("0.2.1", "1aa1efbd92dc4f9583e445395d6c3dbe4b700d96")
    add_versions("0.3.0", "fcf704ace05573e07f25e607915288117f3ebcf2")

    if not is_plat("windows", "mingw") then
        set_isbuilt(false)
    end

    on_load(function (package)
        local version = package:version()
        local stack_version = version:lt("0.2.0") and "0.1.0" or version:rawstr()
        local cwinrt_version = version:lt("0.2.0") and "0.1.0"
            or (version:lt("0.3.0") and version:rawstr() or "0.3.0")
        package:add("deps", "xent-core " .. stack_version)
        package:add("deps", "xent-kit " .. stack_version)
        package:add("deps", "cwinrt " .. cwinrt_version)
    end)

    on_install("windows", "mingw", function (package)
        import("package.tools.xmake").install(package)
    end)

    on_test(function (package)
        assert(package:check_csnippets({test = [[
            #include <fluxent/flux_app.h>
            void test(void) {}
        ]]}, {configs = {languages = "c23"}}))
    end)
