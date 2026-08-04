# EZOCustomSupportIcons - AI Development Rules


<!-- EZO-SHARED-LAM-START -->
## Estándar LAM compartido

Antes de crear o modificar ajustes LibAddonMenu, leer y aplicar:
`E:\DEV\EZOFamilyDocs\docs\ezo-lam-settings-style.md`

Las reglas específicas de este addon tienen prioridad. Si el archivo compartido
no está accesible, no modificar LAM e indicarlo explícitamente.
<!-- EZO-SHARED-LAM-END -->
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
- Los packs complementarios deben usar `EZOCustomSupportIcons.RegisterIconPack`.
- Los packs complementarios deben vivir como addons independientes con `DependsOn: EZOCustomSupportIcons`.
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

## Documentación

- Toda modificación funcional, de configuración, comportamiento, alcance o requisitos debe incluir en el mismo trabajo la revisión y actualización de `README.md` y `README.es.md`.
- Ambos README deben mantenerse equivalentes y sincronizados.
- Ningún README debe anunciar funciones, límites o requisitos que no coincidan con el código actual.
- Deben actualizarse las secciones afectadas: funciones, límites de seguridad, requisitos, instalación y pruebas.
- Antes de cerrar cualquier cambio se debe comprobar expresamente que ambos README siguen completos y actualizados.

## Checklist de pruebas manuales

- `/reloadui`.
- Sin errores Lua al cargar.
- En grupo con una cuenta configurada, confirmar que el icono aparece sobre el jugador.
- En guild roster, confirmar que el icono aparece en la cuenta configurada.
- En LAM, confirmar que `Show head icons` oculta/muestra todos los iconos sobre cabeza.
- En LAM, confirmar que `Head icon size` cambia el tamano sobre cabeza.
- En LAM, confirmar que `Hide head icons in combat` oculta iconos en combate excepto unidades muertas.
- En grupo, asignar un marcador tactico desde el menu contextual de teclado y confirmar que aparece sobre la cabeza y en la lista de grupo.
- Con un pack complementario instalado, confirmar que sus iconos asignables aparecen en el menu de grupo si el jugador pertenece a la guild configurada.
- En gamepad, confirmar que la lista de grupo muestra un marcador tactico ya asignado.
- Confirmar que los marcadores tacticos se limpian al salir del grupo o cuando el jugador marcado deja el grupo.
- Confirmar que los iconos sobre cabeza se ocultan en mapa, inventario y menus.
- Confirmar que el addon funciona con `OdySupportIcons` desactivado.

<!-- EZO-ESO-UPDATE-START -->
## Baseline obligatorio de ESO

Antes de analizar, modificar, validar, versionar o publicar este proyecto, leer
`..\EZOFamilyDocs\docs\eso-updates\current.md` y aplicar la política enlazada.

Baseline vigente: `U51-PTS-v12.1.0`.

- La matriz por addon vive en `..\EZOFamilyDocs\data\eso-update-baseline.json`.
- U51 sigue siendo PTS provisional hasta que exista verificación explícita.
- No cambiar `## APIVersion` por inferencia; verificarla en el cliente o en una
  fuente fiable de API.
- Si estos archivos no están disponibles, detener el trabajo sensible a
  compatibilidad e indicar el bloqueo.

Fuente remota de respaldo:
https://github.com/Zuriplayer/EZOFamilyDocs/blob/main/docs/eso-updates/current.md
<!-- EZO-ESO-UPDATE-END -->
