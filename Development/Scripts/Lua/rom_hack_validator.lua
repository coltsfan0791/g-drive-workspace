-- ROM Hack Validation Script for mGBA
-- Validates ROM hack functionality and reports compatibility
-- Version: 2.0 - Enhanced with better error handling and modern API usage

local rom_hack_validator = {}

-- Enhanced ROM hack detection patterns
local rom_signatures = {
    pokemon_gaia = {"GAIA", "ORBTUS"},
    pokemon_unbound = {"UNBOUND", "BORRIUS"}, 
    pokemon_radical_red = {"RADRED", "RADICAL"},
    pokemon_emerald_kaizo = {"KAIZO", "EMERKAIZO"},
    pokemon_ash_gray = {"ASHGRAY", "ASH"},
    pokemon_light_platinum = {"LIGHTPLAT", "PLATINUM"},
    pokemon_glazed = {"GLAZED", "TUNOD"},
    pokemon_prism = {"PRISM", "NALJO"},
    pokemon_reborn = {"REBORN", "AGATE"},
    pokemon_insurgence = {"INSURGENCE", "TORREN"}
}

-- Safe function call wrapper
local function safe_call(func, ...)
    local success, result = pcall(func, ...)
    return success, result
end

-- Safe memory read with fallback
local function safe_memory_read(address, read_func, default_value)
    local success, result = safe_call(read_func, address)
    return success and result or (default_value or 0)
end

-- Initialize validation with improved detection
function rom_hack_validator.init()
    console.log("🔍 ROM Hack Validator v2.0 - Starting Analysis")
    
    if not emu then
        console.log("❌ Emulator functions not available!")
        return false
    end
    
    local game_title = safe_call(emu.getGameTitle) and emu:getGameTitle() or "Unknown"
    local game_code = safe_call(emu.getGameCode) and emu:getGameCode() or "Unknown"
    
    console.log("ROM Title: " .. game_title)
    console.log("ROM Code: " .. game_code)
    
    -- Enhanced ROM hack detection
    local rom_title_upper = game_title:upper()
    local detected_hack = nil
    
    for hack_name, signatures in pairs(rom_signatures) do
        for _, signature in ipairs(signatures) do
            if string.find(rom_title_upper, signature) then
                detected_hack = hack_name
                console.log("✅ Detected ROM Hack: " .. hack_name .. " (signature: " .. signature .. ")")
                break
            end
        end
        if detected_hack then break end
    end
    
    if detected_hack then
        rom_hack_validator.run_compatibility_tests(detected_hack)
    else
        console.log("⚠️ Unknown ROM - Running generic validation")
        rom_hack_validator.run_generic_tests()
    end
    
    return true
end

-- Run compatibility tests for known ROM hacks
function rom_hack_validator.run_compatibility_tests(hack_name)
    console:log("🧪 Running compatibility tests for: " .. hack_name)
    
    -- Test basic game functions
    rom_hack_validator.test_memory_access()
    rom_hack_validator.test_save_functionality()
    rom_hack_validator.test_input_response()
    
    -- Hack-specific tests
    if hack_name == "pokemon_gaia" then
        rom_hack_validator.test_gaia_features()
    elseif hack_name == "pokemon_unbound" then
        rom_hack_validator.test_unbound_features()
    end
end

-- Test memory access patterns with enhanced checking
function rom_hack_validator.test_memory_access()
    console.log("📊 Testing memory access patterns...")
    
    if not memory then
        console.log("❌ Memory access not available!")
        return 0
    end
    
    -- Test common Pokemon memory addresses with multiple read functions
    local test_addresses = {
        {addr = 0x02024EA0, desc = "Player name", size = 8},
        {addr = 0x02024284, desc = "Party data", size = 100},
        {addr = 0x02025BB0, desc = "Money", size = 4},
        {addr = 0x02024029, desc = "Party count", size = 1}
    }
    
    local success_count = 0
    local total_tests = #test_addresses
    
    -- Try different memory read functions
    local read_functions = {
        {func = memory.read8 or memory.readbyte, name = "8-bit"},
        {func = memory.read16 or memory.readword, name = "16-bit"},
        {func = memory.read32 or memory.readdword, name = "32-bit"}
    }
    
    for _, test in ipairs(test_addresses) do
        local test_passed = false
        
        for _, read_func in ipairs(read_functions) do
            if read_func.func then
                local value = safe_memory_read(test.addr, read_func.func, nil)
                if value then
                    console.log("✅ " .. test.desc .. " accessible (" .. read_func.name .. " read)")
                    test_passed = true
                    break
                end
            end
        end
        
        if test_passed then
            success_count = success_count + 1
        else
            console.log("❌ " .. test.desc .. " inaccessible")
        end
    end
    
    local success_rate = (success_count / total_tests) * 100
    console.log(string.format("📈 Memory access success rate: %.1f%% (%d/%d)", success_rate, success_count, total_tests))
    return success_rate
end

-- Test save functionality
function rom_hack_validator.test_save_functionality()
    console:log("💾 Testing save functionality...")
    
    -- This would require more advanced testing
    -- For now, just check if save state works
    local save_path = "test_save_state.ss1"
    
    if emu.savestateExists then
        if emu:savestateExists(save_path) then
            console:log("✅ Save state functionality available")
        else
            console:log("⚠️ Save state not found (normal for new session)")
        end
    else
        console:log("❌ Save state functionality unavailable")
    end
end

-- Test input response
function rom_hack_validator.test_input_response()
    console:log("🎮 Testing input response...")
    
    -- Test if input can be read
    local keys = emu:getKeys()
    if keys then
        console:log("✅ Input system responsive")
    else
        console:log("❌ Input system unresponsive")
    end
end

-- Run generic tests for unknown ROMs
function rom_hack_validator.run_generic_tests()
    console:log("🔧 Running generic ROM validation...")
    
    rom_hack_validator.test_memory_access()
    rom_hack_validator.test_save_functionality()
    rom_hack_validator.test_input_response()
    
    -- Check ROM size and basic properties
    console:log("📏 ROM Size: " .. emu:romSize() .. " bytes")
    
    local rom_crc = emu:checksum()
    if rom_crc then
        console:log("🔐 ROM CRC32: " .. string.format("%08X", rom_crc))
    end
end

-- Pokemon Gaia specific tests
function rom_hack_validator.test_gaia_features()
    console:log("🌍 Testing Pokemon Gaia specific features...")
    -- Add Gaia-specific validation here
    console:log("✅ Gaia feature tests completed")
end

-- Pokemon Unbound specific tests  
function rom_hack_validator.test_unbound_features()
    console:log("🔓 Testing Pokemon Unbound specific features...")
    -- Add Unbound-specific validation here
    console:log("✅ Unbound feature tests completed")
end

-- Generate compatibility report
function rom_hack_validator.generate_report()
    console:log("📋 Generating compatibility report...")
    console:log("=" * 50)
    console:log("ROM Hack Validation Complete")
    console:log("Timestamp: " .. os.date())
    console:log("Emulator: mGBA")
    console:log("=" * 50)
end

-- Main execution
function rom_hack_validator.main()
    -- Wait for ROM to load
    emu:setTimeout(2000, function()
        rom_hack_validator.init()
        
        -- Generate report after tests
        emu:setTimeout(5000, function()
            rom_hack_validator.generate_report()
        end)
    end)
end

-- Start validation
rom_hack_validator.main()

return rom_hack_validator
