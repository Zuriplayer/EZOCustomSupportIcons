# EZOCustomSupportIcons - AI Development Rules

Este proyecto es un addon independiente para The Elder Scrolls Online (ESO).

Su objetivo es mostrar iconos personalizados propios sobre jugadores concretos sin depender de `OdySupportIcons`.

## Alcance

- Addon independiente: `EZOCustomSupportIcons`.
- No depende de `OdySupportIcons`.
- No consume ni registra iconos de `OdySupportIcons`.
- Renderiza un overlay 3D propio para cuentas configuradas.
- La UI propia se limita a texturas runtime sobre jugadores.
- Usa SavedVariables account-wide solo para ajustes globales de visualizacion.
- No toca input ni keybindings.

## Reglas obligatorias

- No modificar `OdySupportIcons` directamente.
- No llamar APIs `OSI.*`.
- No copiar assets de terceros sin licencia clara.
- Mantener los `.dds` en `icons/`.
- Si se anade un archivo runtime, anadirlo a `EZOCustomSupportIcons.txt`.
- Evitar globals innecesarias; usar `EZOCustomSupportIcons = EZOCustomSupportIcons or {}`.
- Mantener los ajustes en LAM simples y globales salvo peticion explicita.
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

## Checklist de pruebas manuales

- `/reloadui`.
- Sin errores Lua al cargar.
- En grupo con una cuenta configurada, confirmar que el icono aparece sobre el jugador.
- En guild roster, confirmar que el icono aparece en la cuenta configurada.
- En LAM, confirmar que `Show head icons` oculta/muestra todos los iconos sobre cabeza.
- En LAM, confirmar que `Head icon size` cambia el tamano sobre cabeza.
- En LAM, confirmar que `Hide head icons in combat` oculta iconos en combate excepto unidades muertas.
- En grupo, asignar un marcador tactico desde el menu contextual de teclado y confirmar que aparece sobre la cabeza y en la lista de grupo.
- En gamepad, confirmar que la lista de grupo muestra un marcador tactico ya asignado.
- Confirmar que los marcadores tacticos se limpian al salir del grupo o cuando el jugador marcado deja el grupo.
- Confirmar que los iconos sobre cabeza se ocultan en mapa, inventario y menus.
- Confirmar que el addon funciona con `OdySupportIcons` desactivado.
