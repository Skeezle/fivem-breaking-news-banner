-- skeezle-newsalert | Server Script
-- Handles ACE permission, cooldowns, and broadcasting alerts

local lastAlert = 0

-- Check if a player has ACE permission
local function hasPermission(src)
    local ace = Config.AdminAlerts.AcePermission or 'newsalert.use'
    return IsPlayerAceAllowed(src, ace)
end

-- Event triggered from client to broadcast the alert
RegisterNetEvent('skeezle:newsalert:send', function(message, duration)
    local src = source

    -- Verify feature is enabled
    if not Config.AdminAlerts.Enabled then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Disabled',
            description = 'News alerts are currently disabled.',
            type = 'error'
        })
        return
    end

    -- Check ACE permission
    if not hasPermission(src) then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'No Permission',
            description = 'You are not allowed to use this command.',
            type = 'error'
        })
        return
    end

    -- Enforce cooldown
    local now = os.time()
    local cd = tonumber(Config.AdminAlerts.CooldownSeconds or 0) or 0
    if cd > 0 and (now - lastAlert) < cd then
        if Config.AdminAlerts.ShowCooldownNotification then
            local remain = cd - (now - lastAlert)
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Cooldown Active',
                description = ('You can send another alert in %s seconds.'):format(remain),
                type = 'inform'
            })
        end
        return
    end

    lastAlert = now

    -- Sanitize inputs
    message = tostring(message or '')
    duration = math.max(1, math.min(60, tonumber(duration) or (Config.DefaultTime or 5)))

    -- Broadcast to all clients
    TriggerClientEvent('skeezle:newsalert:show', -1, message, duration)

    -- Optional server console log
    print(('[Skeezle NewsAlert] %s sent a city-wide alert: "%s" (duration %ss)')
        :format(GetPlayerName(src) or 'Unknown', message, duration))
end)
