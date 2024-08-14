# Devm Cinematic Camera

This FiveM script allows players to activate a free camera mode, capture screenshots, and automatically upload them to a specified webhook using the FiveManage API Instead Of Having To Download The Picture And Upload It Manually. The script includes configurable options for permissions, API keys, and webhook URLs.

Find us here https://discord.gg/devm

## Dependencies

This script relies on several dependencies to function correctly. Below is a list of these dependencies, what they do, and where you can find them.

### 1. **[ox_lib](https://github.com/overextended/ox_lib)**
   - **What it does:** `ox_lib` provides a collection of utilities and functions that enhance script development for FiveM servers. In this script, it's used for the UI, notifications, and command handling.
   - **Installation:** Follow the instructions on the [ox_lib GitHub page](https://github.com/overextended/ox_lib) to download and install the resource.

### 2. **[screenshot-basic](https://github.com/citizenfx/screenshot-basic)**
   - **What it does:** This resource allows scripts to capture and upload screenshots directly from the client or server. It's used in this script to take screenshots in freecam mode and upload them to a specified URL.
   - **Installation:** Download and install the resource from the [screenshot-basic GitHub page](https://github.com/citizenfx/screenshot-basic).

### 3. **[FiveManage API](https://www.fivemanage.com)**
   - **What it does:** The FiveManage API is used to upload screenshots taken in-game and retrieve the URL, streamlining the process of sharing screenshots.
   - **Installation:** Sign up for an account and obtain an API key from the [FiveManage website](https://www.fivemanage.com).

## Configuration

To set up the script for your server, you'll need to configure your API keys and webhook URL. These are critical for uploading screenshots to the desired destination.

### **`config.lua`**

Here is how you can configure the script:

```lua
Config = {}

-- Freecam Settings
Config.Speed = 1.0             -- Default speed of the freecam
Config.MaxDistance = 100.0     -- Maximum distance the freecam can travel
Config.Precision = 2.0         -- Precision for camera rotation

-- Permissions
Config.Permissions = true

```

### **`server_config.lua`**

Here is how you can configure the script:

```lua
SvConfig = {}

-- API Key for FiveManage
SvConfig.ApiKey = "YOUR_API_KEY_HERE"

-- Webhook URL for Discord
SvConfig.WebhookUrl = "YOUR_WEBHOOK_URL_HERE"

-- List of allowed Steam hexes
SvConfig.AllowedSteamHexes = {
    "steam:000000000000000",
    "steam:000000000000000"
}
```

Future Updates

Stay tuned for more features and improvements in upcoming versions.

License

This project is licensed under the MIT License. See the LICENSE file for more details.

Contributing

We welcome contributions! Feel free to fork the repository, make changes, and submit a pull request.
