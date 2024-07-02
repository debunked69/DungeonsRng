
local autopickuptoggle = false

function autopickupfunction()
    spawn(function()
        while autopickuptoggle do
            for _, v in pairs(game.Workspace.Runtime.Potions:GetChildren()) do
                if v:IsA("UnionOperation") then
                    v.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
                end
            end
            wait()
        end
    end)
end

local autopotion = false
_G.potion = "Nil"

function autopotionfunction()
    spawn(function()
        while autopotion do
            local args = {
                [1] = _G.potion,
                [2] = 1
            }

            game:GetService("ReplicatedStorage"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PotionInventoryService"):WaitForChild("RF"):WaitForChild("ConsumePotion"):InvokeServer(unpack(args))
            wait()
        end
    end)
end

local autoall = false

function autoallpotionfunction()
    spawn(function()
        while autoall do
            local potions = {"RollSpeed", "Luck", "Shiny"}
            for _, potion in ipairs(potions) do
                local args = {
                    [1] = potion,
                    [2] = 1
                }

                game:GetService("ReplicatedStorage"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PotionInventoryService"):WaitForChild("RF"):WaitForChild("ConsumePotion"):InvokeServer(unpack(args))
            end
            wait()
        end
    end)
end

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'SolixHub [Free] | Dungeons RNG',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Main = Window:AddTab('Main'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Groupbox')

LeftGroupBox:AddToggle('autopickup', {
    Text = 'Auto Pickup Potions',
    Default = false,
    Tooltip = '',

    Callback = function(Value)
        autopickuptoggle = Value
        if autopickuptoggle then
            autopickupfunction()
        end
    end
})

LeftGroupBox:AddDropdown('Pick Potion', {
    Values = { 'None','Luck', 'Speed', 'Shiny' },
    Default = 1,
    Multi = false,
    Tooltip = '',

    Text = 'Pick Potion',

    Callback = function(Value)
        if Value == "Speed" then
            _G.potion = "RollSpeed"
        elseif Value == "Luck" then
            _G.potion = "Luck"
        elseif Value == "Shiny" then
            _G.potion = "Shiny"
        end
    end
})

LeftGroupBox:AddToggle('autopotion', {
    Text = 'Auto Use Potion',
    Default = false,
    Tooltip = '',

    Callback = function(Value)
        autopotion = Value
        if autopotion then
            autopotionfunction()
        end
    end
})

LeftGroupBox:AddToggle('autoallpotion', {
    Text = 'Auto All Potions',
    Default = false,
    Tooltip = '',

    Callback = function(Value)
        autoall = Value
        if autoall then
            autoallpotionfunction()
        end
    end
})




Library:SetWatermarkVisibility(true)


local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1;

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end;

    Library:SetWatermark(('SolixHub | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

Library.KeybindFrame.Visible = true; 

Library:OnUnload(function()
    WatermarkConnection:Disconnect()

    print('Unloaded!')
    Library.Unloaded = true
end)


local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')


MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind 



-- Hand the library over to our managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)


SaveManager:IgnoreThemeSettings()


SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('SolixHub')
SaveManager:SetFolder('SolixHub/dungeonsrng')


SaveManager:BuildConfigSection(Tabs['UI Settings'])

ThemeManager:ApplyToTab(Tabs['UI Settings'])


SaveManager:LoadAutoloadConfig()