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
    ["10449761463"] = { -- TSB
        Name = "The Strongest Battlegrounds",
        Scripts = {
            {
                Name = "TSB Stand",
                Callback = function()
                    getgenv().TargetUsername = "EnterFullUsernameHere"
                    loadstring(game:HttpGet(
                        "https://raw.githubusercontent.com/Dragonfly5101/Minosr/refs/heads/main/Stand"
                    ))()
                end
            },
            {
                Name = "Scary Spelling",
                Callback = function()
                    loadstring(game:HttpGet(
                        "https://raw.githubusercontent.com/dayumis/nicegoodgame/refs/heads/main/newestscaryspellingscript"
                    ))()
                end
            }
        }
    },
    ["142823291"] = { -- MM2
        Name = "Murder Mystery 2",
        Scripts = {
            {
                Name = "MM2 Hub (Vertex)",
                Callback = function()
                    loadstring(game:HttpGet("https://raw.smokingscripts.org/vertex.lua"))()
                end
            },
            {
                Name = "Piano Script",
                Callback = function()
                    loadstring(game:HttpGet(
                        "https://hellohellohell0.com/talentless-raw/TALENTLESS.lua",
                        true
                    ))()
                end
            },
            {
                Name = "Emotes",
                Callback = function()
                    loadstring(game:HttpGet("https://api.droply.lol/raw/Emotes.lua"))()
                end
            },
            {
                Name = "Murder vs Sheriff",
                Callback = function()
                    loadstring(game:HttpGet(
                        "https://rawscripts.net/raw/DUELS-Murderers-VS-Sheriffs-MurderVsSheriff-OP-2025-52689"
                    ))()
                end
            }
        }
    },
    ["123974602339071"] = { -- Baseplate (UP)
        Name = "Baseplate (UP)",
        Scripts = { -- empty
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
local GameTab
if CurrentGame then
    GameTab = Window:CreateTab(CurrentGame.Name, 4483362458)
end
local UniversalTab = Window:CreateTab("Universal", 4483362458)
local AltTab = Window:CreateTab("Alt Control", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)
local ScriptBloxTab = Window:CreateTab("ScriptBlox", 4483362458)

-- ================= HOME =================
HomeTab:CreateParagraph({
    Title = getGreeting() .. ", " .. LocalPlayer.Name,
    Content =
        "Welcome to SkidHub\n\n" ..
        "Executor: " .. Executor .. "\n" ..
        "Game: " .. (CurrentGame and CurrentGame.Name or "Not Supported") .. "\n" ..
        "Place ID: " .. game.PlaceId
})

HomeTab:CreateButton({
    Name = "UNC Test",
    Callback = function()
        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/unified-naming-convention/NamingStandard/main/UNCCheckEnv.lua"
        ))()
    end
})

HomeTab:CreateButton({
    Name = "SUNC Test",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/lxte/sunc/main/env-test.lua"))()
    end
})

HomeTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

HomeTab:CreateButton({
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

HomeTab:CreateButton({
    Name = "Join Lowest Ping Server",
    Callback = function()
        local best, bestCount
        local req = game:HttpGet(
            "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        )
        local data = HttpService:JSONDecode(req)

        if data and data.data then
            for _, v in pairs(data.data) do
                if v.id ~= game.JobId and v.playing < v.maxPlayers then
                    if not bestCount or v.playing < bestCount then
                        best = v.id
                        bestCount = v.playing
                    end
                end
            end
        end

        if best then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, best, LocalPlayer)
        end
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
                scriptData.Callback()
                Rayfield:Notify({
                    Title = CurrentGame.Name,
                    Content = scriptData.Name .. " loaded",
                    Duration = 3
                })
            end
        })
    end
end

-- ================= UNIVERSAL =================
UniversalTab:CreateButton({
    Name = "Universal Aimbot (Different)",
    Callback = function()
        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/irlnd7/Universal-Aimbot/main/main.lua"
        ))()
    end
})

UniversalTab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
        ))()
    end
})

UniversalTab:CreateButton({
    Name = "Dark Dex",
    Callback = function()
        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua"
        ))()
    end
})

-- ================= ALT CONTROL =================
local MainName, AltName = "", ""
local OnlinePlayers = {}

AltTab:CreateSection("Online Players")

local function AddOnlineDot(name)
    if OnlinePlayers[name] then return end
    AltTab:CreateLabel({ Name = "🟢 " .. name })
    OnlinePlayers[name] = true
end

AddOnlineDot(LocalPlayer.Name)

AltTab:CreateInput({
    Name = "Main Username",
    PlaceholderText = "Enter your main account name",
    RemoveTextAfterFocusLost = false,
    Callback = function(text) MainName = text end
})

AltTab:CreateInput({
    Name = "Alt Username",
    PlaceholderText = "Enter your alt account name",
    RemoveTextAfterFocusLost = false,
    Callback = function(text) AltName = text end
})

spawn(function()
    while true do
        for _, p in pairs(Players:GetPlayers()) do
            AddOnlineDot(p.Name)
        end
        wait(5)
    end
end)

AltTab:CreateButton({
    Name = "Join Alt to My Server",
    Callback = function()
        if AltName == "" or MainName == "" then
            Rayfield:Notify({Title="Error", Content="Set Main & Alt first!", Duration=3})
            return
        end
        local altPlayer = Players:FindFirstChild(AltName)
        local mainPlayer = Players:FindFirstChild(MainName)
        if not altPlayer or not mainPlayer then
            Rayfield:Notify({Title="Error", Content="Both must be in same server!", Duration=3})
            return
        end
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, altPlayer)
        AddOnlineDot(AltName)
        Rayfield:Notify({Title="Success", Content=AltName.." joined server", Duration=3})
    end
})

AltTab:CreateButton({
    Name = "Run SkidHub on Both",
    Callback = function()
        if MainName == "" or AltName == "" then
            Rayfield:Notify({Title="Error", Content="Set Main & Alt first!", Duration=3})
            return
        end
        AddOnlineDot(MainName)
        AddOnlineDot(AltName)
        Rayfield:Notify({Title="SkidHub", Content="Scripts active on both (if present)", Duration=4})
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

-- ================= SCRIPTBLOX =================
ScriptBloxTab:CreateParagraph({
    Title = "ScriptBlox Browser",
    Content = "Search and run community scripts.\n⚠ Only scripts for this game will appear."
})
ScriptBloxTab:CreateLabel("⚠ Scripts are user-uploaded. Use at your own risk.")
local ResultsSection = ScriptBloxTab:CreateSection("Results")

local function ClearResults()
    for _, child in pairs(ResultsSection:GetChildren()) do
        if child.Name ~= "Label" then
            child:Destroy()
        end
    end
end

local function SearchScriptBloxByGame(query)
    ClearResults()
    local success, response = pcall(function()
        return game:HttpGet(
            "https://scriptblox.com/api/script/search?q="..
            HttpService:UrlEncode(query).."&max=20"
        )
    end)
    if not success then
        Rayfield:Notify({Title="ScriptBlox", Content="Failed to fetch scripts", Duration=3})
        return
    end
    local data = HttpService:JSONDecode(response)
    if not data or not data.result or #data.result.scripts == 0 then
        Rayfield:Notify({Title="ScriptBlox", Content="No scripts found", Duration=3})
        return
    end
    for _, script in ipairs(data.result.scripts) do
        if script.game and tostring(script.gameId) == tostring(game.PlaceId) then
            ScriptBloxTab:CreateButton({
                Name = script.title,
                Callback = function()
                    loadstring(script.script)()
                    Rayfield:Notify({Title="Script Loaded", Content=script.title, Duration=3})
                end
            })
        end
    end
end

ScriptBloxTab:CreateInput({
    Name = "Search ScriptBlox",
    PlaceholderText = "Search scripts for this game",
    RemoveTextAfterFocusLost = true,
    Callback = function(text)
        if text ~= "" then
            SearchScriptBloxByGame(text)
        end
    end
})

-- ================= FINISHED =================
Rayfield:Notify({
    Title = "SkidHub Loaded",
    Content = "Executor: "..Executor,
    Duration = 4
})
