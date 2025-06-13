-- mGBA Lua API Discovery Script
-- Safely discovers available functions and capabilities
-- Use this to understand what APIs are available in your mGBA version

print("=== mGBA Lua API Discovery ===")

-- Check what global variables/functions exist
print("Available globals:")
local global_count = 0
for k,v in pairs(_G) do
    if type(v) == "table" or type(v) == "function" then
        global_count = global_count + 1
        if global_count <= 20 then  -- Limit output
            print("  " .. k .. " (" .. type(v) .. ")")
        end
    end
end
if global_count > 20 then
    print("  ... and " .. (global_count - 20) .. " more")
end

print("")
print("=== Memory Functions ===")
if memory then
    print("memory table exists!")
    local memory_functions = {}
    local success, err = pcall(function()
        for k,v in pairs(memory) do
            table.insert(memory_functions, k .. " (" .. type(v) .. ")")
        end
    end)
    
    if success then
        for _, func in ipairs(memory_functions) do
            print("  memory." .. func)
        end
    else
        print("Error reading memory table: " .. err)
    end
else
    print("memory table not found")
end

print("")
print("=== Testing Basic Memory Read ===")
-- Try the functions that typically work in VBA-M
local test_address = 0x02024029
print("Testing address: " .. string.format("0x%08X", test_address))

if memory then
    -- Test memory.readbyte (most common)
    local success, result = pcall(function() return memory.readbyte(test_address) end)
    if success then
        print("✅ memory.readbyte() works! Result: " .. result)
    else
        print("❌ memory.readbyte() failed: " .. result)
    end
    
    -- Test memory.readword
    local success2, result2 = pcall(function() return memory.readword(test_address) end)
    if success2 then
        print("✅ memory.readword() works! Result: " .. result2)
    else
        print("❌ memory.readword() failed: " .. result2)
    end
end

print("")
print("=== Simple Working Script ===")
print("Based on discovery, here's a simple working script:")
print("")
print('-- Simple Pokemon Party Reader')
print('function read_party()')
print('    local party_count = memory.readbyte(0x02024029)')
print('    print("Party Pokemon: " .. party_count)')
print('end')
print('')
print('-- Call it manually:')
print('read_party()')

print("")
print("=== Try Manual Commands ===")
print("You can now type these commands manually:")
print("1. read_party()  -- Read party count")
print("2. memory.readbyte(0x02024029)  -- Direct memory read")

-- Define the function for manual use
function read_party()
    local party_count = memory.readbyte(0x02024029)
    print("Party Pokemon: " .. party_count)
    return party_count
end

print("")
print("✅ Discovery complete! Type 'read_party()' to test!")
