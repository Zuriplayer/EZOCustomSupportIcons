EZOCustomSupportIcons = EZOCustomSupportIcons or {}

local ADDON = EZOCustomSupportIcons

if not ADDON.RegisterIconPack then
    return
end

ADDON.RegisterIconPack({
    id = "hojablanca",
    name = "Hojablanca",
    version = "0.1.0",
    guilds = {
        "Hojablanca",
    },
    players = {
        -- ["@AccountName"] = "EZOCustomSupportIcons_Hojablanca/icons/account_name.dds",
    },
    assignableIcons = {
        {
            id = "guild",
            label = "Guild",
            texture = "esoui/art/guild/guild_indexicon_leader_up.dds",
        },
        {
            id = "leader",
            label = "Leader",
            texture = "esoui/art/lfg/lfg_leader_icon.dds",
        },
        {
            id = "heal",
            label = "Heal",
            texture = "esoui/art/lfg/gamepad/lfg_roleicon_healer.dds",
        },
        {
            id = "tank",
            label = "Tank",
            texture = "esoui/art/lfg/gamepad/lfg_roleicon_tank.dds",
        },
        {
            id = "focus",
            label = "Focus",
            texture = "esoui/art/lfg/gamepad/lfg_roleicon_dps.dds",
        },
        {
            id = "mechanic",
            label = "Mechanic",
            texture = "esoui/art/icons/mapkey/mapkey_groupboss.dds",
        },
    },
})
