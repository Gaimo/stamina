local stamina = 100
local maxStamina = 100
local resting = false

local function controls(status)
    toggleControl("forwards", status)
    toggleControl("backwards", status)
    toggleControl("left", status)
    toggleControl("right", status)
    toggleControl("aim_weapon", status)         
end

local function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

addEventHandler("onClientPreRender", root, function()
    
    if not isPedInVehicle(localPlayer) and not doesPedHaveJetPack(localPlayer) then
        local pSpeed = getElementSpeed(localPlayer, 0)
        
        if stamina <= 1 and not resting then
            resting = true
            triggerServerEvent("setPedAnim", resourceRoot, localPlayer, "ped", "IDLE_tired")
            controls(false)            

        elseif stamina >= 15 and resting then
            resting = false
            controls(true)
            setPedAnimation(localPlayer)
        end

        if stamina < 20 then
            setControlState("sprint", false)
            toggleControl("sprint", false)
        elseif stamina >= 20 then
            toggleControl("sprint", true)
        end

        if pSpeed >= 7.5 and pSpeed <= 10 and stamina >= 0 then
            stamina = stamina - 0.05


        elseif pSpeed >= 5 and pSpeed <= 7 and stamina >= 0 then 
            stamina = stamina - 0.01
                   

        elseif pSpeed < 5 and stamina <= maxStamina then 
            stamina = stamina + 0.03
        end

        --dxDrawText(pSpeed, 600, 100, 10, 10)
        dxDrawText(stamina, 600, 130, 10, 10)

    elseif isPedInVehicle(localPlayer) or doesPedHaveJetPack(localPlayer) then
        if stamina <= maxStamina then 
            stamina = stamina + 0.03
        end
    end
end)