# 📘 Skeezle NewsAlert (Qbox + ox_lib)

**Author:** Skeezle
**Version:** 3.0.0  
**Description:**  
A lightweight Qbox-compatible script that lets staff send Weazel News–style broadcast banners to everyone on the server using an `ox_lib` input dialog.

---

## ⚙️ Installation

1. **Download & Extract**
   - Unzip the file `skeezle-newsalert.zip`.
   - Move the entire folder **`skeezle-newsalert`** into your server’s `resources/` directory.

   Example:
   ```
   server/
   └── resources/
       └── skeezle-newsalert/
   ```

2. **Add to Server Config**
   Add these lines to your `server.cfg` (in this order):
   ```cfg
   ensure ox_lib
   ensure skeezle-newsalert
   ```

3. **Set Permissions (ACE)**
   Control who can send alerts with these options:

   **Option A: Allow everyone (for testing)**
   ```cfg
   add_ace builtin.everyone newsalert.use allow
   ```

   **Option B: Admin only**
   ```cfg
   add_ace group.admin newsalert.use allow
   add_principal identifier.steam:110000112345678 group.admin
   ```
   > Replace the Steam ID above with your own.

---

## 🕹️ Usage

Run this in-game:
```
/newsalert
```
An ox_lib dialog will appear. Type your message and duration (seconds). The banner will display for all players.

---

## ⚙️ Configuration

Edit **`config.lua`** to adjust behavior:

| Setting | Description |
|----------|--------------|
| `Enabled` | Turns the command on/off |
| `AcePermission` | ACE permission required |
| `CooldownSeconds` | Time between alerts |
| `ShowCooldownNotification` | Notify sender if on cooldown |
| `DefaultTitle`, `DefaultMessage`, `DefaultBottomMessage` | Default banner text |
| `DefaultTime` | Default duration in seconds |

---

## 🌐 Developer Notes

- Works with **Qbox** and standalone (no QBCore required)  
- Requires **ox_lib** (must load before this resource)  
- Other scripts can trigger alerts with:
  ```lua
  exports['skeezle-newsalert']:createNews('City Power Restored', 8)
  exports['skeezle-newsalert']:removeNews()
  ```

---

## 🧩 File Structure

```
Skeezle-newsalert/
├─ fxmanifest.lua
├─ config.lua
├─ client/
│  └─ main.lua
├─ server/
│  └─ main.lua
└─ html/
   ├─ index.html
   ├─ script.js
   └─ style.css
```

---

## ✅ Credits

- **Concept:** Skeezle

## License

This project is licensed under the MIT License. You are free to use, modify, and distribute this script, including for commercial use, as long as the original license notice is included.

