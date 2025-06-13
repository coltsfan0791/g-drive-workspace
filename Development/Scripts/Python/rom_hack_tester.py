#!/usr/bin/env python3
"""
ROM Hack Testing Script for mGBA and BizHawk
Automatically tests ROM hacks with various emulators and configurations
"""

import os
import subprocess
import sys
from pathlib import Path

class ROMHackTester:
    def __init__(self):
        self.development_root = Path("G:/Development")
        self.mgba_path = self.development_root / "Tools/mGBA/mGBA-0.10.3-win64/mGBA.exe"
        self.bizhawk_path = self.development_root / "Tools/BizHawk/EmuHawk.exe"
        self.rom_hack_dir = self.development_root / "Games/Pokemon_References/ROM_Hacks"
        
    def test_rom_with_mgba(self, rom_path):
        """Test a ROM file with mGBA emulator"""
        if not self.mgba_path.exists():
            print(f"❌ mGBA not found at {self.mgba_path}")
            return False
            
        print(f"🎮 Testing {rom_path.name} with mGBA...")
        try:
            subprocess.run([str(self.mgba_path), str(rom_path)], check=True)
            print(f"✅ Successfully launched {rom_path.name} with mGBA")
            return True
        except subprocess.CalledProcessError as e:
            print(f"❌ Failed to launch {rom_path.name} with mGBA: {e}")
            return False
    
    def test_rom_with_bizhawk(self, rom_path):
        """Test a ROM file with BizHawk emulator"""
        if not self.bizhawk_path.exists():
            print(f"❌ BizHawk not found at {self.bizhawk_path}")
            return False
            
        print(f"🎮 Testing {rom_path.name} with BizHawk...")
        try:
            subprocess.run([str(self.bizhawk_path), str(rom_path)], check=True)
            print(f"✅ Successfully launched {rom_path.name} with BizHawk")
            return True
        except subprocess.CalledProcessError as e:
            print(f"❌ Failed to launch {rom_path.name} with BizHawk: {e}")
            return False
    
    def scan_rom_hacks(self):
        """Scan for ROM hack files in the designated directory"""
        rom_extensions = ['.gba', '.gbc', '.gb', '.nds', '.z64', '.n64']
        rom_files = []
        
        for ext in rom_extensions:
            rom_files.extend(self.rom_hack_dir.rglob(f"*{ext}"))
        
        return rom_files
    
    def test_all_roms(self):
        """Test all ROM files with both emulators"""
        rom_files = self.scan_rom_hacks()
        
        if not rom_files:
            print("⚠️ No ROM files found in ROM_Hacks directory")
            return
        
        print(f"🔍 Found {len(rom_files)} ROM files to test")
        
        for rom_file in rom_files:
            print(f"\n📁 Testing: {rom_file.name}")
            
            # Test with mGBA (for GBA/GBC files)
            if rom_file.suffix.lower() in ['.gba', '.gbc', '.gb']:
                self.test_rom_with_mgba(rom_file)
            
            # Test with BizHawk (supports multiple systems)
            self.test_rom_with_bizhawk(rom_file)
    
    def validate_emulator_setup(self):
        """Validate that emulators are properly configured"""
        print("🔧 Validating emulator setup...")
        
        mgba_valid = self.mgba_path.exists()
        bizhawk_valid = self.bizhawk_path.exists()
        
        print(f"mGBA: {'✅ Found' if mgba_valid else '❌ Missing'}")
        print(f"BizHawk: {'✅ Found' if bizhawk_valid else '❌ Missing'}")
        
        return mgba_valid and bizhawk_valid

def main():
    tester = ROMHackTester()
    
    print("🎮 ROM Hack Testing Tool")
    print("=" * 40)
    
    if not tester.validate_emulator_setup():
        print("❌ Emulator setup validation failed!")
        sys.exit(1)
    
    choice = input("\nChoose an action:\n1. Test all ROM hacks\n2. Scan for ROM files\n3. Exit\nChoice: ")
    
    if choice == "1":
        tester.test_all_roms()
    elif choice == "2":
        rom_files = tester.scan_rom_hacks()
        print(f"\n📊 Found {len(rom_files)} ROM files:")
        for rom_file in rom_files:
            print(f"  - {rom_file.name}")
    elif choice == "3":
        print("👋 Goodbye!")
    else:
        print("❌ Invalid choice!")

if __name__ == "__main__":
    main()
