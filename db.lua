local ZydeCasino = LibStub("AceAddon-3.0"):GetAddon("ZydeCasino")

function ZydeCasino:GetPlayerData(playerName)
    if not self.db.profile.players[playerName] then
        self.db.profile.players[playerName] = { won = 0, lost = 0 }
    end
    return self.db.profile.players[playerName]
end

-- Function to log a player's win or loss
function ZydeCasino:LogPlayerResult(playerName, amountWon)
    local playerData = self:GetPlayerData(playerName)

    if amountWon > 0 then
        playerData.won = playerData.won + amountWon
    else
        playerData.lost = playerData.lost + math.abs(amountWon)
    end
end

function ZydeCasino:PersistResults(winnerName, loserName, amount)
    self:LogPlayerResult(winnerName, amount)
    self:LogPlayerResult(loserName, -amount)
end

function ZydeCasino:ClearPlayerData()
    self.db.profile.players = {}
end

function ZydeCasino:ClearPlayerDataWithConfirmation()
    StaticPopupDialogs["CONFIRM_CLEAR_DB"] = {
        text = "Are you sure you want to clear all player data?",
        button1 = "Yes",
        button2 = "No",
        OnAccept = function()
            ZydeCasino:ClearPlayerData()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }
    StaticPopup_Show("CONFIRM_CLEAR_DB")
end

function ZydeCasino:ShowTopPlayers()
    if not self:ValidateGroupType() then
        StaticPopup_Show("ZYDECASINO_ERROR", "You are not in a " .. self:GetChannel() .. ".")
        return -- Displays Error
    end

    local function getRandomMessage(messages)
        local index = math.random(#messages)
        local message = messages[index]
        table.remove(messages, index)  -- Remove the message from the pool after using it
        return message
    end

    -- Message variations for winners
    local winnerMessages = {
        "Locked in %s gold.",
        "Flexin with %s gold.",
        "Snatched %s gold.",
        "Bagged %s gold.",
        "%s gold in the pocket.",
    }

    -- Message variations for losers
    local loserMessages = {
        "Fumbled %s gold.",
        "Lost %s gold.",
        "Threw %s gold into the trash.",
        "Handed over %s gold.",
        "Parted with %s gold.",
    }

    local players = self.db.profile.players

    if next(players) == nil then
        return -- Don't print anything if no players
    end

    -- Create two tables to hold players sorted by wins and losses
    local winners = {}
    local losers = {}

    -- Populate winners and losers tables
    for playerName, data in pairs(players) do
        table.insert(winners, {name = playerName, amount = data.won})
        table.insert(losers, {name = playerName, amount = data.lost})
    end

    -- Sort the winners table by amount won (highest to lowest)
    table.sort(winners, function(a, b) return a.amount > b.amount end)

    -- Sort the losers table by amount lost (highest to lowest)
    table.sort(losers, function(a, b) return a.amount > b.amount end)

    SendChatMessage("- Zyde's Casino: Winners flexin', losers stressin' -", self:GetChannel())

    -- Announce top 3 winners
    SendChatMessage("-- Top 3 Winners, flexin' hard:", self:GetChannel())
    for i = 1, math.min(3, #winners) do
        local message = getRandomMessage(winnerMessages)
        SendChatMessage(i .. ". " .. winners[i].name .. ": " .. string.format(message, self:formatNumber(winners[i].amount)), self:GetChannel())
    end

    -- Announce top 3 losers
    SendChatMessage("-- Now, the top 3 who got clapped:", self:GetChannel())
    for i = 1, math.min(3, #losers) do
        local message = getRandomMessage(loserMessages)
        SendChatMessage(i .. ". " .. losers[i].name .. ": " .. string.format(message, self:formatNumber(losers[i].amount)), self:GetChannel())
    end
end

