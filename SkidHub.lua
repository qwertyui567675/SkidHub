-- ScriptBlox & Server GUI
-- Rayfield UI

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

-- Window
local Window = Rayfield:CreateWindow({
    Name = "Script Searcher Pro Ultra Max Version",
    LoadingTitle = "Not Made By Ai ",
    LoadingSubtitle = "Kys Alek Yahire Pena",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-------------------
-- ScriptBlox Tab
-------------------
local ScriptTab = Window:CreateTab("ScriptBlox", 4483362458)

ScriptTab:CreateParagraph({
    Title = "Browser",
    Content = "Search scripts for this game only.\n⚠ User-uploaded content."
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
            Content = "No results",
            Duration = 3
        })
        return
    end

    local found = false
    for _, script in ipairs(data.result.scripts) do
        if script.game and tostring(script.game.gameId) == tostring(game.PlaceId) then
            found = true
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

    if not found then
        Rayfield:Notify({
            Title = "ScriptBlox",
            Content = "No scripts found for this game",
            Duration = 3
        })
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
    Content = "Hop to different servers or rejoin this one.\nSmart server hop avoids repeats."
})

local joinedServers = {}
local autoHop = false

-- Rejoin current server
ServerTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
    end
})

-- Smart Server Hop
local function smartServerHop()
    local foundServer = false
    local pageCursor = nil

    repeat
        local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        if pageCursor then
            url = url.."&cursor="..pageCursor
        end

        local success, response = pcall(function()
            return game:HttpGet(url)
        end)
        if not success then break end

        local data = HttpService:JSONDecode(response)
        if data and data.data then
            for _, server in ipairs(data.data) do
                if server.playing < server.maxPlayers and not joinedServers[server.id] and server.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Players.LocalPlayer)
                    joinedServers[server.id] = true
                    foundServer = true
                    break
                end
            end
            pageCursor = data.nextPageCursor
        end
    until foundServer or not pageCursor

    if not foundServer then
        Rayfield:Notify({
            Title = "Server Hop",
            Content = "No new servers found. Resetting list...",
            Duration = 3
        })
        joinedServers = {}
    end
end

ServerTab:CreateButton({
    Name = "Server Hop",
    Callback = smartServerHop
})

-- Continuous Server Hop toggle
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
                    wait(5) -- wait 5 seconds before next hop
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
    Title = "ScriptBlox & Server Tools",
    Content = "GUI Ready",
    Duration = 3
})
