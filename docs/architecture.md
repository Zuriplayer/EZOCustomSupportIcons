# Architecture

`EZOCustomSupportIcons` es un addon independiente minimo.

Dibuja iconos propios sobre jugadores configurados sin depender de `OdySupportIcons`.

## Flujo

1. ESO carga `EZOCustomSupportIcons`.
2. El addon crea un render control 3D y una ventana overlay transparente.
3. En cada actualizacion oculta primero los iconos y solo continua si la escena activa es `hud` o `hudui`.
4. Recorre el jugador y los miembros del grupo.
5. Si la cuenta tiene un marcador tactico local de sesion, ese marcador tiene prioridad sobre el icono fijo.
6. Si no hay marcador tactico y la cuenta esta en `ICONS`, proyecta su posicion de mundo a pantalla y dibuja el `.dds`.
7. El hook de guild roster superpone solo los iconos fijos al icono de estado de la cuenta configurada.
8. LibAddonMenu controla si se muestran iconos sobre la cabeza, su tamano global y si se ocultan en combate.
9. LibCustomMenu permite asignar marcadores tacticos desde el menu contextual del listado de grupo en teclado.

## Decisiones

- No se depende de `OdySupportIcons`.
- No se consumen iconos de `OdySupportIcons`.
- Hay SavedVariables account-wide solo para ajustes globales de visualizacion.
- Los marcadores tacticos son runtime-only: no se guardan, no se sincronizan y solo se aplican mientras el jugador marcado sigue en tu grupo.
- La lista de grupo en gamepad muestra marcadores asignados, pero la asignacion directa desde gamepad queda limitada por el menu nativo disponible.
- Los iconos 3D usan whitelist positiva de escenas `hud`/`hudui`.
- La ocultacion en combate mantiene visibles los iconos de unidades muertas para facilitar localizarlas.
- La unica UI propia son texturas runtime para los iconos sobre jugadores.
