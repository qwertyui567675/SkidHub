--// SkidHub
--// Made by Nerdywerdy
--// Rayfield UI

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Executor Detection
local Executor = "Unknown"
if identifyexecutor then
    Executor = identifyexecutor()
elseif getexecutorname then
    Executor = getexecutorname()
elseif syn then
    Executor = "Synapse X"
elseif KRNL_LOADED then
    Executor = "KRNL"
elseif fluxus then
    Executor = "Fluxus"
elseif delta then
    Executor = "Delta"
end

-- ================= SUPPORTED GAMES =================
local SupportedGames = {
    ["10449761463"] = { -- The Strongest Battlegrounds
        Name = "The Strongest Battlegrounds",
        Scripts = {
            {
                Name = "TSB Hub",
                Url = "https://raw.githubusercontent.com/JoeyRblx/Strongest/main/TSB.lua"
            },
            {
                Name = "TSB Auto Combo",
                Url = "https://raw.githubusercontent.com/zakater5/LuaRepo/main/TSB.lua"
            }
        }
    },

    ["142823291"] = { -- Murder Mystery 2
        Name = "Murder Mystery 2",
        Scripts = {
            {
                Name = "MM2 ESP",
                Url = "https://raw.githubusercontent.com/IHaveALotOfScripts/MM2/main/ESP.lua"
            },
            {
                Name = "MM2 Silent Aim",
                Url = "https://raw.githubusercontent.com/vertex-peak/scripts/main/mm2.lua"
            }
        }
    },

    ["123974602339071"] = { -- Baseplate (UP)
        Name = "Baseplate (UP)",
        Scripts = {
            {
                Name = "Infinite Yield",
                Url = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
            },
            {
                Name = "Universal Admin",
                Url = "https://raw.githubusercontent.com/infyiff/backup/main/admin.lua"
            }
        }
    }
}

local CurrentGame = SupportedGames[tostring(game.PlaceId)]

-- Greeting
local function getGreeting()
    local hour = tonumber(os.date("%H"))
    if hour >= 5 and hour < 12 then
        return "Good Morning"
    elseif hour >= 12 and hour < 18 then
        return "Good Afternoon"
    else
        return "Good Night"
    end
end

-- ================= WINDOW =================
local Window = Rayfield:CreateWindow({
    Name = "SkidHub",
    LoadingTitle = "SkidHub",
    LoadingSubtitle = "Made by Nerdywerdy",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SkidHub",
        FileName = "Config"
    },
    Discord = { Enabled = false },
    KeySystem = false
})

-- Tabs
local HomeTab = Window:CreateTab("Home", 4483362458)
local UniversalTab = Window:CreateTab("Universal", 4483362458)
local ServerTab = Window:CreateTab("Server", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- Game Tab (only if supported)
local GameTab
if CurrentGame then
    GameTab = Window:CreateTab(CurrentGame.Name, 4483362458)
end

-- ================= HOME =================
HomeTab:CreateParagraph({
    Title = getGreeting() .. ", " .. LocalPlayer.Name,
    Content = 
        "Welcome to SkidHub\n\n" ..
        "Executor: " .. Executor .. "\n" ..
        "Game: " .. (CurrentGame and CurrentGame.Name or "Not Supported") .. "\n" ..
        "Place ID: " .. game.PlaceId
})

-- ================= UNIVERSAL =================
UniversalTab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

UniversalTab:CreateButton({
    Name = "Dark Dex",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua"))()
    end
})

UniversalTab:CreateButton({
    Name = "Universal Aimbot",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V3/main/src/Aimbot.lua"))()
    end
})

-- ================= GAME SPECIFIC =================
if GameTab then
    GameTab:CreateParagraph({
        Title = CurrentGame.Name,
        Content = "Choose a script to launch"
    })

    for _, scriptData in ipairs(CurrentGame.Scripts) do
        GameTab:CreateButton({
            Name = scriptData.Name,
            Callback = function()
                loadstring(game:HttpGet(scriptData.Url))()
                Rayfield:Notify({
                    Title = CurrentGame.Name,
                    Content = scriptData.Name .. " loaded",
                    Duration = 3
                })
            end
        })
    end
end

-- ================= SERVER =================
ServerTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

ServerTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local servers = {}
        local req = game:HttpGet(
            "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        )
        local data = HttpService:JSONDecode(req)

        if data and data.data then
            for _, v in pairs(data.data) do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then
                    table.insert(servers, v.id)
                end
            end
        end

        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(
                game.PlaceId,
                servers[math.random(#servers)],
                LocalPlayer
            )
        end
    end
})

-- ================= SETTINGS =================
SettingsTab:CreateDropdown({
    Name = "Theme",
    Options = { "Default", "Dark", "Light", "Ocean", "Red", "Purple" },
    CurrentOption = "Default",
    Callback = function(theme)
        Rayfield:SetTheme(theme)
    end
})

SettingsTab:CreateParagraph({
    Title = "Credits",
    Content = "SkidHub\nMade by Nerdywerdy"
})

-- Loaded
Rayfield:Notify({
    Title = "SkidHub Loaded",
    Content = "Executor: " .. Executor,
    Duration = 4
})
