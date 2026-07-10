# EZOCustomSupportIcons

Beta publica de un addon independiente para The Elder Scrolls Online.

`EZOCustomSupportIcons` muestra iconos personalizados propios sobre jugadores concretos sin depender de `OdySupportIcons`, sin modificar otros addons y sin comunicacion online.

## Estado

- Estado: beta
- Version: 0.3.5
- API ESO: 101049 101050
- AddOnVersion: 10012

La beta esta pensada para pruebas manuales en grupo, roster de guild y packs complementarios. Puede cambiar la API publica de packs antes de una version estable.

## Requisitos

- The Elder Scrolls Online para PC.
- `LibAddonMenu-2.0` opcional, para el panel de ajustes.
- `LibCustomMenu` opcional, para asignar marcadores desde el menu contextual del grupo en teclado.

El addon funciona con `OdySupportIcons` desactivado.

## Instalacion

1. Descarga o clona el repositorio.
2. Copia la carpeta `EZOCustomSupportIcons` en:

```text
Documents/Elder Scrolls Online/live/AddOns/
```

3. Asegurate de que el manifiesto queda en:

```text
AddOns/EZOCustomSupportIcons/EZOCustomSupportIcons.txt
```

4. Ejecuta `/reloadui` o reinicia el juego.

## Funciones principales

- Iconos fijos por cuenta configurados por el addon o por packs complementarios.
- Overlay 3D propio sobre miembros del grupo visibles en la misma instancia.
- Icono en guild roster para cuentas configuradas.
- Ajustes globales en LAM:
  - mostrar/ocultar iconos sobre cabeza
  - tamano global del icono
  - ocultar en combate manteniendo visibles unidades muertas
- Marcadores tacticos locales de sesion para miembros del grupo:
  - `Follow`
  - `Heal`
  - `Tank`
  - `Focus`
  - `Mechanic`
- API publica `EZOCustomSupportIcons.RegisterIconPack(...)` para packs complementarios.

## Packs complementarios

Los packs son addons independientes con:

```text
## DependsOn: EZOCustomSupportIcons
```

Pueden registrar iconos fijos por cuenta y catalogos asignables desde el menu de grupo. Los iconos de un pack solo los veran jugadores que tengan instalado el core y ese mismo pack.

Ejemplo incluido como fuente:

```text
packs/EZOCustomSupportIcons_Hojablanca/
```

Para probarlo en juego, instala ese directorio como addon hermano de `EZOCustomSupportIcons`.

## Limites de seguridad y privacidad

- No depende de `OdySupportIcons`.
- No llama APIs `OSI.*`.
- No envia datos fuera del cliente.
- No usa servicios externos en runtime.
- No sincroniza marcadores dinamicos con otros jugadores.
- Los marcadores tacticos son locales, de sesion y se limpian al salir/cambiar de grupo.
- Solo se muestran iconos sobre cabeza en escenas HUD (`hud`/`hudui`), no sobre mapa, inventario o menus.

## Iconos

- Formato recomendado: `.dds`
- Tamano recomendado: `64x64`
- Anchura y altura divisibles por 4
- Canal alpha si necesitas transparencia

Usa solo iconos propios, autorizados, de licencia clara o texturas base de ESO referenciadas por ruta `esoui/...`.

## Notas de prueba

Checklist minimo para la beta:

- `/reloadui` sin errores Lua.
- En grupo, confirmar iconos sobre jugadores configurados.
- En guild roster, confirmar iconos de cuentas configuradas.
- En LAM, probar mostrar/ocultar, tamano y ocultacion en combate.
- Confirmar que los iconos se ocultan en mapa, inventario y menus.
- Confirmar que los marcadores tacticos aparecen en cabeza y lista de grupo.
- Confirmar que los marcadores se limpian al salir del grupo.
- Confirmar que el addon funciona con `OdySupportIcons` desactivado.

## Desarrollo

Validaciones locales recomendadas:

```powershell
.\tools\bump-version.ps1 -Check
.\scripts\ezo\build-addon-package.ps1 -Force
git diff --check
```

## Licencia

MIT. Consulta `LICENSE`.
