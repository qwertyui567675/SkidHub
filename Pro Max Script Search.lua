-- Pro Max Script Search & Server Tools
-- Rayfield UI

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

-- Window
local Window = Rayfield:CreateWindow({
    Name = "pro search script",
    LoadingTitle = "Pro Max Script Search",
    LoadingSubtitle = "Clean And Not Made By AI",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-------------------
-- ScriptBlox Tab
-------------------
local ScriptTab = Window:CreateTab("ScriptBlox", 4483362458)

ScriptTab:CreateParagraph({
    Title = "Script Browser",
    Content = "Search scripts from ScriptBlox.\n⚠ Scripts are user-uploaded."
})

-- Container for results
local Results = {}

local function clearResults()
    for _, btn in ipairs(Results) do
        pcall(function()
            btn:Destroy()
        end)
    end
    table.clear(Results)
end

local function searchScriptBlox(query)
    clearResults()

    local success, response = pcall(function()
        return game:HttpGet(
            "https://scriptblox.com/api/script/search?q=" ..
            HttpService:UrlEncode(query) ..
            "&max=25"
        )
    end)

    if not success then
        Rayfield:Notify({
            Title = "ScriptBlox",
            Content = "Failed to fetch scripts",
            Duration = 3
        })
        return
    end

    local data = HttpService:JSONDecode(response)
    if not data or not data.result or not data.result.scripts then
        Rayfield:Notify({
            Title = "ScriptBlox",
            Content = "No results found",
            Duration = 3
        })
        return
    end

    for _, script in ipairs(data.result.scripts) do
        -- No game filter, show all scripts
        local btn = ScriptTab:CreateButton({
            Name = script.title,
            Callback = function()
                loadstring(script.script)()
                Rayfield:Notify({
                    Title = "Loaded",
                    Content = script.title,
                    Duration = 3
                })
            end
        })
        table.insert(Results, btn)
    end
end

-- Search box
ScriptTab:CreateInput({
    Name = "Search Scripts",
    PlaceholderText = "Type script name here...",
    RemoveTextAfterFocusLost = true,
    Callback = function(text)
        if text ~= "" then
            searchScriptBlox(text)
        end
    end
})

-------------------
-- Server Options Tab
-------------------
local ServerTab = Window:CreateTab("Server Options", 4483362458)

ServerTab:CreateParagraph({
    Title = "Server Management",
    Content = "See available servers with their region, players, and max players.\nHop to them individually or auto hop."
})

local joinedServers = {}
local autoHop = false
local ServerButtons = {}

-- Clear server buttons
local function clearServerButtons()
    for _, btn in ipairs(ServerButtons) do
        pcall(function() btn:Destroy() end)
    end
    table.clear(ServerButtons)
end

-- Fetch and display servers
local function fetchServers()
    clearServerButtons()
    local pageCursor = nil
    local success, response = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=50")
    end)

    if not success then
        Rayfield:Notify({
            Title = "Server List",
            Content = "Failed to fetch servers",
            Duration = 3
        })
        return
    end

    local data = HttpService:JSONDecode(response)
    if not data or not data.data or #data.data == 0 then
        Rayfield:Notify({
            Title = "Server List",
            Content = "No servers found",
            Duration = 3
        })
        return
    end

    for _, server in ipairs(data.data) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            local region = server.region or "Unknown"
            local btn = ServerTab:CreateButton({
                Name = string.format("[%s] %d/%d Players", region, server.playing, server.maxPlayers),
                Callback = function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Players.LocalPlayer)
                end
            })
            table.insert(ServerButtons, btn)
        end
    end
end

-- Rejoin current server
ServerTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
    end
})

-- Refresh server list
ServerTab:CreateButton({
    Name = "Refresh Servers",
    Callback = fetchServers
})

-- Smart Server Hop (auto pick first available)
local function smartServerHop()
    if #ServerButtons == 0 then fetchServers() end
    for _, btn in ipairs(ServerButtons) do
        btn.Callback() -- hop to first available server
        break
    end
end

ServerTab:CreateButton({
    Name = "Server Hop",
    Callback = smartServerHop
})

-- Continuous Auto Hop
ServerTab:CreateToggle({
    Name = "Auto Server Hop",
    CurrentValue = false,
    Flag = "AutoHop",
    Callback = function(state)
        autoHop = state
        if state then
            Rayfield:Notify({
                Title = "Auto Hop",
                Content = "Auto server hop started",
                Duration = 3
            })
            spawn(function()
                while autoHop do
                    smartServerHop()
                    wait(5)
                end
            end)
        else
            Rayfield:Notify({
                Title = "Auto Hop",
                Content = "Auto server hop stopped",
                Duration = 3
            })
        end
    end
})

-------------------
-- Ready Notification
-------------------
Rayfield:Notify({
    Title = "Fuck you Alek ",
    Content = "Kys Faggot!",
    Duration = 3
})
