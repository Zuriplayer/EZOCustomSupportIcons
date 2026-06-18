# Architecture

`EZOCustomSupportIcons` es un addon independiente minimo.

Dibuja iconos propios sobre jugadores configurados sin depender de `OdySupportIcons`.

## Flujo

1. ESO carga `EZOCustomSupportIcons`.
2. El addon crea un render control 3D y una ventana overlay transparente.
3. En cada actualizacion recorre los miembros del grupo.
4. Si la cuenta esta en `ICONS`, proyecta su posicion de mundo a pantalla y dibuja el `.dds`.
5. El hook de guild roster superpone el mismo `.dds` al icono de estado de la cuenta configurada.
6. LibAddonMenu controla si se muestran iconos sobre la cabeza y su tamano global.

## Decisiones

- No se depende de `OdySupportIcons`.
- No se consumen iconos de `OdySupportIcons`.
- Hay SavedVariables account-wide solo para ajustes globales de visualizacion.
- La unica UI propia son texturas runtime para los iconos sobre jugadores.
