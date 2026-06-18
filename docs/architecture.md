# Architecture

`EZOCustomSupportIcons` es un addon-pack minimo.

No dibuja iconos por si mismo. Delega en `OdySupportIcons`.

## Flujo

1. ESO carga `OdySupportIcons`.
2. ESO carga `EZOCustomSupportIcons` por `DependsOn`.
3. El addon llama a:
   - `OSI.AddCustomIconPack(CUSTOM_ICONS)`
   - `OSI.AddUniqueIconPack(UNIQUE_ICONS)`
4. OdySupportIcons usa esos iconos en su selector o como iconos unicos por cuenta.

## Decisiones

- No se modifican archivos de `OdySupportIcons`.
- No hay SavedVariables.
- No hay UI propia.
- No se incluyen iconos de ejemplo para evitar assets sin licencia clara.
