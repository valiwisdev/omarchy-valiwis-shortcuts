# omarchy-valiwis-shortcuts

An Omarchy Quickshell plugin that displays keyboard shortcuts and CLI commands in a searchable interface.

## Features

- **Shortcuts**: Browse keyboard shortcuts for various applications (VS Code, Neovim, Terminal, Tmux, etc.)
- **Commands**: Search and copy CLI commands (Linux, Docker, Git, systemd, etc.)
- **Category filtering**: Filter shortcuts/commands by category
- **Real-time search**: Filter results as you type
- **Keyboard navigation**: Full keyboard control with arrow keys, categories, and tabs
- **Notifications**: Visual feedback when copying commands or viewing shortcuts

## Usage

Open the plugin with `Super+Ctrl+K` (or your configured keybinding).

### Keyboard Controls

| Key | Action |
|-----|--------|
| `↑↓` | Navigate through items |
| `←→` | Switch between categories |
| `Enter` | Copy command / View shortcut |
| `Ctrl+U` | Clear search |
| `Esc` | Go back / Close |
| `Ctrl+1/2` | Switch tabs (Shortcuts/Commands) |

## Configuration

Edit the JSON files to add or modify shortcuts and commands:

- `shortcuts.json` - Application keyboard shortcuts
- `commands.json` - CLI commands

### JSON Structure

```json
[
  {
    "app": "App Name",
    "icon": "nerdfont-icon",
    "categories": {
      "Category Name": [
        {
          "keys": "Ctrl+C",
          "action": "Copy"
        }
      ]
    }
  }
]
```

## Files

- `Shortcuts.qml` - Main UI component
- `ShortcutsSearch.js` - Search and filtering logic
- `components/` - Modular UI components
  - `HelpBar.qml` - Keyboard shortcuts display
  - `SearchHeader.qml` - Search input and badges
  - `TabBar.qml` - Shortcuts/Commands tabs
  - `CategoryBar.qml` - Category filter row
  - `AppList.qml` - Apps list view
  - `ShortcutList.qml` - Results list view
  - `EmptyState.qml` - Empty state message
  - `Notification.qml` - Notification panel
