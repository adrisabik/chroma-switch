# 🎮 Chroma Switch

<p align="center">
  <strong>A hyper-casual arcade game that challenges reflexes and cognitive color recognition</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Flame-1.20.0-FF6B35?logo=firebase" alt="Flame">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green" alt="Platform">
  <img src="https://img.shields.io/badge/Status-In%20Development-yellow" alt="Status">
</p>

---

## 🎯 The Hook

> **It's not just about timing jumps; it's about instant mental recalibration.**

One moment you're **Red**, safely passing through Red walls. The next moment, you pick up an orb, become **Yellow**, and must immediately rewire your brain to avoid Red and seek Yellow.

---

## ✨ Features

- 🕹️ **Tap-to-Jump** — Simple, intuitive one-finger controls
- 🌈 **Color Matching** — Pass through walls that match your color
- 🔄 **Color Switching** — Collect orbs to change colors mid-flight
- ♾️ **Infinite Climber** — Procedurally generated endless gameplay
- 💎 **Neon Aesthetics** — "Cyberpunk Zen" visual style (*Tron* meets *Geometry Wars*)
- 🎵 **Synthwave Audio** — Ambient lo-fi electronic music & crisp SFX
- ✨ **Juicy Effects** — Particle explosions, screen shake, glow shaders

---

## 🛠️ Tech Stack

| Package              | Version | Purpose              |
| -------------------- | ------- | -------------------- |
| `flame`              | ^1.20.0 | Game Engine          |
| `flame_audio`        | ^2.0.0  | SFX & BGM            |
| `flutter_riverpod`   | ^2.4.9  | UI State Management  |
| `get_it`             | ^7.6.0  | Service Locator (DI) |
| `flutter_animate`    | ^4.5.0  | Menu Animations      |
| `shared_preferences` | ^2.2.0  | High Score Storage   |

---

## 🏗️ Architecture

Chroma Switch uses a **hybrid architecture** separating:

```
┌─────────────────────────────────────┐
│           FLUTTER UI                │
│  (Overlays, HUD, Menus - Riverpod)  │
└─────────────────────────────────────┘
                  ↕
┌─────────────────────────────────────┐
│          STATE BRIDGE               │
│     (GetIt + ChangeNotifiers)       │
└─────────────────────────────────────┘
                  ↕
┌─────────────────────────────────────┐
│           FLAME GAME                │
│   (60 FPS loop, Physics, Canvas)    │
└─────────────────────────────────────┘
```

> **Rule:** No Riverpod watchers inside the `update()` loop!

---

## 🎨 Visual Style

**"Cyberpunk Zen"** — Dark, atmospheric, clean.

| Color        | Hex       | Usage      |
| ------------ | --------- | ---------- |
| 🔵 Cyan       | `#00E5FF` | Game color |
| 🔴 Magenta    | `#FF4081` | Game color |
| 🟡 Yellow     | `#FFE045` | Game color |
| 🟣 Purple     | `#7C4DFF` | Game color |
| ⬛ Background | `#212121` | Dark base  |

All visuals are **drawn programmatically** using Canvas — no sprite assets!

---

## 📁 Project Structure

```
lib/
├── main.dart                  # Entry point, GetIt setup
├── core/
│   ├── constants/             # Physics values, strings
│   ├── theme/                 # Colors, neon paint
│   └── services/              # Audio, Storage
├── game/
│   ├── chroma_game.dart       # Main Flame game class
│   ├── components/            # PlayerBall, ObstacleRing, etc.
│   ├── logic/                 # ObstacleManager, collision
│   └── effects/               # Particles, screen shake
├── ui/
│   ├── overlays/              # Start menu, Game Over
│   ├── hud/                   # Score display
│   └── shared/                # Neon buttons
└── state/
    ├── game_state_notifier.dart
    └── providers.dart
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.x
- Dart 3.x

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/chroma-switch.git
cd chroma-switch

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## 🗺️ Roadmap

- [x] Project setup & documentation
- [ ] **Phase 1:** Physics toy (gravity, jump, ball rendering)
- [ ] **Phase 2:** Visuals (ring segments, neon glow)
- [ ] **Phase 3:** Logic (color matching, infinite spawning)
- [ ] **Phase 4:** Polish (particles, audio, menus)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Inspired by **Color Switch** by Fortafy Games
- Built with [Flame Engine](https://flame-engine.org/)
- Visual style inspired by *Tron* and *Geometry Wars*

---

<p align="center">
  Made with 💜 and Flutter
</p>
