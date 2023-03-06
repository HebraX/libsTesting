local gui = {
    orderedToggles = {},
    allRefs = {},
    settings = {
        toggle = Enum.KeyCode.LeftAlt,
        up = Enum.KeyCode.PageUp,
        down = Enum.KeyCode.PageDown,
        select = Enum.KeyCode.Return,
        back = Enum.KeyCode.Backspace,
        increase = Enum.KeyCode.RightBracket,
        decrease = Enum.KeyCode.LeftBracket
    },
    textSize = 14,
    mainGUI = true,
    listenToInput = true,
    currentState = true,
    currentToggle = 0,
    currentYPos = 100
}

local UserInputService = game:GetService("UserInputService")

function gui:getCount(tbl)
    local s = 0

    for i,v in pairs(tbl) do
        s += 1
    end

    return s
end

function gui:addRef(ref)
    self.allRefs[ref] = true
end

function gui:toggleVisibility(state)
    if state == nil then
        state = not self.currentState
        self.currentState = state
    end

    for v,_ in pairs(self.allRefs) do
        v.Visible = state
    end

    --[[
    for _,v in pairs(self.orderedToggles) do
        if v.gui then
            v:toggle(state)
        end
    end
    ]]
end

function gui:nextYPos()
    self.currentYPos += self.textSize
    return self.currentYPos
end

function gui:create(name, defaultState, isNotMain)
    if defaultState ~= nil then
        self.currentState = defaultState
    end
    if isNotMain ~= nil then
        self.mainGUI = not isNotMain
    end

    local guiName = Drawing.new("Text")
    guiName.Font = Drawing.Fonts.Monospace
    guiName.Center = true
    guiName.Outline = true
    guiName.Visible = self.currentState
    guiName.Size = self.textSize
    guiName.Color = Color3.fromRGB(255, 255, 255)
    guiName.Text = name

    guiName.Position = Vector2.new(100, 100)

    self.labelRef = guiName
    self:addRef(guiName)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and self.listenToInput then
            if input.KeyCode == self.settings.up and self.currentState then
                local nextToggle = self.currentToggle - 1
                nextToggle = (nextToggle == 0 and self:getCount(self.orderedToggles)) or nextToggle
                
                if nextToggle ~= 0 then
                    if self.orderedToggles[self.currentToggle] then
                        self.orderedToggles[self.currentToggle].drawingObject.Text = self.orderedToggles[self.currentToggle].baseText
                    end
                    self.currentToggle = nextToggle
                    self.orderedToggles[self.currentToggle].drawingObject.Text = self.orderedToggles[self.currentToggle].gui and ("[ " .. self.orderedToggles[self.currentToggle].baseText .. " ]") or ("--> " .. self.orderedToggles[self.currentToggle].baseText)
                end
            elseif input.KeyCode == self.settings.down and self.currentState then
                local nextToggle = self.currentToggle + 1
                nextToggle = (nextToggle == (self:getCount(self.orderedToggles) + 1) and 1) or nextToggle
                
                if self:getCount(self.orderedToggles) > 0 then
                    if self.orderedToggles[self.currentToggle] then
                        self.orderedToggles[self.currentToggle].drawingObject.Text = self.orderedToggles[self.currentToggle].baseText
                    end
                    self.currentToggle = nextToggle
                    self.orderedToggles[self.currentToggle].drawingObject.Text = self.orderedToggles[self.currentToggle].gui and ("[ " .. self.orderedToggles[self.currentToggle].baseText .. " ]") or ("--> " .. self.orderedToggles[self.currentToggle].baseText)
                end
            elseif input.KeyCode == self.settings.select and self.currentState then
                if self.currentToggle ~= 0 and self.orderedToggles[self.currentToggle].toggle then
                    self.orderedToggles[self.currentToggle]:toggle()
                end
            elseif input.KeyCode == self.settings.increase and self.currentState then
                if self.currentToggle ~= 0 and self.orderedToggles[self.currentToggle].increase then
                    self.orderedToggles[self.currentToggle]:increase()
                end
            elseif input.KeyCode == self.settings.decrease and self.currentState then
                if self.currentToggle ~= 0 and self.orderedToggles[self.currentToggle].decrease then
                    self.orderedToggles[self.currentToggle]:decrease()
                end
            elseif input.KeyCode == self.settings.back and self.currentState then
                if not self.mainGUI and self.backCallback then
                    self.backCallback(false)
                end
            elseif input.KeyCode == self.settings.toggle then
                self:toggleVisibility()
            end
        end
    end)
end

function gui:label(label)
    local guiLabel = Drawing.new("Text")
    guiLabel.Font = Drawing.Fonts.Monospace
    guiLabel.Center = true
    guiLabel.Outline = true
    guiLabel.Visible = self.currentState
    guiLabel.Size = self.textSize
    guiLabel.Color = Color3.fromRGB(255, 255, 255)
    guiLabel.Text = label

    guiLabel.Position = Vector2.new(100, self:nextYPos())

    self:addRef(guiLabel)
end

function gui:category(label)
    local categoryObject = {
        gui = loadstring(game:HttpGet('https://raw.githubusercontent.com/HebraX/libsTesting/testing/gui.lua'))(),
        drawingObject = nil,
        baseText = label
    }

    categoryObject.drawingObject = Drawing.new("Text")
    categoryObject.drawingObject.Font = Drawing.Fonts.Monospace
    categoryObject.drawingObject.Center = true
    categoryObject.drawingObject.Outline = true
    categoryObject.drawingObject.Visible = self.currentState
    categoryObject.drawingObject.Size = self.textSize
    categoryObject.drawingObject.Color = Color3.fromRGB(255, 255, 255)
    categoryObject.drawingObject.Text = label

    categoryObject.drawingObject.Position = Vector2.new(100, self:nextYPos())
    
    categoryObject.gui:create(label, false, true)
    categoryObject.gui.listenToInput = false

    function categoryObject:toggle(state)
        if state == nil then
            state = not self.gui.currentState
        end

        print("enter", state)

        gui.listenToInput = not state
        self.gui.listenToInput = state

        gui:toggleVisibility(not state)
        self.gui:toggleVisibility(state)
        self.gui.currentState = state
    end

    categoryObject.gui.backCallback = function(state)
        if state == nil then
            state = not categoryObject.gui.currentState
        end

        gui.listenToInput = not state
        categoryObject.gui.listenToInput = state

        print("back", state)

        gui:toggleVisibility(not state)
        categoryObject.gui:toggleVisibility(state)
        categoryObject.gui.currentState = state
    end

    table.insert(self.orderedToggles, categoryObject)
    self:addRef(categoryObject.drawingObject)

    return categoryObject.gui
end

function gui:toggle(label, defaultState, settingName, settingChangeCallback)
    local toggleObject = {
        drawingObject = Drawing.new("Text"),
        baseText = label,
        currentState = defaultState or false
    }

    settingChangeCallback = settingChangeCallback or function() end

    toggleObject.drawingObject.Font = Drawing.Fonts.Monospace
    toggleObject.drawingObject.Center = true
    toggleObject.drawingObject.Outline = true
    toggleObject.drawingObject.Visible = self.currentState
    toggleObject.drawingObject.Size = self.textSize
    toggleObject.drawingObject.Color = toggleObject.currentState and Color3.fromRGB(0, 255, 157) or Color3.fromRGB(255, 255, 255)
    toggleObject.drawingObject.Text = label

    toggleObject.drawingObject.Position = Vector2.new(100, self:nextYPos())

    function toggleObject:toggle()
        self.currentState = not self.currentState
        self.drawingObject.Color = self.currentState and Color3.fromRGB(0, 255, 157) or Color3.fromRGB(255, 255, 255)

        settingChangeCallback(settingName, self.currentState)
    end

    table.insert(self.orderedToggles, toggleObject)
    self:addRef(toggleObject.drawingObject)
end

function gui:number(label, defaultValue, minValue, maxValue, steps, settingName, settingChangeCallback)
    local numberObject = {
        drawingObject = Drawing.new("Text"),
        baseText = label,
        currentValue = defaultValue or 0
    }

    settingChangeCallback = settingChangeCallback or function() end

    numberObject.drawingObject.Font = Drawing.Fonts.Monospace
    numberObject.drawingObject.Center = true
    numberObject.drawingObject.Outline = true
    numberObject.drawingObject.Visible = self.currentState
    numberObject.drawingObject.Size = self.textSize
    numberObject.drawingObject.Color = Color3.fromRGB(255, 255, 255)
    numberObject.drawingObject.Text = label

    numberObject.drawingObject.Position = Vector2.new(100, self:nextYPos())

    function numberObject:increase()
        self.currentValue = ((self.currentValue + steps) > maxValue) and maxValue or self.currentValue + steps
        self.drawingObject.Text = label .. ": " .. self.currentValue

        settingChangeCallback(settingName, self.currentValue)
    end

    function numberObject:decrease()
        self.currentValue = ((self.currentValue - steps) < minValue) and minValue or self.currentValue - steps
        self.drawingObject.Text = label .. ": " .. self.currentValue

        settingChangeCallback(settingName, self.currentValue)
    end

    table.insert(self.orderedToggles, numberObject)
    self:addRef(numberObject.drawingObject)
end


return gui
