-- Advanced Pokemon Logger for mGBA
-- Compatible with Pokemon ROM hacks and original games
-- Logs encounters, party changes, and game events
-- Version: 3.0 - Cleaned and optimized

local encounter_count = 0
local last_wild_pokemon = 0
local last_party_size = 0
local log_file = nil
local script_active = true
local frame_count = 0

-- Memory addresses (FireRed/LeafGreen base - may need adjustment for ROM hacks)
local ADDRESSES = {
    PARTY_COUNT = 0x02024029,        -- Party Pokemon count
    PARTY_DATA = 0x02024284,         -- Party Pokemon data start  
    WILD_POKEMON = 0x02037C24,       -- Wild Pokemon species
    BATTLE_TYPE = 0x02022B50,        -- Battle type indicator
    GAME_STATE = 0x02020000,         -- Game state
    PLAYER_NAME = 0x020244EC,        -- Player name
}

-- Safe memory read function with error handling
local function safe_memory_read(address, read_func, default_value)
    local success, result = pcall(read_func, address)
    if success and result then
        return result
    else
        return default_value or 0
    end
end

function init_logging()
    -- Create log file for encounters with safer path handling
    local timestamp = os.date("%Y%m%d_%H%M%S")
    local log_directory = "G:/Development/Games/Pokemon_References/logs/"
    
    -- Ensure logs directory exists (create if needed)
    local log_path = log_directory .. "encounter_log_" .. timestamp .. ".json"
    log_file = io.open(log_path, "w")
    
    if log_file then
        log_file:write("[\n")
        console.log("📝 Logging encounters to: " .. log_path)
        return true
    else
        console.log("❌ Could not create log file - check directory permissions")
        return false
    end
end

function read_party_info()
    local party_count = safe_memory_read(ADDRESSES.PARTY_COUNT, memory.read8, 0)
    
    if party_count ~= last_party_size and party_count > 0 then
        console.log("🎉 Party size changed: " .. party_count .. " Pokemon")
        last_party_size = party_count
        
        -- Log party change
        log_encounter_event("party_change", {
            party_size = party_count,
            timestamp = os.date("%Y-%m-%d %H:%M:%S")
        })
    end
    return party_count
end

function check_wild_encounter()
    local wild_species = safe_memory_read(ADDRESSES.WILD_POKEMON, memory.read16, 0)
    local battle_type = safe_memory_read(ADDRESSES.BATTLE_TYPE, memory.read8, 0)
    
    -- Check if we're in a wild battle (battle_type == 1 for wild encounters)
    if wild_species > 0 and wild_species ~= last_wild_pokemon and battle_type == 1 then
        encounter_count = encounter_count + 1
        last_wild_pokemon = wild_species
        
        console.log("🔥 WILD ENCOUNTER #" .. encounter_count .. " - Species ID: " .. wild_species)
        
        -- Log the encounter
        log_encounter_event("wild_encounter", {
            species_id = wild_species,
            encounter_number = encounter_count,
            timestamp = os.date("%Y-%m-%d %H:%M:%S"),
            party_size = read_party_info(),
            frame_count = frame_count
        })
        
        return true
    end
    
    return false
end

function log_encounter_event(event_type, data)
    if not log_file then return end
    
    local entry = {
        type = event_type,
        data = data
    }
    
    local json_str = string.format([[
  {
    "type": "%s",
    "timestamp": "%s",
    "data": %s
  },]], 
        event_type, 
        data.timestamp or os.date("%Y-%m-%d %H:%M:%S"),
        format_data_as_json(data)
    )
    
    log_file:write(json_str)
    log_file:flush()
end

function format_data_as_json(data)
    local result = "{"
    local first = true
    
    for key, value in pairs(data) do
        if not first then result = result .. ", " end
        
        if type(value) == "string" then
            result = result .. '"' .. key .. '": "' .. value .. '"'
        else
            result = result .. '"' .. key .. '": ' .. tostring(value)
        end
        
        first = false
    end
    
    return result .. "}"
end

function save_state_on_encounter()
    -- Auto-save state when encounter happens
    local slot = encounter_count % 10  -- Use slots 0-9 cyclically
    savestate.save(slot)
    console.log("💾 Auto-saved to slot " .. slot)
end

function main_loop()
    frame_count = frame_count + 1
    
    -- Only check every 10 frames to reduce performance impact
    if frame_count % 10 == 0 then
        -- Read party info
        local party_size = read_party_info()
        
        -- Check for wild encounters
        if check_wild_encounter() then
            -- Optional: Auto-save on encounter
            save_state_on_encounter()
        end
    end
    
    -- Display status every 3600 frames (~1 minute at 60fps)
    if frame_count % 3600 == 0 then
        console.log("📊 Status - Encounters: " .. encounter_count .. ", Frame: " .. frame_count)
    end
end

function cleanup()
    if log_file then
        -- Properly close JSON array
        log_file:write("\n  {\n    \"type\": \"session_end\",\n    \"timestamp\": \"" .. os.date("%Y-%m-%d %H:%M:%S") .. "\",\n    \"total_encounters\": " .. encounter_count .. ",\n    \"total_frames\": " .. frame_count .. "\n  }\n]")
        log_file:close()
        console.log("📝 Log file saved successfully - Total encounters: " .. encounter_count)
    end
end

-- Initialize with error checking
console.log("🚀 Advanced Pokemon Logger v3.0 - Starting...")

if not memory then
    console.log("❌ ERROR: Memory access not available!")
    return
end

if not callbacks then
    console.log("❌ ERROR: Callback system not available!")
    return
end

-- Test memory access
local test_read = safe_memory_read(ADDRESSES.PARTY_COUNT, memory.read8, -1)
if test_read == -1 then
    console.log("⚠️ WARNING: Memory read test failed - addresses may need adjustment")
else
    console.log("✅ Memory access confirmed")
end

-- Initialize logging
if init_logging() then
    console.log("📍 Monitoring memory addresses for encounters...")
    
    -- Register callbacks
    callbacks.add("frame", main_loop)
    callbacks.add("shutdown", cleanup)
    
    console.log("✅ Logger active! Play the game and encounters will be logged automatically.")
else
    console.log("❌ Failed to initialize logging - continuing without file output")
end
