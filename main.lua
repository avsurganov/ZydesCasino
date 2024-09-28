local ZydeCasino = LibStub("AceAddon-3.0"):NewAddon("ZydeCasino", "AceEvent-3.0")

function ZydeCasino:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("ZydesCasinoDB", {
        profile = {
            players = {},  -- Each player will have a won/lost record
        },
    })

    self.state = GameState.NOT_PLAYING
    self.mode = GameMode.RAID
    self.players = {}  -- Initialize player table
    self.rolledPlayers = {} -- Initialize the players who have rolled
    self.isWildin = {}
    self.hasRolled = {}
    self:SetupChatEvents()  -- Set up chat event handling

    StaticPopupDialogs["ZYDECASINO_ERROR"] = {
        text = "Oops: %s",  -- Placeholder for the error message
        button1 = "OK",
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        OnAccept = function() end,  -- Simply closes the dialog on OK
    }
end

function ZydeCasino:SetupChatEvents()
    self:RegisterEvent("CHAT_MSG_SAY", "OnChatMessage")
    -- Register for party and party leader chat
    self:RegisterEvent("CHAT_MSG_PARTY", "OnChatMessage")
    self:RegisterEvent("CHAT_MSG_PARTY_LEADER", "OnChatMessage")

    -- Register for raid and raid leader chat
    self:RegisterEvent("CHAT_MSG_RAID", "OnChatMessage")
    self:RegisterEvent("CHAT_MSG_RAID_LEADER", "OnChatMessage")

    -- Register for Guild
    self:RegisterEvent("CHAT_MSG_GUILD", "OnChatMessage")

    -- Register System Messages
    self:RegisterEvent("CHAT_MSG_SYSTEM", "OnSystemMessage")
end

function ZydeCasino:GetChannel()
    return ModeToChannel[self.mode]
end

function ZydeCasino:StateOnStartGame()
    self.state = GameState.BUILDING_LOBBY
end

function ZydeCasino:StateOnRoll()
    self.state = GameState.ROLLING
end

function ZydeCasino:StateOnReset()
    self.state = GameState.NOT_PLAYING
end

SLASH_ZYDECASINO1 = "/zc"
function SlashCmdList.ZYDECASINO(msg)
    if not ZydeCasino.frame then
        ZydeCasino:LoadUI()  -- Load the UI when the command is called
    end

    if ZydeCasino.frame:IsShown() then
        ZydeCasino.frame:Hide()
    else
        ZydeCasino.frame:Show()
    end
end
