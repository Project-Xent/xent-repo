package("cwinrt")
    set_homepage("https://github.com/Project-Xent/cwinrt")
    set_description("Pure-C WinRT projection (runtime + generated bindings) used by FluXent.")
    set_license("0BSD")

    add_urls("https://github.com/Project-Xent/cwinrt.git")
    add_versions("0.1.0", "1745ebfa94596b1e49e6339f5c4cc68d2746690b")
    add_versions("0.2.0", "f5f5bf527d0dae3fa87cf8d7c0c7c482591ca596")
    add_versions("0.2.1", "b104e2c0fdf6cadcef06626719dca505a56c1d1c")
    add_versions("0.3.0", "eabeec5be8273e9b7f78204f23c0056782b4514c")

    if not is_plat("windows", "mingw") then
        set_isbuilt(false)
    end

    on_install("windows", "mingw", function (package)
        -- Package the split runtime and committed bindings as one conventional
        -- archive; the upstream integration target is phony.
        io.writefile("xmake.lua", [[
            add_rules("mode.debug", "mode.release")
            set_languages("c23")
            add_defines("_CRT_SECURE_NO_WARNINGS", "UNICODE", "_UNICODE")
            target("cwinrt")
                set_kind("$(kind)")
                add_includedirs("include", "gen", {public = true})
                add_headerfiles("include/(cwinrt/**.h)")
                add_files("rt/*.c", "include/cwinrt/impl/*.impl.c")
                if is_plat("windows", "mingw") then
                    add_syslinks("runtimeobject", "ole32", "oleaut32", "uuid", {public = true})
                end
        ]])
        import("package.tools.xmake").install(package)
    end)

    on_test(function (package)
        assert(package:check_csnippets({test = [[
            #include <cwinrt/bootstrap.h>
            void test(void) {}
        ]]}, {configs = {languages = "c23"}}))
    end)
