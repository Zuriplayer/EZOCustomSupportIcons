# Icon Pack Strategy

## Objetivo

Permitir addons complementarios de la familia `EZOCustomSupportIcons` para guilds, grupos y jugadores concretos sin depender de `OdySupportIcons`.

Los iconos de un pack solo existen para jugadores que tengan instalados:

1. `EZOCustomSupportIcons`.
2. El pack complementario correspondiente.

## Modelos soportados

### Iconos fijos por cuenta

El pack registra una relacion `@Cuenta -> textura`.

Todos los jugadores que tengan instalado el mismo pack veran el mismo icono para esa cuenta, siempre que el pack este activo para ellos.

Uso previsto:

- oficiales de guild
- raid leads
- jugadores con rol estable
- miembros con icono personal aprobado

### Catalogo asignable

El pack registra una lista de iconos que aparecen como opciones en el menu de grupo de `EZOCustomSupportIcons`.

La asignacion sigue siendo local y de sesion salvo que mas adelante se implemente sincronizacion. Esto sirve para marcar jugadores durante una prueba, raid o mecanica.

Uso previsto:

- seguir
- curar
- foco
- mecanica
- lider

### Sincronizacion futura

Si se quiere que una asignacion dinamica hecha por un jugador se vea automaticamente en el resto del grupo, se debe hacer como fase separada usando `LibGroupBroadcast`.

Condiciones:

- opt-in
- solo grupo
- datos compactos
- protocolo reservado antes de publicar
- sin mensajes de chat intrusivos

## API publica del core

Los packs llaman a:

```lua
EZOCustomSupportIcons.RegisterIconPack({
    id = "hojablanca",
    name = "Hojablanca",
    version = "0.1.0",
    guilds = { "Hojablanca" },
    players = {
        ["@AccountName"] = "EZOCustomSupportIcons_Hojablanca/icons/account_name.dds",
    },
    assignableIcons = {
        {
            id = "leader",
            label = "Leader",
            texture = "EZOCustomSupportIcons_Hojablanca/icons/leader.dds",
        },
    },
})
```

## Pack Hojablanca

El primer pack vive en:

```text
packs/EZOCustomSupportIcons_Hojablanca/
```

Para instalarlo en ESO debe estar como addon hermano:

```text
AddOns/
  EZOCustomSupportIcons/
  EZOCustomSupportIcons_Hojablanca/
```

## Fuentes de iconos

Orden recomendado:

1. `.dds` propios generados o disenados para la guild.
2. Logos autorizados por la guild.
3. Texturas base de ESO referenciadas por ruta `esoui/...`.
4. Assets externos solo con licencia clara.

No copiar iconos de otros packs ni addons sin permiso explicito.

## Referencias investigadas

- OdySupportIcons: patron de asignacion desde grupo/friends/guild roster.
- Katt's Crypt Icons for OdySupportIcons: pack de guild con iconos asignables.
- Winds Custom Icons for OdySupportIcons: pack pequeno orientado a guild.
- LibCustomIcons: biblioteca central de iconos por jugador reutilizable por otros addons.
- HodorReflexes: ejemplo de ecosistema con librerias compartidas e iconos comunes.
- LibGroupBroadcast: via moderna para datos compartidos entre miembros de grupo.
