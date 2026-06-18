# EZOCustomSupportIcons

Addon-pack de la familia EZO para registrar iconos personalizados en `OdySupportIcons`.

Este addon no modifica `OdySupportIcons`. Solo carga rutas de iconos `.dds` y las registra mediante las APIs publicas expuestas por Ody:

- `OSI.AddCustomIconPack(icons)`
- `OSI.AddUniqueIconPack(icons)`

## Uso

1. Coloca los `.dds` en `icons/`.
2. Anade sus rutas a `CUSTOM_ICONS` en `EZOCustomSupportIcons.lua`.
3. Recarga la UI.
4. En grupo, lista de amigos o roster de guild, clic derecho sobre un jugador y selecciona `Assign Custom Icon`.

Ejemplo:

```lua
local CUSTOM_ICONS = {
    "EZOCustomSupportIcons/icons/zuri.dds",
    "EZOCustomSupportIcons/icons/healer.dds",
}
```

Para asignar un icono automaticamente a una cuenta:

```lua
local UNIQUE_ICONS = {
    ["@Zuriplayer"] = "EZOCustomSupportIcons/icons/zuri.dds",
}
```

## Formato de iconos

- `.dds`
- Recomendado: `64x64`
- Anchura y altura divisibles por 4
- Canal alpha si necesitas transparencia

## Desarrollo

```powershell
.\tools\bump-version.ps1 -Check
.\scripts\ezo\build-addon-package.ps1 -Force
git diff --check
```

Ruta canonica:

```text
\\RZRNAS\Zuriplayer\Dev\EZOCustomSupportIcons
```
