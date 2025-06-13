-- mGBA Lua API Discovery Script
-- Safely discovers available functions and capabilities
-- Use this to understand what APIs are available in your mGBA version
-- Version: 2.0 - Enhanced and cleaned

print("=== mGBA Lua API Discovery v2.0 ===")
print("📊 Analyzing available Lua environment...")

-- Enhanced function to safely test function calls
local function safe_test_function(func, test_args, description)
    local success, result = pcall(func, unpack(test_args or {}))
    if success then
        print("✅ " .. description .. " - Result: " .. tostring(result))
        return true, result
    else
        print("❌ " .. description .. " - Error: " .. tostring(result))
        return false, result
    end
end

-- Check what global variables/functions exist
print("\n🔍 Available globals:")
local global_count = 0
local important_globals = {}

for k,v in pairs(_G) do
    if type(v) == "table" or type(v) == "function" then
        global_count = global_count + 1
        if k == "memory" or k == "emu" or k == "console" or k == "callbacks" or k == "savestate" then
            important_globals[k] = type(v)
        elseif global_count <= 15 then  -- Limit output
            print("  " .. k .. " (" .. type(v) .. ")")
        end
    end
end

print("\n🎯 Important mGBA globals found:")
for name, gtype in pairs(important_globals) do
    print("  ✅ " .. name .. " (" .. gtype .. ")")
end

if global_count > 15 then
    print("  ... and " .. (global_count - 15) .. " more standard globals")
end

print("\n🧪 === Memory Functions Discovery ===")
if memory then
    print("✅ memory table exists!")
    local memory_functions = {}
    local success, err = pcall(function()
        for k,v in pairs(memory) do
            table.insert(memory_functions, k .. " (" .. type(v) .. ")")
        end
    end)
    
    if success then
        print("📋 Available memory functions:")
        for _, func in ipairs(memory_functions) do
            print("  memory." .. func)
        end
    else
        print("❌ Error reading memory table: " .. err)
    end
else
    print("❌ memory table not found")
end

print("\n🔬 === Testing Basic Memory Operations ===")
-- Try different memory read functions with multiple addresses
local test_addresses = {
    {addr = 0x02024029, desc = "Party Count (FireRed/LeafGreen)"},
    {addr = 0x08000000, desc = "ROM Header"},
    {addr = 0x03000000, desc = "Working RAM"},
}

for _, test in ipairs(test_addresses) do
    print("Testing address: " .. string.format("0x%08X", test.addr) .. " (" .. test.desc .. ")")
    
    if memory then
        -- Test different read functions
        safe_test_function(memory.read8 or memory.readbyte, {test.addr}, "  8-bit read")
        safe_test_function(memory.read16 or memory.readword, {test.addr}, "  16-bit read") 
        safe_test_function(memory.read32 or memory.readdword, {test.addr}, "  32-bit read")
    end
    print("")
end

print("🎮 === Testing Emulator Functions ===")
if emu then
    print("✅ emu table exists!")
    safe_test_function(emu.framecount, {}, "Frame count")
    safe_test_function(emu.getGameTitle, {}, "Game title")
    safe_test_function(emu.getGameCode, {}, "Game code")
else
    print("❌ emu table not found")
end

print("\n💾 === Testing Save State Functions ===")
if savestate then
    print("✅ savestate table exists!")
    -- Don't actually save/load, just check if functions exist
    print("  Available savestate functions:")
    for k,v in pairs(savestate) do
        print("    savestate." .. k .. " (" .. type(v) .. ")")
    end
else
    print("❌ savestate table not found")
end

print("\n📞 === Testing Callback System ===")
if callbacks then
    print("✅ callbacks table exists!")
    for k,v in pairs(callbacks) do
        print("  callbacks." .. k .. " (" .. type(v) .. ")")
    end
else
    print("❌ callbacks table not found")
end

print("\n📝 === Quick Reference Script ===")
print("Based on discovery, here's a working example:")
print("")
print("-- Quick Pokemon Party Reader")
print("function read_party_safely()")
print("  local success, party_count = pcall(function()")
print("    return memory.read8(0x02024029)  -- or memory.readbyte")
print("  end)")
print("  if success then")
print("    print('Party Pokemon: ' .. party_count)")
print("    return party_count")
print("  else")
print("    print('Memory read failed')")
print("    return 0")
print("  end")
print("end")

print("\n🎯 === Interactive Testing ===")
print("You can now manually test these commands:")
print("1. read_party_safely()  -- Safe party count reader")
print("2. memory.read8(0x02024029)  -- Direct memory read (if available)")
print("3. emu.framecount()  -- Current frame (if available)")

-- Define enhanced functions for manual use
function read_party_safely()
    if not memory then
        print("❌ Memory access not available")
        return 0
    end
    
    local read_func = memory.read8 or memory.readbyte
    if not read_func then
        print("❌ No suitable memory read function found")
        return 0
    end
    
    local success, party_count = pcall(read_func, 0x02024029)
    if success then
        print("✅ Party Pokemon: " .. party_count)
        return party_count
    else
        print("❌ Memory read failed: " .. party_count)
        return 0
    end
end

function show_game_info()
    if emu then
        print("🎮 Game Info:")
        safe_test_function(emu.getGameTitle, {}, "Title")
        safe_test_function(emu.getGameCode, {}, "Code") 
        safe_test_function(emu.framecount, {}, "Frame count")
    else
        print("❌ Emulator functions not available")
    end
end

print("\n✅ Discovery complete!")
print("💡 Try: read_party_safely() or show_game_info()")
print("📖 Use results to configure other scripts for your mGBA version")
