package("fluxent")
    set_homepage("https://github.com/Project-Xent/fluxent")
    set_description("Windows rendering backend for the Xent UI stack (pure C, D2D/DirectWrite/DComp/D3D11).")
    set_license("0BSD")

    add_urls("https://github.com/Project-Xent/fluxent.git")
    -- 0.1.0 == current main HEAD (no tag yet; switch to v0.1.0 tag once tagged).
    add_versions("0.1.0", "b4a328c517d75e481040e5f2c82baa2c28c57009")

    if not is_plat("windows", "mingw") then
        set_isbuilt(false)
    end

    add_deps("xent-core", "xent-kit", "cwinrt")

    on_install("windows", "mingw", function (package)
        -- The project xmake.lua resolves deps via flux_dep (sibling-or-clone-main) and
        -- also builds the gallery + test binaries. Replace it with a minimal build file
        -- that consumes the pinned package deps and builds only the fluxent library.
        io.writefile("xmake.lua", [[
            add_rules("mode.debug", "mode.release")
            set_languages("c17")
            set_runtimes("MT")
            add_defines("COBJMACROS", "_CRT_SECURE_NO_WARNINGS",
                        "_WIN32_WINNT=0x0A00", "WINVER=0x0A00", "UNICODE", "_UNICODE",
                        "WIN32_LEAN_AND_MEAN", "NOMINMAX")
            add_requires("xent-core", "xent-kit", "cwinrt")
            target("fluxent")
                set_kind("$(kind)")
                add_packages("xent-core", "xent-kit", "cwinrt")
                add_includedirs("include", "thirdparty/c_d2d_dwrite", {public = true})
                add_includedirs("src")
                add_headerfiles("include/(fluxent/**.h)")
                add_files("src/*.c", "src/app/*.c", "src/compose/*.c",
                          "src/controls/behavior/*.c", "src/controls/draw/*.c",
                          "src/controls/factory/*.c", "src/controls/textbox/*.c",
                          "src/bridge/*.c", "src/graphics/*.c", "src/input/*.c",
                          "src/popup/*.c", "src/render/*.c", "src/runtime/*.c",
                          "src/store/*.c", "src/text/*.c", "src/theme/*.c",
                          "src/window/*.c")
                add_syslinks("user32", "gdi32", "dcomp", "d2d1", "d3d11", "dxgi",
                             "dwrite", "dwmapi", "ole32", "oleaut32", "uuid", "uxtheme",
                             "imm32", "advapi32", "shell32", "coremessaging",
                             "uiautomationcore", "runtimeobject", "windowscodecs")
        ]])
        import("package.tools.xmake").install(package)
    end)

    on_test(function (package)
        assert(package:check_csnippets({test = [[
            #include <fluxent/flux_app.h>
            void test(void) {}
        ]]}, {configs = {languages = "c17"}}))
    end)
