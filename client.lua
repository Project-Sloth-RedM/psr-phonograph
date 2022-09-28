-- Variables

local PSRCore = exports['psr-core']:GetCoreObject()
local currentZone = nil
local PlayerData = {}

-- Handlers

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then return end
	PlayerData = PSRCore.Functions.GetPlayerData()
end)

AddEventHandler('PSRCore:Client:OnPlayerLoaded', function()
    PlayerData = PSRCore.Functions.GetPlayerData()
end)

RegisterNetEvent('PSRCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('PSRCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

-- Static Header

local musicHeader = {
    {
        header = 'Play some music!',
        params = {
            event = 'psr-phonograph:client:playMusic'
        }
    }
}

-- Main Menu

function createMusicMenu()
    musicMenu = {
        {
            isHeader = true,
            header = '💿 | Phonograph Booth'
        },
        {
            header = '🎶 | Play a song',
            txt = 'Enter a youtube URL',
            params = {
                event = 'psr-phonograph:client:musicMenu',
                args = {
                    zoneName = currentZone
                }
            }
        },
        {
            header = '⏸️ | Pause Music',
            txt = 'Pause currently playing music',
            params = {
                isServer = true,
                event = 'psr-phonograph:server:pauseMusic',
                args = {
                    zoneName = currentZone
                }
            }
        },
        {
            header = '▶️ | Resume Music',
            txt = 'Resume playing paused music',
            params = {
                isServer = true,
                event = 'psr-phonograph:server:resumeMusic',
                args = {
                    zoneName = currentZone
                }
            }
        },
        {
            header = '🔈 | Change Volume',
            txt = 'Resume playing paused music',
            params = {
                event = 'psr-phonograph:client:changeVolume',
                args = {
                    zoneName = currentZone
                }
            }
        },
        {
            header = '❌ | Turn off music',
            txt = 'Stop the music & choose a new song',
            params = {
                isServer = true,
                event = 'psr-phonograph:server:stopMusic',
                args = {
                    zoneName = currentZone
                }
            }
        }
    }
end

-- Phonograph Booths

local vanilla = BoxZone:Create(Config.Locations['vanilla'].coords, 1, 1, {
    name="vanilla",
    heading=0
})

vanilla:onPlayerInOut(function(isPointInside)
    if isPointInside and PlayerData.job.name == Config.Locations['vanilla'].job then
        currentZone = 'vanilla'
        exports['psr-menu']:showHeader(musicHeader)
    else
        currentZone = nil
        exports['psr-menu']:closeMenu()
    end
end)

-- Events

RegisterNetEvent('psr-phonograph:client:playMusic', function()
    createMusicMenu()
    exports['psr-menu']:openMenu(musicMenu)
end)

RegisterNetEvent('psr-phonograph:client:musicMenu', function()
    local dialog = exports['psr-input']:ShowInput({
        header = 'Song Selection',
        submitText = "Submit",
        inputs = {
            {
                type = 'text',
                isRequired = true,
                name = 'song',
                text = 'YouTube URL'
            }
        }
    })
    if dialog then
        if not dialog.song then return end
        TriggerServerEvent('psr-phonograph:server:playMusic', dialog.song, currentZone)
    end
end)

RegisterNetEvent('psr-phonograph:client:changeVolume', function()
    local dialog = exports['psr-input']:ShowInput({
        header = 'Music Volume',
        submitText = "Submit",
        inputs = {
            {
                type = 'text', -- number doesn't accept decimals??
                isRequired = true,
                name = 'volume',
                text = 'Min: 0.01 - Max: 1'
            }
        }
    })
    if dialog then
        if not dialog.volume then return end
        TriggerServerEvent('psr-phonograph:server:changeVolume', dialog.volume, currentZone)
    end
end)

