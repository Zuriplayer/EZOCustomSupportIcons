-- Registra iconos personalizados en OdySupportIcons sin modificar Ody.
EZOCustomSupportIcons = EZOCustomSupportIcons or {}
local ADDON = EZOCustomSupportIcons

local ADDON_NAME = "EZOCustomSupportIcons"

-- Anade aqui rutas de iconos que quieras elegir manualmente desde OdySupportIcons.
local CUSTOM_ICONS = {
    -- "EZOCustomSupportIcons/icons/zuri.dds",
}

-- Anade aqui iconos fijos por cuenta. Las claves deben ser display names ESO.
local UNIQUE_ICONS = {
    -- ["@Zuriplayer"] = "EZOCustomSupportIcons/icons/zuri.dds",
}

local function HasSequentialEntries(list)
    return type(list) == "table" and #list > 0
end

local function HasKeyedEntries(map)
    if type(map) ~= "table" then
        return false
    end

    for _ in pairs(map) do
        return true
    end

    return false
end

function ADDON.RegisterWithOdy()
    if not OSI then
        return
    end

    if HasSequentialEntries(CUSTOM_ICONS) and type(OSI.AddCustomIconPack) == "function" then
        OSI.AddCustomIconPack(CUSTOM_ICONS)
    end

    if HasKeyedEntries(UNIQUE_ICONS) and type(OSI.AddUniqueIconPack) == "function" then
        OSI.AddUniqueIconPack(UNIQUE_ICONS)
    end
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, function(_, addonName)
    if addonName ~= ADDON_NAME then return end
    EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED)
    ADDON.RegisterWithOdy()
end)
