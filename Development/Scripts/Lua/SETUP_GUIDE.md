# BizHawk GBA Lua Emulator Setup Guide

## 🎮 **Installation Complete!**

BizHawk 2.10 has been successfully installed and configured in your development workspace.

## 📍 **Installation Location**
- **BizHawk Emulator**: `G:\Tools\BizHawk\`
- **Main Executable**: `G:\Tools\BizHawk\EmuHawk.exe`
- **Lua Scripts**: `G:\Development\Python\LuaScripts\GBA\`

## 🚀 **Getting Started**

### 1. **Launch BizHawk**
```powershell
# Navigate to BizHawk directory
cd "G:\Tools\BizHawk"

# Launch the emulator
.\EmuHawk.exe
```

### 2. **Configure for GBA**
1. Open BizHawk (`EmuHawk.exe`)
2. Go to **Config** → **Cores** → **Game Boy Advance**
3. Select **mGBA** as the core (best for accuracy and Lua support)
4. Click **OK**

### 3. **Load a GBA ROM**
1. **File** → **Open ROM**
2. Select your GBA ROM file (`.gba` extension)
3. The game should start running

### 4. **Load Lua Scripts**
1. **Tools** → **Lua Console**
2. Click **Script** → **Open Script**
3. Navigate to `G:\Development\Python\LuaScripts\GBA\`
4. Select either:
   - `gba_basic_monitor.lua` - Basic memory monitoring
   - `pokemon_monitor.lua` - Pokemon-specific features

## 🔧 **Available Lua Scripts**

### **Basic Monitor (`gba_basic_monitor.lua`)**
- **Features**:
  - Real-time memory reading
  - Frame counter display
  - Auto-save every minute
  - Manual save with 'S' key
- **Controls**:
  - `S` - Manual save state
  - `L` - Load last save (implement as needed)

### **Pokemon Monitor (`pokemon_monitor.lua`)**
- **Features**:
  - Pokemon party display with HP/Level
  - Color-coded HP status (Red/Yellow/Green)
  - Player money tracking
  - Encounter logging for Nuzlocke runs
  - Auto-faint detection and logging
- **Controls**:
  - `E` - Log wild Pokemon encounter
  - `S` - Save state
- **Log Files**:
  - `encounter_log.txt` - Wild encounters
  - `faint_log.txt` - Fainted Pokemon (RIP log)

## 🎯 **BizHawk Features for GBA**

### **Core Features**
- **Save States**: F5-F12 for quick save/load
- **Speed Control**: Hold Tab for fast-forward
- **Frame Advance**: Backslash (`\`) for frame-by-frame
- **Recording**: Tools → Movie for TAS recording
- **Cheats**: Tools → Cheats for GameShark codes

### **Lua Scripting Capabilities**
- **Memory Access**: Read/write any memory address
- **Input Injection**: Automate controller inputs
- **GUI Overlay**: Display custom information
- **File I/O**: Log data to files
- **Save State Management**: Automated saves
- **Frame-perfect timing**: Execute on specific frames

## 🛠️ **Memory Address Finding**

### **Using BizHawk's Tools**
1. **Tools** → **Hex Editor** → **System Bus**
2. **Tools** → **RAM Watch** (monitor specific addresses)
3. **Tools** → **RAM Search** (find addresses by value changes)

### **Common GBA Memory Regions**
- **EWRAM**: `0x02000000` - `0x0203FFFF` (External Work RAM)
- **IWRAM**: `0x03000000` - `0x03007FFF` (Internal Work RAM)
- **Save RAM**: `0x0E000000` - `0x0E00FFFF` (Game saves)

## 📝 **Customizing Scripts**

### **Memory Addresses**
Different games use different memory layouts. To find addresses for your specific game:

1. **Use RAM Search**:
   - Search for values that change (HP, money, etc.)
   - Narrow down until you find the exact address

2. **Update Script Variables**:
```lua
-- Update these addresses for your specific game
local player_hp_addr = 0x02000000  -- Replace with actual address
local player_money_addr = 0x02000004  -- Replace with actual address
```

3. **Test and Verify**:
   - Run the script and verify readings are correct
   - Adjust addresses as needed

## 🎮 **Recommended Games for Testing**

### **Pokemon Games** (Great for scripting)
- Pokemon Ruby/Sapphire/Emerald
- Pokemon FireRed/LeafGreen
- (Memory addresses vary between versions)

### **Other Popular GBA Games**
- The Legend of Zelda: The Minish Cap
- Metroid: Fusion / Zero Mission
- Golden Sun series
- Fire Emblem series

## 🔗 **Useful Resources**

### **Documentation**
- [BizHawk Documentation](https://tasvideos.org/Bizhawk)
- [Lua Scripting Guide](https://tasvideos.org/Bizhawk/LuaFunctions)
- [GBA Memory Map](https://problemkaputt.de/gbatek.htm)

### **Community**
- [TASVideos Forum](https://tasvideos.org/Forum/Topics/22738)
- [BizHawk GitHub](https://github.com/TASEmulators/BizHawk)
- [Pokemon ROM Hacking Community](https://www.pokecommunity.com/)

## 🚨 **Important Notes**

### **Legal ROM Usage**
- Only use ROMs you legally own
- Dump your own cartridges when possible
- Respect copyright laws

### **Performance Tips**
- Use mGBA core for best Lua compatibility
- Limit GUI drawing calls in scripts for better performance
- Save states frequently during script development

### **Script Development**
- Test scripts on different games/versions
- Add error handling for memory access
- Comment your code for future reference

## 🎉 **Ready to Script!**

Your BizHawk GBA Lua emulator setup is complete! You now have:

✅ **BizHawk 2.10** - Latest version with all features  
✅ **mGBA Core** - Best GBA emulation accuracy  
✅ **Lua Scripts** - Ready-to-use examples  
✅ **VS Code Integration** - Lua syntax highlighting  
✅ **Organized Workspace** - Professional development setup  

Happy emulating and scripting! 🎮✨
