local text = require("util/text")

Data = {
    errors = 0,
    categories = 0,
    tests = 0,
    assertions = 0,
}

function Category(case)
    print(text:yellow(case))
    Data.categories = Data.categories + 1
end

function Assert(value, eq, message)
    Data.assertions = Data.assertions + 1
    assert(value == eq,
        text:red(
            (message or "") ..
            string.format(". [expected %s (%s) to be %s (%s)]", tostring(eq), type(eq), tostring(value), type(value)))
    )
    print("    " .. (message and message .. " " or "") .. "asserted " .. tostring(eq))
end

function AssertNot(value, neq, message)
    Data.assertions = Data.assertions + 1
    assert(value ~= neq,
        text:red(
            (message or "") ..
            string.format(". [expected %s (%s) not to be %s (%s)]", tostring(eq), type(eq), tostring(value), type(value)))
    )
    print("    " .. (message and message .. " " or "") .. "asserted different value to " .. tostring(eq))

end

function Test(case, fn)
    print("  " .. text:yellow(case))
    Data.tests = Data.tests + 1
    local status, err = pcall(fn)
    if not status then
        print("    [!] " .. text:red(err))
        Data.errors = Data.errors + 1
    else
        print("    " .. text:green("All good!"))
    end
end

-----------------------------------------------------
--               TESTS START HERE                  --
-----------------------------------------------------


Category("Class")

require("test/class")

Category("Entity")

require("test/entity")

Category("Util/Vector")

require("test/util/vector")

Category("Component/Scene Tree")

require("test/components/tree")


-----------------------------------------------------
--                 TESTS END HERE                  --
-----------------------------------------------------

print()
print(Data.categories, "categories")
print(Data.tests, "tests")
print(Data.assertions, "assertions")
print(Data.errors, "errors")
print()
print(Data.errors > 0 and text:red("Fail!") or text:green("Pass!"))
print()

if Data.errors > 0 then
    os.exit(1)
end
