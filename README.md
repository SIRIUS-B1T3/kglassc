
# kglassc

<p align="center">
  <img src="assets/preview.png" alt="kglassc Preview" width="800">
</p>

<p align="center">
  <strong>A modern, lightweight, glassmorphism-inspired digital clock plasmoid built for KDE Plasma 6.</strong>
</p>

<p align="center">
  <a href="https://kde.org/plasma-desktop/"><img src="https://img.shields.io/badge/KDE-Plasma%206-3daee9?style=for-the-badge&logo=kde&logoColor=white" alt="Plasma 6"></a>
  <a href="https://doc.qt.io/qt-6/qmlapplications.html"><img src="https://img.shields.io/badge/Qt-6%20%2F%20QML-41cd52?style=for-the-badge&logo=qt&logoColor=white" alt="Qt 6"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-GPLv3-blue.svg?style=for-the-badge" alt="License: GPL v3"></a>
  <a href="https://github.com/SIRIUS-B1T3/kglassc/releases"><img src="https://img.shields.io/github/v/release/SIRIUS-B1T3/kglassc?style=for-the-badge&color=orange" alt="Release"></a>
</p>

---

## Overview

**kglassc** (*KDE Glass Clock*) is an ultra-minimalist desktop clock designed specifically for the KDE Plasma 6 desktop environment. Utilizing smooth translucent geometries, adaptive borders, and native blur integration, it provides an elegant glanceable clock without obscuring your desktop wallpaper.

## Key Features

- **Glassmorphism Aesthetic:** Translucent backdrops, subtle highlight borders, and native blur integration.
- **Native Plasma 6 Integration:** Built entirely on modern QtQuick, Kirigami, and Plasma 6 API specifications.
- **Resource Efficient:** Pure QML implementation ensures zero idle CPU overhead and negligible memory footprints.
- **Adaptive Typography:** Dynamically scales typography according to widget dimension boundaries.
- **Configurable Formats:** Toggle 12h/24h formats, show/hide seconds, customize date strings, and adjust alpha transparency.

## Project Structure

```text
kglassc/
├── metadata.json
├── package/
│   ├── contents/
│   │   ├── config/
│   │   │   ├── config.qml
│   │   │   └── main.xml
│   │   └── ui/
│   │       ├── CompactRepresentation.qml
│   │       ├── FullRepresentation.qml
│   │       ├── configGeneral.qml
│   │       └── main.qml
│   └── metadata.desktop (legacy fallback)
├── assets/
│   └── preview.png
├── LICENSE
└── README.md
```

## Prerequisites

Ensure your system satisfies the following runtime dependencies:

- KDE Plasma >= 6.0
- KDE Frameworks >= 6.0
- Qt >= 6.6 (`qt6-declarative`, `qt6-svg`)
- `plasma-sdk` (optional, required only for debugging with `plasmoidviewer`)

### Dependency Installation on Arch / CachyOS

```bash
sudo pacman -S --needed plasma-workspace qt6-declarative plasma-sdk
```

## Installation

### Method 1: Manual Installation (Recommended for Development)

Clone the repository directly into your local Plasma plasmoids directory:

```bash
git clone https://github.com/SIRIUS-B1T3/kglassc.git ~/.local/share/plasma/plasmoids/org.sirius.plasmoid.clockpro
```

Reload Plasma shell to register the new plasmoid:

```bash
kquitapp6 plasmashell && kstart plasmashell
```

### Method 2: Plasma Package CLI

If bundled as a `.plasmoid` archive:

```bash
kpackagetool6 --type Plasma/Applet --install org.sirius.plasmoid.clockpro.plasmoid
```

To upgrade an existing installation:

```bash
kpackagetool6 --type Plasma/Applet --upgrade org.sirius.plasmoid.clockpro.plasmoid
```

## Testing & Debugging

You can run and inspect the plasmoid in an isolated container without restarting your Plasma session:

```bash
plasmoidviewer -a ~/.local/share/plasma/plasmoids/org.sirius.plasmoid.clockpro
```

To monitor console warnings or QML engine diagnostics in real time:

```bash
QT_LOGGING_RULES="plasma.applet.*=true;default.debug=true" plasmoidviewer -a org.sirius.plasmoid.clockpro
```

## Uninstallation

To remove the plasmoid completely:

```bash
rm -rf ~/.local/share/plasma/plasmoids/org.sirius.plasmoid.clockpro
rm -rf ~/.config/plasma-org.kde.plasma.desktop-appletsrc
```

Or via `kpackagetool6`:

```bash
kpackagetool6 --type Plasma/Applet --remove org.sirius.plasmoid.clockpro
```

## Roadmap

- [ ] Interactive configuration dialog for accent-color borders
- [ ] Configurable timezones and dual-clock support
- [ ] Preset profiles (Frosted Glass, Obsidian Glass, Clear Glass)
- [ ] KDE Store (Pling/OpenDesktop) official package deployment

## Contributing

Contributions, bug reports, and pull requests are welcome.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'feat: add AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the GNU General Public License v3.0. See [`LICENSE`](LICENSE) for more information.

## Author

**Mehmet Ali Yeşiltaş (SIRIUS-B1T3)**
- GitHub: [@SIRIUS-B1T3](https://github.com/SIRIUS-B1T3)

```
