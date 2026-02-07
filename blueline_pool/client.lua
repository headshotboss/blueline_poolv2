local playingPool = false
local currentTable = nil

CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for k, table in pairs(Config.Tables) do
            local dist = #(coords - table.coords)

            if dist < 2.0 then
                sleep = 0
                DrawMarker(2, table.coords.x, table.coords.y, table.coords.z + 1.0,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    0.3, 0.3, 0.3,
                    0, 150, 255, 200,
                    false, true, 2, false, nil, nil, false)

                DrawText3D(table.coords.x, table.coords.y, table.coords.z + 1.2,
                    "[E] Play Pool")

                if IsControlJustPressed(0, Config.InteractKey) then
                    StartPoolGame(table)
                end
            end
        end
        Wait(sleep)
    end
end)

function StartPoolGame(table)
    if playingPool then return end
    playingPool = true
    currentTable = table

    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityHeading(PlayerPedId(), table.heading)

    TriggerEvent("chat:addMessage", {
        args = {"🎱 Pool", "Press [SPACE] to shoot | [BACKSPACE] to quit"}
    })

    PoolLoop()
end

function PoolLoop()
    CreateThread(function()
        while playingPool do
            Wait(0)

            if IsControlJustPressed(0, 22) then -- SPACE
                ShootBall()
            end

            if IsControlJustPressed(0, 177) then -- BACKSPACE
                EndPoolGame()
            end
        end
    end)
end

function ShootBall()
    TriggerEvent("chat:addMessage", {
        args = {"🎱 Pool", "You take a shot!"}
    })
end

function EndPoolGame()
    playingPool = false
    FreezeEntityPosition(PlayerPedId(), false)

    TriggerEvent("chat:addMessage", {
        args = {"🎱 Pool", "You stopped playing pool"}
    })
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end