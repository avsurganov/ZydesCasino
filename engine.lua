local ZydeCasino = LibStub("AceAddon-3.0"):GetAddon("ZydeCasino")

function ZydeCasino:OnChatMessage(event, msg, player)
    local playerName = string.match(player, "^(.-)%-.+")
    if EventToMode[event] == self.mode and self.state == GameState.BUILDING_LOBBY then
        if msg == "1" then  -- Player joins
            if not self.players[playerName] then
                self.players[playerName] = true -- Add player to the table
                self:UpdatePlayerCount() -- Update the player count display
            end
        elseif msg == "-1" then  -- Player withdraws
            if self.players[playerName] then
                self.players[playerName] = nil -- Remove player from the table
                self:UpdatePlayerCount() -- Update the player count display
            end
        else
            local addonPlayer, _ = UnitName("player")
            if playerName ~= addonPlayer and not self.isWildin[playerName] then
                self.isWildin[playerName] = true
                SendChatMessage("Zyde's Casino: " .. playerName .. " out here wildin', can't even tell 1 from -1. Big clown energy, fr.", self:GetChannel())
            end
        end
    end
end

function ZydeCasino:UpdatePlayerCount()
    local playerCount = self:GetPlayerCount(self.players)

    if self.frame and self.frame.playerCountLabel then
        self.frame.playerCountLabel:SetText("Players Entered: " .. playerCount)
    end
end

function ZydeCasino:UpdatePlayerRollCount()
    local playerCount = self:GetPlayerCount(self.players)
    local playerRolledCount = self:GetPlayerCount(self.rolledPlayers)

    if self.frame and self.frame.playerCountLabel then
        self.frame.playerCountLabel:SetText("Players Rolled: " .. playerRolledCount .. "/" .. playerCount)
    end

    if playerCount == playerRolledCount then
        local minRoll, minPlayer, maxRoll, maxPlayer = self:GetMinMaxRolls()
        local winnings = maxRoll - minRoll
        self:PersistResults(maxPlayer, minPlayer, winnings)
        self.frame.playerCountLabel:SetText(maxPlayer .. " wins " .. winnings .. "!")
        SendChatMessage("Zyde's Casino: " .. maxPlayer .. " just finessed " .. winnings .. " off " .. minPlayer .. ". Pay up now, don’t be giving broke vibes fr!", self:GetChannel())
        self:ResetGame(false)
    end
end

function ZydeCasino:ResetPlayerCount(clearLabel)
    self.players = {}
    self.rolledPlayers = {}
    self.hasRolled = {}
    self.isWildin = {}
    if clearLabel then
        self:UpdatePlayerCount()
        self.frame.playerCountLabel:Hide()
    end
end

function ZydeCasino:OnSystemMessage(_, msg)
    -- Pattern to capture player name, roll value, and max roll
    local playerName, rollValue, _, maxRollValue = string.match(msg, "(.+) rolls (%d+) %((%d+)%-(%d+)%)")

    if self.state == GameState.ROLLING then
        if playerName and rollValue and maxRollValue then
            local wager = self:GetWager()
            if tonumber(maxRollValue) ~= wager then
                SendChatMessage("Zyde's Raid Casino: " .. playerName .. ", fr? The roll’s " .. wager .. ", not " .. maxRollValue .. ". Stop clowning or you’re getting straight booted, no cap.", self:GetChannel())
                return -- Return if they rolled the wrong number
            end

            -- Check if the player is in the game (exists in self.players)
            if self.players[playerName] then
                -- Check if the player hasn't already rolled
                if not self.rolledPlayers[playerName] then
                    -- Add the player to rolledPlayers and count their roll
                    self.rolledPlayers[playerName] = tonumber(rollValue)
                    -- Update the UI to reflect the new count of players who have rolled
                    self:UpdatePlayerRollCount()
                else
                    if not self.hasRolled[playerName] then
                        SendChatMessage("Zyde's Casino: Yo " .. playerName .. " deadass tryna pull some shady shit with that extra roll. Not cool.", self:GetChannel())
                        self.hasRolled[playerName] = true
                    end
                end
            end
        end
    end
end

function ZydeCasino:GetPlayerCount(table)
    local playerCount = 0
    for _ in pairs(table) do
        playerCount = playerCount + 1
    end
    return playerCount
end

function ZydeCasino:GetMinMaxRolls()
    local minRoll, minPlayer = nil, nil
    local maxRoll, maxPlayer = nil, nil

    -- Iterate through the rolledPlayers table
    for playerName, roll in pairs(self.rolledPlayers) do
        -- Update minRoll and minPlayer
        if not minRoll or roll < minRoll then
            minRoll = roll
            minPlayer = playerName
        end
        -- Update maxRoll and maxPlayer
        if not maxRoll or roll > maxRoll then
            maxRoll = roll
            maxPlayer = playerName
        end
    end

    return minRoll, minPlayer, maxRoll, maxPlayer
end

function ZydeCasino:GetUnrolledPlayers()
    local unrolledPlayers = {}

    -- Iterate over the self.players table
    for playerName, _ in pairs(self.players) do
        -- Check if the player is not in rolledPlayers
        if not self.rolledPlayers[playerName] then
            table.insert(unrolledPlayers, playerName)
        end
    end

    -- Concatenate the unrolled player names into a single string with commas
    return table.concat(unrolledPlayers, ", ")
end

function ZydeCasino:GetPlayerData(playerName)
    if not self.db.profile.players[playerName] then
        self.db.profile.players[playerName] = { won = 0, lost = 0 }
    end
    return self.db.profile.players[playerName]
end
