-- skeezle-newsalert | Client Script (Scaleform + Sound)
-- Displays authentic GTA-style breaking news banner with sound

local function showBreakingNews(title, msg, bottom, time)
    local scaleform = RequestScaleformMovie("breaking_news")
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(10)
    end

    title = title or Config.DefaultTitle
    msg = msg or Config.DefaultMessage
    bottom = bottom or Config.DefaultBottomMessage
    time = time or Config.DefaultTime or 5

    PushScaleformMovieFunction(scaleform, "breaking_news")
    PopScaleformMovieFunctionVoid()

    BeginScaleformMovieMethod(scaleform, "SET_TEXT")
    PushScaleformMovieMethodParameterString(msg)
    PushScaleformMovieMethodParameterString(bottom)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_SCROLL_TEXT")
    PushScaleformMovieMethodParameterInt(0)
    PushScaleformMovieMethodParameterInt(0)
    PushScaleformMovieMethodParameterString(title)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "DISPLAY_SCROLL_TEXT")
    PushScaleformMovieMethodParameterInt(0)
    PushScaleformMovieMethodParameterInt(0)
    EndScaleformMovieMethod()

    -- 🔊 Play built-in GTA alert tone
    PlaySoundFrontend(-1, "Text_Arrive_Tone", "Phone_SoundSet_Default", true)

    -- 🔊 (Optional) Trigger custom HTML sound if you add breakingnews.ogg in /html/
    SendNUIMessage({ action = 'playNewsSound' })

    -- Draw the banner for duration
    CreateThread(function()
        local timer = time * 1000
        local start = GetGameTimer()
        while GetGameTimer() - start < timer do
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
            Wait(0)
        end
    end)
end

-- Receive broadcast from server
RegisterNetEvent('skeezle:newsalert:show', function(message, duration)
    showBreakingNews(Config.DefaultTitle, message, Config.DefaultBottomMessage, duration)
end)

-- Exports for other scripts
exports('createNews', function(message, duration)
    showBreakingNews(Config.DefaultTitle, message, Config.DefaultBottomMessage, duration)
end)

exports('removeNews', function()
    -- no persistent banner to remove
end)

-- Command registration with ox_lib dialog
CreateThread(function()
    if not Config.AdminAlerts.Enabled then return end

    RegisterCommand('newsalert', function()
        local input = lib.inputDialog('Weazel News — Send Alert', {
            { type = 'input', label = 'Headline', description = 'What headline should appear?', required = true, placeholder = 'Type your headline...' },
            { type = 'number', label = 'Duration (seconds)', default = Config.DefaultTime or 5, min = 1, max = 60 }
        })

        if not input then
            lib.notify({ title = 'Cancelled', description = 'City-wide alert cancelled.', type = 'inform' })
            return
        end

        local message = tostring(input[1] or '')
        local duration = tonumber(input[2]) or (Config.DefaultTime or 5)
        if message == '' then
            lib.notify({ title = 'Missing message', description = 'Please type something to broadcast.', type = 'error' })
            return
        end

        TriggerServerEvent('skeezle:newsalert:send', message, duration)
    end, false)

    TriggerEvent('chat:addSuggestion', '/newsalert', 'Send a Weazel News breaking banner')
end)
