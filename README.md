
🔐 Identity Verification System for FiveM
=========================================

A configurable identity verification system designed for FiveM servers, supporting Steam, Discord roles, CFX ID, queue management, and custom launchers. Easily control who can access your server based on developer status, connected platforms, or launch methods.

⚙️ Features
-----------
- ✅ Steam Verification  
  Kick or allow players based on Steam connection.

- 👨‍💻 Developer Mode  
  Verify devs using Steam Hex or Discord roles (via bot integration).

- 🌐 CFX ID Verification  
  Ensure players are correctly connected to a CFX ID.

- ⏳ Queue System  
  Customizable queue system with priority handling and identity checks before allowing players to join.

- 🚫 Launcher Restriction  
  Prevent players from joining unless they launch the game through your defined method.

📁 Configuration Overview
--------------------------
All settings are managed in a single `config.lua` file.

Example:
```
Config.steam.master = true         -- Enable Steam check
Config.devmode.steam = true        -- Use Steam Hex for developer whitelisting
Config.devmode.discord = true      -- Use Discord role for dev access
Config.cfxid.master = true         -- Enable CFX ID verification
Config.queue.master = true         -- Enable queue system
Config.notlauch.master = true      -- Enforce custom launcher usage
```

Each section comes with localized messages for better UX and debugging.

🧩 Dependencies
----------------
This resource requires the following dependency for Discord role verification:

- [Badger_Discord_API](https://github.com/JaredScar/Badger_Discord_API)

🛠️ Installation
----------------
1. Download or clone the repository:
   git clone https://github.com/yourusername/identity-verification-fivem.git

2. Add the resource to your server.cfg:
   ensure identity-verification-fivem
