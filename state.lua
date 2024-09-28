GameState = {
    NOT_PLAYING = "not_playing",
    BUILDING_LOBBY = "building_lobby",
    ROLLING = "rolling"
}

GameMode = {
    RAID = "raid",
    PARTY = "party",
    GUILD = "guild"
}

EventToMode = {
    ["CHAT_MSG_PARTY"] = GameMode.PARTY,
    ["CHAT_MSG_PARTY_LEADER"] = GameMode.PARTY,
    ["CHAT_MSG_RAID"] = GameMode.RAID,
    ["CHAT_MSG_RAID_LEADER"] = GameMode.RAID,
    ["CHAT_MSG_GUILD"] = GameMode.GUILD
}

ModeToChannel = {
    [GameMode.PARTY] = "PARTY",
    [GameMode.RAID] = "RAID",
    [GameMode.GUILD] = "GUILD"
}

