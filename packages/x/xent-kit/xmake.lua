package("xent-kit")
    set_homepage("https://github.com/Project-Xent/xent-kit")
    set_description("Elm-style MVU declarative UI layer (pure C17) for the Xent stack — the xtk_* builders.")
    set_license("0BSD")

    add_urls("https://github.com/Project-Xent/xent-kit.git")
    -- 0.1.0 == current main HEAD (no tag yet; switch to v0.1.0 tag once tagged).
    add_versions("0.1.0", "790fe1c6137bf626fcb431929a7b5957eda88391")

    add_deps("xent-core")

    on_install(function (package)
        -- NOTE: requires xent-kit/xmake.lua to consume xent-core via add_requires/
        -- add_packages (not the old xtk_dep sibling-clone). See xent-repo task #2.
        import("package.tools.xmake").install(package)
        -- add_headerfiles flattens include/xtk/*.h; restore the xtk/ prefix.
        os.cp("include/xtk", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:check_csnippets({test = [[
            #include <xtk/xtk.h>
            void test(void) { (void)sizeof(XtkEl); }
        ]]}, {configs = {languages = "c17"}}))
    end)
