# EZOCustomSupportIcons_Hojablanca

Pack complementario para `EZOCustomSupportIcons`.

## Instalacion

Este directorio debe instalarse como addon independiente junto a `EZOCustomSupportIcons`:

```text
AddOns/
  EZOCustomSupportIcons/
  EZOCustomSupportIcons_Hojablanca/
```

## Alcance

- Requiere `EZOCustomSupportIcons`.
- No depende de `OdySupportIcons`.
- Registra un catalogo inicial de iconos asignables para miembros de Hojablanca.
- Puede registrar iconos fijos por cuenta en la tabla `players`.
- Solo veran estos iconos los jugadores que tengan instalado este pack.

## Iconos propios

Los `.dds` propios del pack deben colocarse en:

```text
EZOCustomSupportIcons_Hojablanca/icons/
```

Y referenciarse con rutas tipo:

```lua
"EZOCustomSupportIcons_Hojablanca/icons/nombre.dds"
```

El catalogo inicial usa texturas base de ESO como placeholders hasta tener arte propio de Hojablanca.
