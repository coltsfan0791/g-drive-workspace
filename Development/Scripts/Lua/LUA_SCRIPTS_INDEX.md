# mGBA Lua Scripts Collection - v3.0

A curated and optimized collection of Lua scripts for mGBA emulator, focused on Pokemon game automation, monitoring, and ROM hack testing.

## 📁 Script Index

### 🔍 **Discovery & Testing**

- **mgba_api_discovery.lua** - Enhanced API discovery with safety checks and comprehensive testing
- **rom_hack_validator.lua** - Advanced ROM hack compatibility validation with detailed reporting

### 📊 **Pokemon Monitoring**

- **advanced_pokemon_logger.lua** - Comprehensive Pokemon encounter logging with JSON output and error handling
- **pokemon_minced_fusions_monitor.lua** - Real-time monitoring optimized for Pokemon fusion ROM hacks

### 💾 **Utility Scripts**

- **auto_save_manager.lua** - Intelligent save state management with hotkeys and battle detection

## 🚀 Usage Instructions

### Loading Scripts in mGBA
1. Open mGBA emulator
2. Go to `Tools > Scripting`
3. Click `Load Script...`
4. Select desired `.lua` file from this directory
5. Script will auto-execute and display output in console

### Script Categories

#### **API Discovery (Start Here)**
Use `mgba_api_discovery.lua` first to understand what functions are available in your mGBA version and test compatibility.

#### **Pokemon Game Monitoring**
- Load ROM/ROM hack in mGBA
- Run appropriate monitoring script
- Check console output for real-time data
- Logs are saved to `G:/Development/Games/Pokemon_References/logs/`

#### **ROM Hack Testing**
- Load ROM hack to test
- Run `rom_hack_validator.lua`
- Review detailed compatibility report in console

## 🛠️ Script Details

### mgba_api_discovery.lua (v2.0)
**Purpose:** Enhanced API discovery with comprehensive testing  
**New Features:** 
- Safe function testing with error handling
- Multiple memory address testing
- Enhanced output formatting
- Interactive testing functions
**Usage:** Run first to understand available functions  
**Commands:** `read_party_safely()`, `show_game_info()`

### advanced_pokemon_logger.lua (v3.0)
**Purpose:** Comprehensive Pokemon encounter and party monitoring  
**New Features:**
- Enhanced error handling and safety checks
- Improved JSON logging format
- Performance optimizations (checks every 10 frames)
- Better path management for log files
- Session tracking with frame counts
**Output:** JSON logs in `Pokemon_References/logs/`
**Usage:** Load and play - automatically logs encounters

### pokemon_minced_fusions_monitor.lua (v2.0)
**Purpose:** Real-time monitoring optimized for Pokemon fusion hacks  
**New Features:**
- Enhanced error handling for ROM hack compatibility
- Address validation and adjustment warnings
- Pause/resume functionality
- Better data validation
**Commands:** `toggle_monitoring()`, `show_addresses()`

### auto_save_manager.lua (v2.0)
**Purpose:** Intelligent save state management with battle detection  
**New Features:**
- Enhanced safety checks and error handling
- Configurable settings (save slots, intervals)
- Additional hotkey functions
- Status monitoring and reporting
**Commands:** `quick_save()`, `quick_load()`, `toggle_auto_save()`, `show_status()`

### rom_hack_validator.lua (v2.0)
**Purpose:** Advanced ROM hack compatibility testing  
**New Features:**
- Expanded ROM hack detection database
- Multiple signature matching
- Enhanced memory testing with fallbacks
- Detailed compatibility reporting
- Better error handling
**Usage:** Load ROM hack, run script, review detailed report
**Compatible:** FireRed/LeafGreen base, ROM hacks with similar memory layout  
**Output:** Detailed logging of Pokemon game state changes

### pokemon_minced_fusions_monitor.lua
**Purpose:** Specialized monitoring for Pokemon fusion ROM hacks  
**Features:** Fusion detection, advanced stat tracking  
**Output:** Fusion-specific event logging

### auto_save_manager.lua
**Purpose:** Automated save state management  
**Features:** Periodic saves, multiple save slots, crash recovery  
**Usage:** Set interval and let it run in background

### rom_hack_validator.lua
**Purpose:** Test ROM hack compatibility with mGBA  
**Features:** Memory access tests, save functionality validation  
**Output:** Comprehensive compatibility report

## ⚙️ Configuration

Most scripts include configuration options at the top of the file:

```lua
-- Example configuration
local CONFIG = {
    LOG_INTERVAL = 1000,    -- Milliseconds between checks
    SAVE_INTERVAL = 30000,  -- Auto-save interval
    DEBUG_MODE = false,     -- Enable debug output
}
```

## 🔧 Troubleshooting

### Common Issues
1. **Script won't load** - Check mGBA version supports Lua
2. **No output** - Verify ROM is loaded and running
3. **Incorrect data** - Memory addresses may need adjustment for ROM hacks

### Memory Address Updates
ROM hacks may use different memory layouts. Check script comments for address customization.

## 📋 Best Practices

1. **Test with known good ROMs** first
2. **Use API discovery** before running monitoring scripts  
3. **Check console output** for errors and warnings
4. **Backup save files** before running automated scripts
5. **Adjust memory addresses** for ROM hacks as needed

---

**Last Updated:** June 13, 2025  
**mGBA Version:** 0.10.3+  
**Script Count:** 5 optimized scripts  
**Status:** Cleaned and consolidated
