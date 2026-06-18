# OdySupportIcons Notes

APIs usadas:

```lua
OSI.AddCustomIconPack({
    "EZOCustomSupportIcons/icons/example.dds",
})
```

```lua
OSI.AddUniqueIconPack({
    ["@AccountName"] = "EZOCustomSupportIcons/icons/example.dds",
})
```

`AddCustomIconPack` anade iconos al selector manual de OdySupportIcons.

`AddUniqueIconPack` asigna automaticamente un icono a una cuenta concreta si la opcion de unique icons esta activa en OdySupportIcons.
