package("xent-kit")
    set_homepage("https://github.com/Project-Xent/xent-kit")
    set_description("Elm-style MVU declarative UI layer (pure C23) for the Xent stack — the xtk_* builders.")
    set_license("0BSD")

    add_urls("https://github.com/Project-Xent/xent-kit.git")
    add_versions("0.1.0", "790fe1c6137bf626fcb431929a7b5957eda88391")
    add_versions("0.2.0", "e6eca62decd9762060fa4305d8b9ae2966b9af98")
    add_versions("0.2.1", "004fea693544a52f71a82e283eb521f62c559731")
    add_versions("0.3.0", "4e69a2b841d5f9c754088e7d6f963d9edd976405")

    on_load(function (package)
        package:add("deps", "xent-core " .. package:version():rawstr())
    end)

    on_install(function (package)
        import("package.tools.xmake").install(package)
        os.cp("include/xtk", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:check_csnippets({test = [[
            #include <xtk/xtk.h>
            void test(void) { (void)sizeof(XtkEl); }
        ]]}, {configs = {languages = "c23"}}))
    end)
