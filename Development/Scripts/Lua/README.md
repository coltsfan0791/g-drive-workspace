# mGBA with Lua Scripting Setup

## 🎮 **mGBA Emulator Installed!**

**Location**: `G:\Tools\mGBA\mGBA-0.10.3-win64\`
**Executable**: `mGBA.exe` (GUI) or `mgba-sdl.exe` (CLI)

## 🔧 **Lua Scripting Features**

mGBA includes powerful Lua scripting capabilities for:
- Memory reading/writing
- Save state automation
- Input automation
- Screenshot capture
- Game-specific logic

## 📝 **Using Lua Scripts**

### Launch mGBA with Lua Script:
```powershell
cd "G:\Tools\mGBA\mGBA-0.10.3-win64"
.\mGBA.exe --script "G:\Development\Python\LuaScripts\pokemon_encounter_logger.lua" "path\to\your\rom.gba"
```

### Available Lua APIs in mGBA:
- `memory.read8(address)` - Read 8-bit value
- `memory.read16(address)` - Read 16-bit value  
- `memory.read32(address)` - Read 32-bit value
- `memory.write8(address, value)` - Write 8-bit value
- `console.log(message)` - Print to console
- `callbacks.add("frame", function)` - Run function every frame
- `savestate.save(slot)` - Save state
- `savestate.load(slot)` - Load state

## 🎯 **Integration with Your Projects**

### Pokemon Nuzlocke Automation
Your existing Python automation in `PokemonNuzlockeEmu` can work alongside mGBA:
1. **Python scripts** handle file operations, logging, GUI
2. **Lua scripts** handle real-time memory reading in mGBA
3. **Communication** via files or named pipes

### Example Workflow:
1. Launch mGBA with Lua script
2. Lua script monitors Pokemon encounters
3. Lua writes encounter data to file
4. Python automation reads file and processes data

## 🚀 **Why This is the Best Choice:**

✅ **No compilation needed** - Ready to use immediately
✅ **Excellent Lua support** - Full scripting API
✅ **Active development** - Regular updates and bug fixes  
✅ **Lightweight** - Fast performance
✅ **Perfect for automation** - Ideal for your Pokemon projects

## 🔗 **Quick Commands:**

```powershell
# Navigate to mGBA
cd "G:\Tools\mGBA\mGBA-0.10.3-win64"

# Launch with GUI
.\mGBA.exe

# Launch with Lua script
.\mGBA.exe --script "G:\Development\Python\LuaScripts\pokemon_encounter_logger.lua"

# Launch CLI version
.\mgba-sdl.exe
```

Your mGBA setup is ready for Lua scripting! 🎉
