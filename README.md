# 🥒 OmaPets — Rick & Morty Edition (Dimension C-137)

A retro sci-fi desktop pet for [Omarchy](https://omarchy.org) running natively on **Quickshell + Wayland / Hyprland**, inspired by classic virtual pets and Codex-style sprite companions.

Spawned straight out of a green bubbling cloning vat in Rick's garage lab, **Pickle Rick** lives right in your top bar, roams your desktop through green portals, and actively scales the sides of your Hyprland application windows.

---

## ⚡ Ultra-Low Resource Usage (< 15 MB)

Unlike VS Code or Electron webview pets that eat 150MB–300MB of RAM and spin up a browser runtime, **OmaPets** is engineered specifically for **low-spec Linux PCs**:
* **Shared Native Runtime:** Runs directly inside the existing Omarchy C++ QtQuick / QML environment.
* **Near 0% Idle CPU:** Lazy timers, event-driven animation ticks, and zero heavy polling subshells.
* **Click-Through Wayland Layershell:** Uses Wayland input regions (`Region { item: sprite }`) so only the pet is clickable; all clicks pass directly through to your underlying code editors and browser windows.
* **Crisp 24×24 Pixel Art:** Tiny asset footprint (under 50 KB total) with nearest-neighbor crisp scaling.

---

## 🧪 The Garage Lab & Sci-Fi Needs

Click Pickle Rick in your top bar to open Rick's Garage Lab card:

| Need | Metric | What Causes It | Solution |
| :--- | :--- | :--- | :--- |
| **Serum / Energy** | Hunger | Depletes over active time — faster when Arch updates are pending in Dimension C-137 | Hit **Feed** to pump battery serum & Szechuan sauce |
| **Decontamination** | Hygiene | Builds up over time — faster when orphaned packages linger | **Press and scrub** Pickle Rick with your mouse cursor to wipe off sewer grime |
| **Cryo Stasis** | Energy | Depletes during activities and roaming | Naps in the garage lab or passes out on the spot when exhausted |
| **Portal Roam** | Fun / Boredom | Builds up while trapped indoors | Click **Open Portal** to send him out to roam and conquer windows |
| **Respect** | Affection | Increases with neglect or hard drops | Click or middle-click to high-five, burp, or cuddle |

---

## 🛸 Multi-Dimensional Roaming & Window Climbing

* **Window Platforms:** Any active Hyprland window on your workspace becomes a walkable platform via direct Hyprland IPC.
* **Window Climbing:** Walks up to window borders and scales the wall with rat limbs.
* **Riding Windows:** Move or resize a window and Pickle Rick rides along on its titlebar.
* **Grab & Carry:** Click and drag him by the scruff across monitors or drops.
* **High Fall & Stun:** Drop him from high up and he lands stunned with circling dizzy stars.
* **Green Portal Transport:** Open portal sends him through a green vortex to the floor; recall beams him back home.

---

## 🎨 Codex-Style Pixel Art & Custom Pet Creator

OmaPets supports both full-color pixel art and 1-bit dynamic theme tinting.

### 1. Generating Rick & Morty Assets
You can regenerate the entire sprite set at any time:
```bash
python3 tools/generate_rick_assets.py
```

### 2. Creating Your Own Custom Pets from Images
We included a CLI tool to convert any character image into an OmaPets pixel-art sprite:
```bash
python3 tools/image_to_pixel_pet.py path/to/alien.png assets/sprites/alien_idle_a.png --size 24 --colors 16
```
Options:
* `--size 24`: Target grid size (24×24 or 32×32)
* `--colors 16`: Color quantization palette limit to keep retro pixel contrast
* `--no-trim`: Keep original image margins

---

## 📦 Installation & Development Setup

### Link to Omarchy:
```bash
ln -s /home/maen/Builds/pet ~/.config/omarchy/plugins/maen.omapets
```

### Add to Bar:
Open Omarchy Settings ➔ Top Bar ➔ Add Widget ➔ Select **OmaPets**.

### State Files:
* `~/.local/state/omarchy/omapets-settings.json`
* `~/.local/state/omarchy/omapets-state.json`

---

## 📜 License
MIT License. Created by MaenExists.
