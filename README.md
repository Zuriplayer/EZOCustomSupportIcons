# EZOCustomSupportIcons

Addon de la familia EZO para mostrar iconos personalizados sobre jugadores concretos y en el roster de guild.

No depende de `OdySupportIcons`, no usa su catalogo de iconos y no modifica otros addons.

## Uso

1. Coloca los `.dds` en `icons/`.
2. Asocia cada cuenta en la tabla `ICONS` de `EZOCustomSupportIcons.lua`.
3. Recarga la UI.
4. En grupo, el icono aparece sobre los jugadores configurados.
5. En el roster de guild, el icono aparece sobre el indicador de estado de las cuentas configuradas.

## Ajustes

En `Settings > Addons > EZOCustomSupportIcons`:

- `Show head icons`: activa o desactiva los iconos sobre la cabeza para todas las cuentas configuradas.
- `Head icon size`: ajusta el tamano de esos iconos para todas las cuentas configuradas.

Ejemplo:

```lua
local ICONS = {
    ["@zuriplayer"] = "EZOCustomSupportIcons/icons/zuriplayer.dds",
}
```

## Formato de iconos

- `.dds`
- Recomendado: `64x64`
- Anchura y altura divisibles por 4
- Canal alpha si necesitas transparencia

## Limitaciones

ESO solo expone posicion fiable para miembros del grupo. El renderer se limita a jugadores agrupados y visibles en la misma instancia.

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
