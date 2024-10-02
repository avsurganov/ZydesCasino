local ZydeCasino = LibStub("AceAddon-3.0"):GetAddon("ZydeCasino")

function ZydeCasino:LoadUI()
    -- Create the main frame
    self.frame = CreateFrame("Frame", "ZydeCasinoFrame", UIParent)
    self.frame:SetSize(500, 310) -- Set initial size
    self.frame:SetPoint("CENTER") -- Position the frame in the center of the screen
    self.frame:EnableMouse(true) -- Enable mouse interaction
    self.frame:SetMovable(true) -- Make the frame movable
    self.frame:RegisterForDrag("LeftButton") -- Register for dragging
    self.frame:SetClampedToScreen(true) -- Prevent it from going off-screen

    -- Create a label to display the player count
    self.frame.playerCountLabel = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.frame.playerCountLabel:SetFont("Interface\\AddOns\\NaowhUI\\Core\\Media\\Fonts\\Naowh.ttf", 14)
    self.frame.playerCountLabel:SetText("Players Entered: 0") -- Initial text
    self.frame.playerCountLabel:SetPoint("BOTTOM", self.frame, "BOTTOM", 0, 30) -- Position it at the bottom center

    -- author
    local authorLabel = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    authorLabel:SetFont("Interface\\AddOns\\NaowhUI\\Core\\Media\\Fonts\\Naowh.ttf", 10)
    authorLabel:SetText("Made with <3 by Zydedh-Thrall")
    authorLabel:SetPoint("TOP", self.frame.playerCountLabel, "BOTTOM", 170, -75) -- Centered horizontally

    -- Create a solid colored backdrop
    local backdrop = self.frame:CreateTexture(nil, "BACKGROUND")
    backdrop:SetAllPoints(self.frame)
    backdrop:SetColorTexture(0, 0, 0, 0.80) -- Set color and alpha (black with 80% transparency)

    -- Title label
    local titleLabel = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    titleLabel:SetFont("Interface\\AddOns\\NaowhUI\\Core\\Media\\Fonts\\Naowh.ttf", 16)
    titleLabel:SetText("Zyde's Casino")
    titleLabel:SetPoint("TOP", self.frame, "TOP", 0, -10) -- Centered horizontally

    -- Status text
    local statusText = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    statusText:SetFont("Interface\\AddOns\\NaowhUI\\Core\\Media\\Fonts\\Naowh.ttf", 14)
    statusText:SetText("Welcome to the Casino!")
    statusText:SetPoint("TOP", titleLabel, "BOTTOM", 0, -20) -- Centered horizontally below the title

    -- Close button
    local closeButton = CreateFrame("Button", nil, self.frame, "UIPanelCloseButton")
    closeButton:SetSize(20, 20) -- Set size
    closeButton:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", -5, -5)
    closeButton:SetScript("OnClick", function() self.frame:Hide() end)

    -- Select label
    local selectLabel = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    selectLabel:SetFont("Interface\\AddOns\\NaowhUI\\Core\\Media\\Fonts\\Naowh.ttf", 14)
    selectLabel:SetText("Select where to play game:")
    selectLabel:SetPoint("TOPLEFT", statusText, "BOTTOMLEFT", -120, -20) -- Align to the left

    -- Mode button
    self.frame.modeButton = CreateFrame("Button", nil, self.frame, "UIPanelButtonTemplate")
    self.frame.modeButton:SetSize(200, 30) -- Set button size
    self.frame.modeButton:SetText("Raid") -- Default text
    self.frame.modeButton:SetPoint("LEFT", selectLabel, "RIGHT", 10, 0) -- Position to the right of the select label

    -- Mode cycling logic
    local modes = {"Raid", "Party", "Guild"}
    local currentModeIndex = 1
    self.frame.modeButton:SetScript("OnClick", function()
        currentModeIndex = currentModeIndex + 1
        if currentModeIndex > #modes then currentModeIndex = 1 end
        self.frame.modeButton:SetText(modes[currentModeIndex]) -- Update button text

        -- Register the appropriate event
        if modes[currentModeIndex] == "Party" then
            self.mode = GameMode.PARTY
        elseif modes[currentModeIndex] == "Raid" then
            self.mode = GameMode.RAID
        elseif modes[currentModeIndex] == "Guild" then
            self.mode = GameMode.GUILD
        end
    end)

    -- Wager input label
    local wagerLabel = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    wagerLabel:SetFont("Interface\\AddOns\\NaowhUI\\Core\\Media\\Fonts\\Naowh.ttf", 14)
    wagerLabel:SetText("Enter Wager:")
    wagerLabel:SetPoint("TOPLEFT", selectLabel, "BOTTOMLEFT", 0, -20) -- Align to the left

    -- Wager input field
    self.frame.wagerInput = CreateFrame("EditBox", nil, self.frame)
    self.frame.wagerInput:SetSize(190, 25) -- Set input field size
    self.frame.wagerInput:SetPoint("LEFT", wagerLabel, "RIGHT", 119 + 5, 0) -- Position to the right of the wager label
    self.frame.wagerInput:SetFontObject("ChatFontNormal") -- Set font
    self.frame.wagerInput:SetMaxLetters(10) -- Maximum characters
    self.frame.wagerInput:SetNumeric(true) -- Only allow numeric input
    self.frame.wagerInput:SetAutoFocus(false) -- Do not auto-focus
    self.frame.wagerInput:SetScript("OnEnterPressed", function(self)
        self:ClearFocus() -- Clear focus after entering
    end)

    -- Center the text
    self.frame.wagerInput:SetTextInsets(0, 0, 0, 0) -- Remove default insets
    self.frame.wagerInput:SetJustifyH("CENTER") -- Center the text

    -- Set a visible background color for the input field using a texture
    local inputBackground = self.frame.wagerInput:CreateTexture(nil, "BACKGROUND")
    inputBackground:SetAllPoints(self.frame.wagerInput)
    inputBackground:SetColorTexture(0.1, 0.1, 0.1, 1) -- Dark gray with full opacity

    -- Start Game button
    self.frame.startGameButton = CreateFrame("Button", nil, self.frame, "UIPanelButtonTemplate")
    self.frame.startGameButton:SetSize(200, 30) -- Set button size
    self.frame.startGameButton:SetText("Start Game!") -- Button text
    self.frame.startGameButton:SetPoint("TOPLEFT", wagerLabel, "BOTTOMLEFT", -5, -20) -- Position it below the wager input field

    -- Join button
    self.frame.joinButton = CreateFrame("Button", nil, self.frame, "UIPanelButtonTemplate")
    self.frame.joinButton:SetSize(200, 30) -- Set button size
    self.frame.joinButton:SetText("Join Game") -- Default text
    self.frame.joinButton:SetPoint("LEFT", self.frame.startGameButton, "RIGHT", 18, 0) -- Position to the right of the start button

    -- Withdraw button
    self.frame.withdrawButton = CreateFrame("Button", nil, self.frame, "UIPanelButtonTemplate")
    self.frame.withdrawButton:SetSize(200, 30) -- Set button size
    self.frame.withdrawButton:SetText("Withdraw Game") -- Default text
    self.frame.withdrawButton:SetPoint("LEFT", self.frame.startGameButton, "RIGHT", 18, -30) -- Position to the right of the start button

    -- Roll button
    self.frame.rollButton = CreateFrame("Button", nil, self.frame, "UIPanelButtonTemplate")
    self.frame.rollButton:SetSize(200, 30) -- Set button size
    self.frame.rollButton:SetText("Roll me!") -- Default text
    self.frame.rollButton:SetPoint("LEFT", self.frame.startGameButton, "RIGHT", 18, -60) -- Position to the right of the start button
    self.frame.rollButton:SetScript("OnClick", function()
        RandomRoll(1, self:GetWager())
    end)

    -- Reset button
    local resetButton = CreateFrame("Button", nil, self.frame, "UIPanelButtonTemplate")
    resetButton:SetSize(200, 30) -- Set button size
    resetButton:SetText("Reset") -- Default text
    resetButton:SetPoint("TOPLEFT", self.frame.startGameButton, "BOTTOMLEFT", 0, -30) -- Position below the start button

    local function toggleButtons(isJoining)
        if isJoining then
            self.frame.joinButton:Disable()
            self.frame.withdrawButton:Enable()
        else
            self.frame.joinButton:Enable()
            self.frame.withdrawButton:Disable()
        end
    end

    resetButton:SetScript("OnClick", function()
        self:ResetGame(true)
    end)

    self.frame.joinButton:SetScript("OnClick", function()
        SendChatMessage("1", self:GetChannel())
        toggleButtons(true)
    end)

    self.frame.withdrawButton:SetScript("OnClick", function()
        SendChatMessage("-1", self:GetChannel())
        toggleButtons(false)
    end)

    -- Main Button click logic
    local function onStartGameButtonClick()
        local wager = self:GetWager()

        local buttonText = self.frame.startGameButton:GetText()

        if not self:ValidateGroupType() then
            StaticPopup_Show("ZYDECASINO_ERROR", "You are not in a " .. self:GetChannel() .. ".")
            return -- Displays Error
        end

        if buttonText == "Start Game!" then
            self:StartButtonClick()
        elseif buttonText == "Last Call!" then
            self:LastCallClick()
        elseif buttonText == "Start Rolling!" then
            if self:GetPlayerCount(self.players) < 2 then
                StaticPopup_Show("ZYDECASINO_ERROR", "You need at least 2 players!")
                return -- Displays Error
            end
            self:StartRollingClick()
        end
    end

    -- Set the script for button click
    self.frame.startGameButton:SetScript("OnClick", onStartGameButtonClick)

    -- Initially disable the start game button
    self.frame.startGameButton:Disable()

    -- Add an event to check wager input validity and enable start button accordingly
    self.frame.wagerInput:SetScript("OnTextChanged", function(self)
        local wagerText = self:GetText()
        local wager = tonumber(wagerText)

        if wager and wager > 0 then
            ZydeCasino.frame.playerCountLabel:Hide()
            ZydeCasino.frame.startGameButton:Enable() -- Enable start button if wager is valid
        else
            ZydeCasino.frame.startGameButton:Disable() -- Disable it if not
        end
    end)

    -- Defaults
    self.frame.joinButton:Disable() -- Disable Join Button by default
    self.frame.withdrawButton:Disable() -- Disable by default
    self.frame.rollButton:Disable() -- Disable by default
    self.frame.playerCountLabel:Hide() -- Hide by default

    -- Dragging functionality
    self.frame:SetScript("OnMouseDown", function(self)
        self:StartMoving()
    end)

    self.frame:SetScript("OnMouseUp", function(self)
        self:StopMovingOrSizing()
    end)

    -- Create Tabs
    self:CreateTabs()

    -- Initially hide the frame
    self.frame:Hide()
end

function ZydeCasino:ValidateGroupType()
    if self.mode == GameMode.RAID and IsInRaid() then
        return true
    elseif self.mode == GameMode.PARTY and IsInGroup() and not IsInRaid() then
        return true
    elseif self.mode == GameMode.GUILD then
        return true
    else
        return false
    end
end

function ZydeCasino:StartButtonClick()
    self:StateOnStartGame()
    self.frame.startGameButton:SetText("Last Call!")
    self.frame.modeButton:Disable()
    self.frame.joinButton:Enable() -- Enable join button when starting the game
    self.frame.wagerInput:SetTextColor(0.5, 0.5, 0.5) -- Set text color to dark grey
    self.frame.wagerInput:Disable() -- Disable wager input
    self:ResetPlayerCount(true)
    self.frame.playerCountLabel:Show()
    -- Print messages to chat
    SendChatMessage("Zyde's Casino: Aight, it's go time! Type 1 to pull up, -1 if you're bailing. Let's get this bread!", self:GetChannel())
    SendChatMessage(string.format("Zyde's Casino: We bettin' big - %s. Get in or get left!", self:formatNumber(self:GetWager())), self:GetChannel())
end

function ZydeCasino:LastCallClick()
    SendChatMessage("Zyde's Casino: Yo, last chance! Type 1 to hop or -1 to drop!", self:GetChannel())
    self.frame.startGameButton:SetText("Zyde's Casino: Start Rolling, fam!")
end

function ZydeCasino:StartRollingClick()
    self:StateOnRoll()
    SendChatMessage(string.format("Zyde's Casino: Yo, drop them rolls! /roll %s or stay mad.", self:GetWager()), self:GetChannel())
    self:UpdatePlayerRollCount()
    self.frame.startGameButton:SetText("In Progress")
    self.frame.startGameButton:Disable() -- Disable the start game button
    if self.frame.withdrawButton:IsEnabled() then
        self.frame.rollButton:Enable() -- Enable roll button if withdraw button is still enabled
    end
    self.frame.joinButton:Disable()
    self.frame.withdrawButton:Disable()
end

function ZydeCasino:ResetGame(clearLabel)
    self.state = GameState.NOT_PLAYING
    self.frame.modeButton:Enable()
    self.frame.wagerInput:SetText("")
    self.frame.wagerInput:Enable()
    self.frame.startGameButton:SetText("Start Game!")
    self.frame.joinButton:Disable()
    self.frame.withdrawButton:Disable()
    self.frame.rollButton:Disable()
    self:ResetPlayerCount(clearLabel)
end

function ZydeCasino:GetWager()
    local wagerText = ZydeCasino.frame.wagerInput:GetText() -- Get the current text in the wager input
    return tonumber(wagerText) -- Convert to number
end

function ZydeCasino:CreateTab(frame, text, width, height)
    local tab = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    tab:SetSize(width, height)
    tab:SetText(text)
    return tab
end

function ZydeCasino:CreateTabs()
    local tabFrame = CreateFrame("Frame", nil, self.frame)
    tabFrame:SetSize(self.frame:GetWidth(), 40)
    tabFrame:SetPoint("BOTTOMLEFT", self.frame, "BOTTOMLEFT", 0, -40) -- Position the tab frame at the bottom of the main frame

    -- Tab 1
    local rollersTab = self:CreateTab(tabFrame, "Who didn't roll?", 100, 30)
    rollersTab:SetPoint("LEFT", tabFrame, "LEFT", 10, 0)

    -- Tab 2
    local fameShameTab = self:CreateTab(tabFrame, "Fame/Shame", 100, 30)
    fameShameTab:SetPoint("LEFT", rollersTab, "RIGHT", 10, 0)

    -- Tab 3
    local clearHistoryTab = self:CreateTab(tabFrame, "Clear History", 100, 30)
    clearHistoryTab:SetPoint("LEFT", fameShameTab, "RIGHT", 10, 0)

    rollersTab:SetScript("OnClick", function()
        if self.state ~= GameState.ROLLING then
            StaticPopup_Show("ZYDECASINO_ERROR", "The game hasn't started yet!")
            return -- Displays Error
        end
        SendChatMessage("Zyde's Casino: Bruh, deadass roll or get dropped: " .. self:GetUnrolledPlayers(), self:GetChannel())
    end)

    fameShameTab:SetScript("OnClick", function()
        if not self:ValidateGroupType() then
            StaticPopup_Show("ZYDECASINO_ERROR", "You are not in a " .. self:GetChannel() .. ".")
            return -- Displays Error
        end

        self:ShowTopPlayers()
    end)

    clearHistoryTab:SetScript("OnClick", function()
        self:ClearPlayerDataWithConfirmation()
    end)

    -- Style the tab container with a background
    local tabBackground = tabFrame:CreateTexture(nil, "BACKGROUND")
    tabBackground:SetAllPoints(tabFrame)
    tabBackground:SetColorTexture(0, 0, 0, 0.80) -- Dark gray background
end

-- Function to format numbers with commas
function ZydeCasino:formatNumber(amount)
    if amount then
        local strAmount = tostring(amount) -- Convert number to string
        local formatted = strAmount:reverse()
        local result = ""

        for i = 1, #formatted do
            result = result .. formatted:sub(i, i)
            if i % 3 == 0 and i < #formatted then
                result = result .. ","
            end
        end

        return result:reverse() -- Reverse back to get the correct order
    end
    return "0"
end
