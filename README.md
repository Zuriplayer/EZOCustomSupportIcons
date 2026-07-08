# EZOCustomSupportIcons

Addon de la familia EZO para mostrar iconos personalizados sobre jugadores concretos y en el roster de guild.

No depende de `OdySupportIcons`, no usa su catalogo de iconos y no modifica otros addons.

## Packs complementarios

`EZOCustomSupportIcons` expone una API para packs externos de guild o grupo.

Un pack puede registrar:

- iconos fijos por cuenta
- iconos asignables desde el menu de grupo
- una lista de guilds para activar el pack solo si perteneces a ellas

Ejemplo disponible:

```text
packs/EZOCustomSupportIcons_Hojablanca/
```

Para que otros jugadores vean los mismos iconos de un pack, tambien deben tener instalado `EZOCustomSupportIcons` y ese pack.

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
- `Hide head icons in combat`: oculta los iconos sobre la cabeza mientras estas en combate, pero mantiene visibles los de jugadores muertos.

## Marcadores tacticos

Desde el menu contextual del listado de grupo en teclado se puede asignar un marcador local de sesion a un miembro del grupo:

- `Follow`
- `Heal`
- `Tank`
- `Focus`
- `Mechanic`

Estos marcadores solo son visibles para ti, no se guardan en SavedVariables y se limpian al abandonar el grupo o si el jugador marcado deja de estar en el grupo. En gamepad, el listado de grupo muestra el marcador cuando ya esta asignado; la accion de asignacion directa depende del menu nativo de jugador y queda pendiente de integracion segura.

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

Los iconos sobre la cabeza solo se muestran en escenas HUD (`hud`/`hudui`), no sobre mapa, inventario, menus u otras pantallas.

Los marcadores tacticos reutilizan el mismo renderer y respetan los ajustes globales de visibilidad, tamano y ocultacion en combate.

Los packs complementarios se documentan en `docs/icon-pack-strategy.md`.

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
