-- Pokemon Minced Fusions Monitor for mGBA
-- Real-time Pokemon data reader with enhanced error handling
-- Version: 2.0 - Optimized and cleaned

local frame_count = 0
local last_check = 0
local monitor_active = true

-- Memory addresses for Pokemon games (may need adjustment for Minced Fusions)
local ADDRESSES = {
    PARTY_COUNT = 0x02024029,     -- Party Pokemon count
    PARTY_DATA = 0x0202402C,      -- Start of party data
    WILD_BATTLE = 0x02022B50,     -- Wild battle flag
    PLAYER_X = 0x02036E14,        -- Player X position
    PLAYER_Y = 0x02036E16,        -- Player Y position
}

local CONFIG = {
    CHECK_INTERVAL = 60,          -- Check every 60 frames (1 second at 60fps)
    STATUS_INTERVAL = 3600,       -- Status update every 3600 frames (1 minute)
}

-- Safe memory read function with error handling
local function safe_memory_read(address, read_func, default_value)
    if not memory then
        return default_value or 0
    end
    
    local func = read_func or memory.read8
    if not func then
        return default_value or 0
    end
    
    local success, result = pcall(func, address)
    return success and result or (default_value or 0)
end

function read_party_info()
    local party_count = safe_memory_read(ADDRESSES.PARTY_COUNT, memory.read8, 0)
    
    if party_count > 0 and party_count <= 6 then
        console.log("🎉 Party Pokemon Count: " .. party_count)
        
        -- Read first Pokemon's data if party exists
        local pokemon_species = safe_memory_read(ADDRESSES.PARTY_DATA, memory.read16, 0)
        local pokemon_level = safe_memory_read(ADDRESSES.PARTY_DATA + 84, memory.read8, 0)
        local pokemon_hp = safe_memory_read(ADDRESSES.PARTY_DATA + 86, memory.read16, 0)
        
        if pokemon_species > 0 then
            console.log("  First Pokemon - Species: " .. pokemon_species .. 
                       ", Level: " .. pokemon_level .. 
                       ", HP: " .. pokemon_hp)
        else
            console.log("  Party data may be corrupted or addresses need adjustment")
        end
    elseif party_count > 6 then
        console.log("⚠️ Suspicious party count: " .. party_count .. " (addresses may need adjustment)")
    else
        console.log("📭 No Pokemon in party")
    end
    
    return party_count
end

function check_wild_battle()
    local battle_flag = safe_memory_read(ADDRESSES.WILD_BATTLE, memory.read8, 0)
    if battle_flag > 0 then
        console.log("⚡ WILD BATTLE DETECTED!")
        return true
    end
    return false
end

function read_player_position()
    local x = safe_memory_read(ADDRESSES.PLAYER_X, memory.read16, 0)
    local y = safe_memory_read(ADDRESSES.PLAYER_Y, memory.read16, 0)
    
    if x > 0 or y > 0 then
        console.log("🚶 Player Position - X: " .. x .. ", Y: " .. y)
    else
        console.log("📍 Position data unavailable (may need address adjustment)")
    end
    
    return x, y
end

function toggle_monitoring()
    monitor_active = not monitor_active
    local status = monitor_active and "RESUMED" or "PAUSED"
    console.log("🔄 Monitoring " .. status)
end

function show_addresses()
    console.log("📊 Current Memory Addresses:")
    for name, addr in pairs(ADDRESSES) do
        console.log("  " .. name .. ": " .. string.format("0x%08X", addr))
    end
    console.log("💡 If data seems wrong, these addresses may need adjustment for this ROM hack")
end

function main_loop()
    if not monitor_active then return end
    
    frame_count = frame_count + 1
    
    -- Run checks every CONFIG.CHECK_INTERVAL frames (1 second at 60 FPS)
    if frame_count - last_check >= CONFIG.CHECK_INTERVAL then
        console.log("=== Pokemon Data Check (Frame " .. frame_count .. ") ===")
        
        -- Check if memory is available
        if not memory then
            console.log("❌ Memory access not available!")
            return
        end
        
        read_party_info()
        
        if check_wild_battle() then
            console.log("🎯 ENCOUNTER! Logging battle data...")
        end
        
        read_player_position()
        console.log("") -- Empty line for readability
        
        last_check = frame_count
    end
    
    -- Status update every CONFIG.STATUS_INTERVAL frames
    if frame_count % CONFIG.STATUS_INTERVAL == 0 then
        console.log("⏱️ Monitor running for " .. (frame_count / 60) .. " seconds")
    end
end

-- Initialize with dependency checking
local function initialize()
    console.log("🚀 Pokemon Minced Fusions Monitor v2.0 - Starting...")
    
    if not memory then
        console.log("❌ Memory access not available!")
        return false
    end
    
    if not callbacks or not callbacks.add then
        console.log("❌ Callback system not available!")
        return false
    end
    
    console.log("✅ Dependencies confirmed")
    console.log("📊 Monitoring party data, battles, and player position...")
    console.log("⚠️ Note: Memory addresses may need adjustment for this ROM hack")
    console.log("💡 Use show_addresses() to see current addresses")
    console.log("🔄 Use toggle_monitoring() to pause/resume")
    console.log("")
    
    return true
end

-- Main execution
if initialize() then
    -- Register the main loop to run every frame
    callbacks.add("frame", main_loop)
    console.log("✅ Monitor active!")
else
    console.log("❌ Failed to initialize monitor")
end
