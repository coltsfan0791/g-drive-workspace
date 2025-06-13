-- Auto Save State Manager for Pokemon
-- Automatically saves state before wild battles and provides hotkeys
-- Version: 2.0 - Enhanced with better error handling and safety checks

local last_battle_state = false
local save_slot = 1
local frame_count = 0
local auto_save_enabled = true

-- Configuration
local CONFIG = {
    BATTLE_ADDR = 0x02022B50,  -- Wild battle address
    MAX_SAVE_SLOTS = 9,        -- Maximum save slots to cycle through
    CHECK_INTERVAL = 10,       -- Check every N frames for performance
    QUICK_SAVE_SLOT = 0        -- Dedicated quick save slot
}

-- Safe memory read function
local function safe_memory_read(address, default_value)
    if not memory or not memory.read8 then
        return default_value or 0
    end
    
    local success, result = pcall(memory.read8, address)
    return success and result or (default_value or 0)
end

-- Safe save state function
local function safe_save_state(slot)
    if not savestate or not savestate.save then
        console.log("❌ Save state functionality not available")
        return false
    end
    
    local success, result = pcall(savestate.save, slot)
    if success then
        console.log("💾 Saved state to slot " .. slot)
        return true
    else
        console.log("❌ Failed to save state to slot " .. slot .. ": " .. tostring(result))
        return false
    end
end

function auto_save_before_battle()
    if not auto_save_enabled then return end
    
    frame_count = frame_count + 1
    
    -- Only check every CONFIG.CHECK_INTERVAL frames for performance
    if frame_count % CONFIG.CHECK_INTERVAL ~= 0 then
        return
    end
    
    local battle_flag = safe_memory_read(CONFIG.BATTLE_ADDR, 0)
    local current_battle_state = battle_flag > 0
    
    -- If entering a battle (state changed from false to true)
    if current_battle_state and not last_battle_state then
        console.log("🎯 ENTERING BATTLE! Auto-saving to slot " .. save_slot)
        
        if safe_save_state(save_slot) then
            -- Cycle through save slots 1-CONFIG.MAX_SAVE_SLOTS
            save_slot = save_slot + 1
            if save_slot > CONFIG.MAX_SAVE_SLOTS then
                save_slot = 1
            end
        end
    end
    
    last_battle_state = current_battle_state
end

-- Enhanced hotkey functions
function quick_save()
    if safe_save_state(CONFIG.QUICK_SAVE_SLOT) then
        console.log("⚡ Quick Save successful")
    end
end

function quick_load()
    if not savestate or not savestate.load then
        console.log("❌ Load state functionality not available")
        return false
    end
    
    local success, result = pcall(savestate.load, CONFIG.QUICK_SAVE_SLOT)
    if success then
        console.log("📁 Quick Load successful")
        return true
    else
        console.log("❌ Quick Load failed: " .. tostring(result))
        return false
    end
end

function toggle_auto_save()
    auto_save_enabled = not auto_save_enabled
    local status = auto_save_enabled and "ENABLED" or "DISABLED"
    console.log("🔄 Auto-save " .. status)
end

function save_to_specific_slot(slot)
    if slot < 0 or slot > 99 then
        console.log("❌ Invalid slot number: " .. slot .. " (must be 0-99)")
        return false
    end
    
    return safe_save_state(slot)
end

function show_status()
    console.log("📊 Auto Save Manager Status:")
    console.log("  Auto-save: " .. (auto_save_enabled and "ENABLED" or "DISABLED"))
    console.log("  Next slot: " .. save_slot)
    console.log("  Frames processed: " .. frame_count)
    console.log("  In battle: " .. (last_battle_state and "YES" or "NO"))
end

-- Initialize and check dependencies
local function initialize()
    console.log("🔧 Auto Save Manager v2.0 - Initializing...")
    
    -- Check required functions
    local missing_features = {}
    
    if not memory or not memory.read8 then
        table.insert(missing_features, "memory access")
    end
    
    if not savestate or not savestate.save or not savestate.load then
        table.insert(missing_features, "save state functionality")
    end
    
    if not callbacks or not callbacks.add then
        table.insert(missing_features, "callback system")
    end
    
    if #missing_features > 0 then
        console.log("❌ Missing required features: " .. table.concat(missing_features, ", "))
        console.log("⚠️ Auto Save Manager may not function properly")
        return false
    end
    
    console.log("✅ All required features available")
    return true
end

-- Main initialization
if initialize() then
    -- Register callbacks
    if callbacks and callbacks.add then
        callbacks.add("frame", auto_save_before_battle)
        console.log("✅ Auto Save Manager Active!")
        console.log("💾 Will auto-save before each wild battle (slots 1-" .. CONFIG.MAX_SAVE_SLOTS .. ")")
        console.log("⚡ Manual commands: quick_save(), quick_load(), toggle_auto_save(), show_status()")
    end
else
    console.log("❌ Auto Save Manager failed to initialize")
end
