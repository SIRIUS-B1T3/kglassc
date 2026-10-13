# kglassc

<p align="center">
  <img src="assets/preview.png" alt="kglassc — KDE Plasma Glass Clock Preview" width="800">
</p>

<p align="center">
  <strong>A lightweight, minimalist digital clock plasmoid with a glass-inspired aesthetic for KDE Plasma 6.</strong>
</p>

<p align="center">
  <a href="https://kde.org/plasma-desktop/">
    <img src="https://img.shields.io/badge/KDE%20Plasma-6-3daee9?style=for-the-badge&logo=kde&logoColor=white" alt="KDE Plasma 6">
  </a>
  <a href="https://doc.qt.io/qt-6/qmlapplications.html">
    <img src="https://img.shields.io/badge/Qt-6-41cd52?style=for-the-badge&logo=qt&logoColor=white" alt="Qt 6">
  </a>
  <a href="https://doc.qt.io/qt-6/qtqml-index.html">
    <img src="https://img.shields.io/badge/Language-QML-6c9?style=for-the-badge" alt="QML">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/License-GPL--3.0-blue?style=for-the-badge" alt="GPL-3.0 License">
  </a>
  <a href="https://github.com/SIRIUS-B1T3/kglassc/releases">
    <img src="https://img.shields.io/github/v/release/SIRIUS-B1T3/kglassc?style=for-the-badge&color=orange" alt="Latest Release">
  </a>
  <a href="https://github.com/SIRIUS-B1T3/kglassc/issues">
    <img src="https://img.shields.io/github/issues/SIRIUS-B1T3/kglassc?style=for-the-badge" alt="Open Issues">
  </a>
</p>

<p align="center">
  <a href="https://github.com/SIRIUS-B1T3/kglassc/stargazers">Star the project</a>
  ·
  <a href="https://github.com/SIRIUS-B1T3/kglassc/issues">Report a bug</a>
  ·
  <a href="https://github.com/SIRIUS-B1T3/kglassc/releases">Releases</a>
</p>

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Compatibility](#compatibility)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Manual Installation](#method-1-manual-installation)
  - [Package Installation](#method-2-install-a-plasmoid-package)
- [Development and Testing](#development-and-testing)
- [Troubleshooting](#troubleshooting)
- [Uninstallation](#uninstallation)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)
- [Author](#author)

---

## Overview

**kglassc** (KDE Glass Clock) is a digital clock plasmoid designed for the KDE Plasma 6 desktop environment.

It combines a minimal clock layout with a glass-inspired visual style, using translucent surfaces, subtle borders, and typography designed to remain readable at different widget sizes.

The goal is to provide a desktop clock that complements your wallpaper instead of competing with it, while fitting naturally into a Plasma desktop workflow.

### Design Goals

- **Minimalism:** Keep the time and date at the center of the experience.
- **Visual consistency:** Follow the KDE Plasma and Qt Quick application model.
- **Adaptability:** Make the clock suitable for different widget dimensions.
- **Configurability:** Support clock display preferences where implemented.
- **Maintainability:** Keep the plasmoid's QML interface and configuration files organized.

> **Project status:** Feature availability, runtime requirements, and supported configuration options should be verified against the current source code and release. This README does not assume that planned features are already implemented.

## Features

### Visual Design

- Glass-inspired visual appearance.
- Translucent surfaces and subtle borders.
- Minimal digital clock presentation.
- Desktop-oriented layout designed to complement wallpapers.

### Plasma Integration

- Designed for KDE Plasma 6.
- Uses the Plasma applet packaging structure.
- Uses QML for the widget interface.
- Supports development and testing through Plasma development tools when installed.

### Clock and Configuration

The following capabilities are intended to describe the project where supported by the current implementation:

- 12-hour and 24-hour clock formats.
- Optional seconds display.
- Customizable date presentation.
- Adjustable transparency.
- Typography that adapts to available widget dimensions.

Check the configuration interface and source code to determine which options are available in your installed version.

### Lightweight Architecture

The project is structured as a Plasma plasmoid rather than a standalone desktop application. Its resource usage depends on the implementation, Plasma runtime, rendering behavior, and update intervals.

No specific CPU or memory consumption figures are claimed without measurements.

---

## Compatibility

| Component | Requirement |
|---|---|
| Desktop environment | KDE Plasma 6 |
| UI technology | Qt Quick / QML |
| Qt version | Qt 6; the minimum supported version must be verified against the source |
| KDE Frameworks | Version compatible with the installed Plasma release |
| Development tools | `plasma-sdk`, optional for development and testing |
| Operating system | A Linux distribution with a compatible KDE Plasma 6 installation |

Compatibility with specific distributions, Plasma releases, Wayland, X11, and individual Qt versions has not been independently verified here.

For the most reliable results, use a supported KDE Plasma 6 installation with its distribution-provided Qt and KDE Frameworks packages.

---

## Project Structure

The repository is expected to follow a structure similar to the following:

```text```
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
│   └── metadata.desktop
├── assets/
│   └── preview.png
├── LICENSE
└── README.md
```

File availability and exact filenames may differ between branches or releases. The listing above reflects the project layout provided for this README, not an independently verified repository snapshot.

### Important Files

| File or directory | Purpose |
|---|---|
| `metadata.json` | Plasmoid metadata and package identification |
| `package/contents/ui/` | QML interface components |
| `package/contents/config/` | Configuration UI and configuration schema |
| `assets/preview.png` | README preview image |
| `LICENSE` | Project licensing terms |
| `README.md` | Project documentation |

The legacy `metadata.desktop` file may be unnecessary in a Plasma 6-only package, depending on the project's packaging requirements. Verify whether it is used before removing it.

---

## Prerequisites

Before installing kglassc, ensure that you have:

- A working KDE Plasma 6 desktop session.
- The Qt and KDE runtime components required by your Plasma installation.
- Git, if installing directly from the repository.
- `plasma-sdk`, if you intend to use `plasmoidviewer` for development and testing.

The exact dependency list depends on the QML imports and APIs used by the current source code. Do not install additional Qt modules solely because they are mentioned in an unverified dependency list.

### Arch Linux and CachyOS

Install the development tools commonly used for Plasma applet development:

```bash```
sudo pacman -S --needed git plasma-sdk
```

Install any additional runtime dependencies reported by your distribution or by the QML engine when loading the plasmoid.

Package names and dependencies can vary across distributions and repository configurations.

---

## Installation

### Method 1: Manual Installation

This method is suitable for development and testing directly from a Git checkout.

#### 1. Clone the repository

```bash```
git clone https://github.com/SIRIUS-B1T3/kglassc.git
cd kglassc
```

#### 2. Verify the package metadata

Inspect `metadata.json` and identify the plasmoid's actual plugin ID.

```bash```
cat metadata.json
```

The installation directory should match the plugin ID declared by the package metadata. The repository name and plugin ID are not necessarily identical.

For example, if the actual plugin ID is `org.example.clock`, the corresponding directory would be:

```text```
~/.local/share/plasma/plasmoids/org.example.clock/
```

Replace the example ID with the value from the project's actual metadata.

#### 3. Install the package directory

After identifying the correct plugin ID, copy the package into the local Plasma plasmoids directory.

```bash```
mkdir -p ~/.local/share/plasma/plasmoids
cp -a . ~/.local/share/plasma/plasmoids/ACTUAL_PLUGIN_ID
```

Replace `ACTUAL_PLUGIN_ID` with the actual metadata ID.

Avoid copying a repository into a directory with an incorrect plugin ID, as this can complicate discovery, testing, and removal.

#### 4. Load the plasmoid

Open the Plasma desktop's widget selector, locate the installed clock, and add it to the desktop if it appears there.

If the widget does not appear, consult the troubleshooting section before restarting the entire Plasma session.

### Method 2: Install a Plasmoid Package

If a compatible `.plasmoid` archive is available from a project release, install it with the Plasma package tool.

```bash```
kpackagetool6 --type Plasma/Applet --install /path/to/kglassc.plasmoid
```

Replace `/path/to/kglassc.plasmoid` with the actual archive path.

To upgrade an existing installation:

```bash```
kpackagetool6 --type Plasma/Applet --upgrade /path/to/kglassc.plasmoid
```

These commands require a valid Plasma applet package. A Git repository directory is not automatically a `.plasmoid` archive.

Check the project's [Releases](https://github.com/SIRIUS-B1T3/kglassc/releases) page for published packages. If no archive is provided, use the manual installation method.

### Verify the Installation

List the installed applets:

```bash```
kpackagetool6 --type Plasma/Applet --list
```

If the widget is missing from the output, verify its metadata, installation path, and package structure.

---

## Development and Testing

### Test with `plasmoidviewer`

If `plasma-sdk` is installed, use `plasmoidviewer` to test the applet independently of the normal desktop widget placement.

```bash```
plasmoidviewer --help
```

Check the available command-line options for your installed Plasma SDK version.

If the tool supports the applet path argument, launch the local package using the syntax documented by that version.

For example, a commonly used invocation is:

```bash```
plasmoidviewer -a ~/.local/share/plasma/plasmoids/ACTUAL_PLUGIN_ID
```

Replace `ACTUAL_PLUGIN_ID` with the actual plugin ID.

### Inspect QML and Plasma Diagnostics

When the widget fails to load, inspect terminal output for:

- Missing QML modules.
- Invalid QML syntax.
- Unresolved imports.
- Missing files or resources.
- Invalid configuration definitions.
- Unsupported Plasma APIs.
- Errors involving package metadata.

You can enable additional Qt logging for a diagnostic run:

```bash```
QT_LOGGING_RULES="*.debug=true" plasmoidviewer -a ~/.local/share/plasma/plasmoids/ACTUAL_PLUGIN_ID
```

The logging rules may produce substantial output. Use them only when needed, and narrow the logging categories when the relevant category is known.

### Development Workflow

A practical development cycle is:

1. Make a focused change to the relevant QML or configuration file.
2. Run the plasmoid using the available development tools.
3. Inspect the output for QML and runtime errors.
4. Test the widget at different dimensions.
5. Verify configuration changes and persistence where applicable.
6. Test the result in a normal Plasma desktop session.
7. Commit the change with a descriptive message.

---

## Troubleshooting

### The Widget Does Not Appear

Check the installation path and plugin ID.

```bash```
find ~/.local/share/plasma/plasmoids -maxdepth 3 -name metadata.json -print
```

Verify that:

- The package metadata exists.
- The metadata contains the expected plugin ID.
- The package has the expected Plasma applet directory structure.
- The installed files are readable.
- The widget targets a compatible Plasma version.

### `plasmoidviewer` Is Not Found

Install the Plasma SDK package provided by your distribution.

On Arch Linux and CachyOS:

```bash```
sudo pacman -S --needed plasma-sdk
```

If the command is still unavailable, verify that the package is installed and that the executable is in your `PATH`.

### QML Import Errors

A message such as `module "..." is not installed` indicates that the QML engine cannot resolve a requested module.

Inspect the imports in the relevant QML files and install the matching distribution package if it is missing.

Do not assume that every Qt or KDE QML module is required. Install only the dependencies indicated by the actual imports and runtime diagnostics.

### The Clock or Date Is Not Displayed Correctly

Inspect the relevant QML components and verify:

- The time-formatting logic.
- The date-formatting logic.
- The selected locale.
- The widget's available dimensions.
- The visibility and sizing properties of the relevant elements.

The exact cause cannot be determined without the implementation and runtime output.

### Changes Do Not Appear

Confirm that you edited the installed copy rather than a separate Git checkout.

If the applet is already running, close and reopen the test instance or follow the appropriate reload procedure for your Plasma version.

Restarting the entire desktop shell should not be the first troubleshooting step.

### The Widget Fails to Load After an Update

Inspect the latest terminal output and compare the updated package metadata and QML imports with the previous working version.

For a manually installed copy, reinstalling into the correct plugin-ID directory may help eliminate stale files. Back up any local changes before replacing the directory.

---

## Uninstallation

### Remove a Manually Installed Copy

Replace `ACTUAL_PLUGIN_ID` with the plugin ID used during installation.

```bash```
rm -rf -- ~/.local/share/plasma/plasmoids/ACTUAL_PLUGIN_ID
```

This removes the specified plasmoid directory. Verify the path before executing the command.

### Remove a Package Installed with `kpackagetool6`

```bash```
kpackagetool6 --type Plasma/Applet --remove ACTUAL_PLUGIN_ID
```

Use the actual plugin ID from the package metadata.

### Configuration and Desktop State

Do not delete `~/.config/plasma-org.kde.plasma.desktop-appletsrc` as part of routine uninstallation.

That file can contain configuration for other Plasma widgets and desktop applets. Removing it may reset unrelated desktop settings.

If kglassc has its own configuration files, identify those files first and remove only the files associated with the widget.

---

## Roadmap

The following items are proposed enhancements, not claims about existing functionality.

- [ ] Improve configuration options for border and accent colors.
- [ ] Add configurable time zones.
- [ ] Add support for displaying multiple clocks.
- [ ] Introduce visual presets such as Frosted Glass, Obsidian Glass, and Clear Glass.
- [ ] Review accessibility, contrast, and readability at different widget sizes.
- [ ] Improve installation and development documentation.
- [ ] Prepare a distributable package for the KDE Store, subject to packaging and publishing requirements.

Roadmap items may change as the project evolves. Check the issue tracker for the current implementation status.

---

## Contributing

Contributions, bug reports, and pull requests are welcome.

Before submitting a change, verify that it works with the target Plasma environment and does not introduce new QML or packaging errors.

### Report a Bug

Open an issue through the [GitHub Issues](https://github.com/SIRIUS-B1T3/kglassc/issues) page.

When reporting a problem, include relevant details such as:

- KDE Plasma version.
- Qt version, where relevant.
- Linux distribution.
- Installation method.
- Steps to reproduce the issue.
- Expected behavior.
- Actual behavior.
- Relevant terminal output or QML errors.
- Screenshots, when they help explain a visual issue.

Remove sensitive information from logs before publishing them.

### Submit a Pull Request

1. Fork the repository.
2. Create a feature branch.
3. Implement a focused change.
4. Test the change in a compatible Plasma environment.
5. Review the diff and remove unrelated modifications.
6. Commit with a descriptive message.
7. Push the branch to your fork.
8. Open a pull request describing the change and its verification.

Example commands:

```bash```
git checkout -b feature/descriptive-name
git add .
git commit -m "feat: describe the change"
git push origin feature/descriptive-name
```

Use a commit message that accurately describes the change. Do not claim tests passed unless they were actually performed.

### Suggested Commit Convention

Conventional Commit-style prefixes can make changes easier to scan:

| Prefix | Intended use |
|---|---|
| `feat:` | New functionality |
| `fix:` | Bug fixes |
| `docs:` | Documentation changes |
| `refactor:` | Code restructuring without intended behavior changes |
| `style:` | Formatting or visual changes |
| `test:` | Test-related changes |
| `chore:` | Maintenance tasks |

These prefixes are suggestions, not a mandatory project policy.

---

## License

kglassc is identified by this project documentation as distributed under the **GNU General Public License v3.0**.

See [`LICENSE`](LICENSE) for the license text and applicable terms.

For licensing details, refer to the [GNU GPL v3.0](https://www.gnu.org/licenses/gpl-3.0.html).

---

## Author

**Mehmet Ali Yeşiltaş**

- GitHub: [@SIRIUS-B1T3](https://github.com/SIRIUS-B1T3)
- Repository: [SIRIUS-B1T3/kglassc](https://github.com/SIRIUS-B1T3/kglassc)

---

<p align="center">
  <strong>kglassc</strong>
  <br>
  A minimal glass-inspired clock for KDE Plasma 6.
</p>
