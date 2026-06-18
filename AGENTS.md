# EZOCustomSupportIcons - AI Development Rules

Este proyecto es un addon-pack para The Elder Scrolls Online (ESO).

Su objetivo es aportar iconos personalizados a `OdySupportIcons` sin modificar directamente `OdySupportIcons`.

## Alcance

- Addon independiente: `EZOCustomSupportIcons`.
- Dependencia directa: `OdySupportIcons`.
- Registra listas de iconos con `OSI.AddCustomIconPack`.
- Puede registrar iconos unicos por cuenta con `OSI.AddUniqueIconPack`.
- No crea UI propia.
- No usa SavedVariables.
- No toca input ni keybindings.

## Reglas obligatorias

- No modificar `OdySupportIcons` directamente.
- No copiar assets de terceros sin licencia clara.
- Mantener los `.dds` en `icons/`.
- Si se anade un archivo runtime, anadirlo a `EZOCustomSupportIcons.txt`.
- Evitar globals innecesarias; usar `EZOCustomSupportIcons = EZOCustomSupportIcons or {}`.
- No publicar en Discord sin autorizacion explicita.
- No hacer push sin autorizacion explicita.

## Iconos

- Usar `.dds`.
- Preferir 64x64 para iconos simples.
- Anchura y altura deben ser divisibles por 4.
- Si hay transparencia, exportar con canal alpha.
- Mantener rutas exactas tipo `EZOCustomSupportIcons/icons/nombre.dds`.

## Versionado

Para cambios visibles del addon:

- `.\tools\bump-version.ps1 -Patch`
- o `.\tools\bump-version.ps1 -Version x.y.z`

La version visible debe quedar sincronizada entre:

- `EZOCustomSupportIcons.txt` (`## Version`)
- `modules/core.lua` (`EZOCustomSupportIcons.ADDON_VERSION`)
- `ezo-addon.json` (`addon.version` y `package.zipName`)

Antes de commit:

- `.\tools\bump-version.ps1 -Check`
- `git diff --check`

## Checklist de pruebas

- `OdySupportIcons` activo.
- `/reloadui`.
- Sin errores Lua al cargar.
- Clic derecho en grupo/guild/friends -> `Assign Custom Icon`.
- Los iconos del pack aparecen en el selector.
- Si se usa `AddUniqueIconPack`, confirmar que la cuenta afectada muestra el icono.
