# Changelog

## 0.3.8

- Registered the complete settings panel in the native `Settings > EZO` hub when EZOCore is available.
- Kept the standard LibAddonMenu panel as a standalone fallback when EZOCore is absent or rejects registration.
- Added the permanent EZO Discord feedback link to the settings panel header.

## 0.3.7

- Reformatted the LibAddonMenu panel with the shared EZO informational header style.
- Added English and Spanish LAM text for the settings panel.
- Moved general settings help to the section header tooltip and kept field-specific help on each control.

## 0.3.6

- Fixed tactical marker menu callbacks so each entry assigns its own marker reliably.
- Switched the built-in `Follow` marker to ESO's group-leader icon for better visibility.
- Added optional diagnostic logging through `LibDebugLogger`.

## 0.3.5 - Public beta

- Marked the addon as public beta.
- Independent renderer for custom icons above configured players.
- Guild roster icon support for configured accounts.
- LibAddonMenu settings for visibility, size and combat hiding.
- Local, session-only tactical markers for group members.
- Public `EZOCustomSupportIcons.RegisterIconPack(...)` API for companion icon packs.
- Source example pack `EZOCustomSupportIcons_Hojablanca`.

## 0.3.4

- Added local tactical markers from the keyboard group-list context menu.
- Added tactical marker display in the keyboard and gamepad group lists.

## 0.3.3

- Restricted head-icon rendering to HUD scenes (`hud` / `hudui`).
- Hid head icons on map, inventory and menu screens.

## 0.3.2

- Added an option to hide head icons in combat while keeping dead players visible.

## 0.3.1

- Converted the addon to an independent renderer without `OdySupportIcons`.
