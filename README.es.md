# EZOCustomSupportIcons

Addon independiente en beta para *The Elder Scrolls Online* que muestra iconos personalizados de soporte para jugadores configurados, marcadores tácticos locales de grupo y packs de iconos opcionales sin depender de `OdySupportIcons`.

Prefer English? Read the [README in English](README.md).
Para soporte, reportes de errores, comentarios o sugerencias, únete a nuestro Discord: https://discord.gg/PQre8CpqQ7

## Estado

- Estado: beta
- Versión: 0.3.5
- API de ESO: 101049 101050
- AddOnVersion: 10012

Esta beta está pensada para pruebas manuales en grupo, roster de guild y packs complementarios de iconos. La API pública para packs todavía puede cambiar antes de una versión estable.

## Requisitos

- The Elder Scrolls Online para PC.
- Opcional: `LibAddonMenu-2.0` para el panel de ajustes.
- Opcional: `LibCustomMenu` para asignar marcadores tácticos desde el menú contextual del listado de grupo en teclado.

El addon funciona con `OdySupportIcons` desactivado.

## Instalación

1. Clona este repositorio, o usa un paquete ZIP publicado cuando esté disponible.
2. Copia la carpeta `EZOCustomSupportIcons` dentro de tu carpeta de AddOns de ESO:

```text
Documents/Elder Scrolls Online/live/AddOns/
```

3. Asegúrate de que el manifiesto queda en:

```text
AddOns/EZOCustomSupportIcons/EZOCustomSupportIcons.txt
```

4. Ejecuta `/reloadui` o reinicia el juego.

## Funciones Implementadas

- Iconos fijos personalizados para nombres de cuenta configurados.
- Overlay 3D propio sobre miembros visibles del grupo en la misma instancia.
- Sustitución del icono en el roster de guild para cuentas configuradas.
- SavedVariables account-wide solo para ajustes visuales globales.
- Ajustes de LibAddonMenu, cuando `LibAddonMenu-2.0` está instalado:
  - `Show head icons`
  - `Head icon size`
  - `Hide head icons in combat`
- Marcadores tácticos locales y solo de sesión para miembros actuales del grupo:
  - `Follow`
  - `Heal`
  - `Tank`
  - `Focus`
  - `Mechanic`
- Integración con el menú contextual del listado de grupo en teclado mediante `LibCustomMenu`, cuando está instalado.
- Visualización en la lista de grupo de gamepad para marcadores tácticos ya asignados.
- API pública `EZOCustomSupportIcons.RegisterIconPack(...)` para addons complementarios de packs de iconos.

## Packs Complementarios de Iconos

Los packs complementarios son addons separados con:

```text
## DependsOn: EZOCustomSupportIcons
```

Pueden registrar iconos fijos para jugadores y marcadores asignables adicionales. Los jugadores solo ven los iconos de un pack si tienen instalado `EZOCustomSupportIcons` y ese mismo pack.

El repositorio incluye un ejemplo como código fuente:

```text
packs/EZOCustomSupportIcons_Hojablanca/
```

Para probar ese pack en el juego, instálalo como addon hermano junto a `EZOCustomSupportIcons`.

## Límites de Seguridad y Alcance

- No depende de `OdySupportIcons`.
- No llama APIs `OSI.*`.
- No modifica `OdySupportIcons` ni ningún otro addon.
- No envía datos fuera del cliente del juego.
- No usa servicios externos en runtime.
- No automatiza combate, movimiento, input, keybindings ni decisiones de juego.
- No sincroniza marcadores tácticos dinámicos con otros jugadores.
- Los marcadores tácticos son locales, solo de sesión y se limpian al salir o cambiar de grupo.
- Los iconos sobre la cabeza solo se renderizan en escenas HUD (`hud` / `hudui`), no sobre mapa, inventario ni menús.
- ESO solo expone posiciones de mundo fiables para miembros del grupo; los iconos sobre la cabeza se limitan a jugadores agrupados y visibles en un contexto válido de instancia/mundo.

## Archivos de Iconos

- Formato recomendado: `.dds`
- Tamaño recomendado: `64x64`
- Anchura y altura divisibles por 4
- Canal alpha si necesitas transparencia

Usa solo iconos propios, iconos con permiso de uso, assets con licencia clara o texturas base de ESO referenciadas mediante rutas `esoui/...`.

## Pruebas Recomendadas

Checklist mínimo para la beta:

- `/reloadui` termina sin errores Lua.
- Con una cuenta configurada en grupo, el icono aparece sobre el jugador.
- En el roster de guild, aparece el icono de la cuenta configurada.
- En ajustes, `Show head icons` oculta/muestra los iconos sobre la cabeza.
- En ajustes, `Head icon size` cambia el tamaño de los iconos.
- En ajustes, `Hide head icons in combat` oculta iconos en combate, manteniendo visibles las unidades muertas.
- La asignación de marcador táctico desde el menú contextual del listado de grupo en teclado aparece sobre el objetivo y en la lista de grupo.
- Un marcador ya asignado en modo teclado aparece en la lista de grupo de gamepad.
- Los marcadores tácticos se limpian al salir del grupo o cuando el jugador marcado abandona el grupo.
- Los iconos sobre la cabeza se ocultan en mapa, inventario y pantallas de menú.
- El addon funciona con `OdySupportIcons` desactivado.

El addon actual no tiene archivos de idioma ni tablas de localización, así que no hay una comprobación de paridad EN/ES que ejecutar para la UI runtime.

## Comprobaciones de Desarrollo

Comprobaciones locales recomendadas:

```powershell
.\tools\bump-version.ps1 -Check
git diff --check
```

El build/package está disponible para preparar artefactos:

```powershell
.\scripts\ezo\build-addon-package.ps1 -Force
```

No generes un paquete salvo que estés preparando un artefacto de build.

## Licencia

MIT - consulta [LICENSE](LICENSE).

Desarrollado y mantenido por Zuriplayer.
