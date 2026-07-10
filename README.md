# EZOCustomSupportIcons

Independent beta addon for *The Elder Scrolls Online* that displays custom support icons for configured players, local tactical group markers, and optional icon packs without depending on `OdySupportIcons`.

¿Prefieres español? Lee el [README en español](README.es.md).
For support, bug reports, feedback or suggestions, join our Discord: https://discord.gg/ekw8zUAcRm

## Status

- Status: beta
- Version: 0.3.5
- ESO API: 101049 101050
- AddOnVersion: 10012

This beta is intended for manual testing in groups, guild rosters and companion icon packs. The public icon-pack API may still change before a stable release.

## Requirements

- The Elder Scrolls Online for PC.
- Optional: `LibAddonMenu-2.0` for the settings panel.
- Optional: `LibCustomMenu` for assigning tactical markers from the keyboard group-list context menu.

The addon works with `OdySupportIcons` disabled.

## Installation

1. Clone this repository, or use a published ZIP package when one is available.
2. Copy the `EZOCustomSupportIcons` folder into your ESO AddOns folder:

```text
Documents/Elder Scrolls Online/live/AddOns/
```

3. Make sure the manifest is located at:

```text
AddOns/EZOCustomSupportIcons/EZOCustomSupportIcons.txt
```

4. Run `/reloadui` or restart the game.

## Implemented Features

- Custom fixed icons for configured account names.
- A custom 3D overlay above visible group members in the same instance.
- Guild roster icon replacement for configured accounts.
- Account-wide SavedVariables only for global visual settings.
- LibAddonMenu settings, when `LibAddonMenu-2.0` is installed:
  - `Show head icons`
  - `Head icon size`
  - `Hide head icons in combat`
- Local, session-only tactical markers for current group members:
  - `Follow`
  - `Heal`
  - `Tank`
  - `Focus`
  - `Mechanic`
- Keyboard group-list context menu integration through `LibCustomMenu`, when installed.
- Gamepad group-list display for already assigned tactical markers.
- Public `EZOCustomSupportIcons.RegisterIconPack(...)` API for companion icon-pack addons.

## Companion Icon Packs

Companion packs are separate addons with:

```text
## DependsOn: EZOCustomSupportIcons
```

They can register fixed player icons and additional assignable marker icons. Players only see a pack's icons if they have both `EZOCustomSupportIcons` and that same pack installed.

The repository includes one source example:

```text
packs/EZOCustomSupportIcons_Hojablanca/
```

To test that pack in-game, install it as a sibling addon next to `EZOCustomSupportIcons`.

## Security and Scope Limits

- Does not depend on `OdySupportIcons`.
- Does not call `OSI.*` APIs.
- Does not modify `OdySupportIcons` or any other addon.
- Does not send data outside the game client.
- Does not use external services at runtime.
- Does not automate combat, movement, input, keybinds or gameplay decisions.
- Does not synchronize dynamic tactical markers with other players.
- Tactical markers are local, session-only and cleared when leaving or changing group.
- Head icons are rendered only in HUD scenes (`hud` / `hudui`), not over map, inventory or menus.
- ESO only exposes reliable world positions for group members; head icons are limited to grouped, visible players in the same valid instance/world context.

## Icon Files

- Recommended format: `.dds`
- Recommended size: `64x64`
- Width and height divisible by 4
- Alpha channel when transparency is needed

Use only icons you own, icons you have permission to use, clearly licensed assets, or base ESO textures referenced by `esoui/...` paths.

## Recommended Testing

Minimum beta test checklist:

- `/reloadui` completes without Lua errors.
- With a configured account in group, the icon appears above the player.
- In guild roster, the configured account icon appears.
- In settings, `Show head icons` hides/shows head icons.
- In settings, `Head icon size` changes icon size.
- In settings, `Hide head icons in combat` hides icons in combat while dead units remain visible.
- Tactical marker assignment from the keyboard group-list context menu appears above the target and in the group list.
- A marker already assigned in keyboard mode appears in the gamepad group list.
- Tactical markers clear when leaving the group or when the marked player leaves.
- Head icons are hidden on map, inventory and menu screens.
- The addon works with `OdySupportIcons` disabled.

There are no language files or localization tables in the current addon, so there is no EN/ES string parity check to run for runtime UI.

## Development Checks

Recommended local checks:

```powershell
.\tools\bump-version.ps1 -Check
git diff --check
```

Build/package is available for release preparation:

```powershell
.\scripts\ezo\build-addon-package.ps1 -Force
```

Do not generate a package unless you are preparing a build artifact.

## License

MIT - see [LICENSE](LICENSE).

Developed and maintained by Zuriplayer.
