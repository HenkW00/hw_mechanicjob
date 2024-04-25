ESX = exports["es_extended"]:getSharedObject()

-- Locals
local ox_inventory = exports.ox_inventory
local insidee = nil
local ped = PlayerPedId()
local optionNames = {'mechanic'}

-- Exports
exports.ox_target:addModel(mechanicmodels, mechanicoptions)
exports.ox_target:addGlobalVehicle(options)

-- Main blip thread
CreateThread(function() 
  local Mechanicblip = AddBlipForCoord(-205.1958, -1324.8699,30.9134)
  SetBlipSprite(Mechanicblip, 446)
  SetBlipDisplay(Mechanicblip, 2)
  SetBlipScale(Mechanicblip, 0.8)
  SetBlipColour(Mechanicblip, 5)
  SetBlipAsShortRange(Mechanicblip, true)
  BeginTextCommandSetBlipName('STRING')
  AddTextComponentSubstringPlayerName('Garage')
  EndTextCommandSetBlipName(Mechanicblip)
end)

-- Mechanic menu (target)
local options = {
  {
    name = 'mechanic',
    event = 'mechanic_menu',
    icon = 'fa-solid fa-wrench',
    label = 'Mechanic Menu',
    groups = {["mechanic"] = 0},
    distance = 1,
  } 
}

-- Mechanic menu (menu)
RegisterNetEvent('mechanic_menu', function()
  lib.registerContext({
    id = 'mechanic_menulib',
    title = 'Mechanic Menu',
    options = {
      {
        title = 'Repair vehicle',
        description = 'You will use x1 repair kit for repairing the vehicle',
        icon = 'fa-solid fa-wrench',
        onSelect =  repaircar,
      },
      {
        title = 'Clean vehicle',
        description = 'You will use x1 cleaning kit for cleaning the vehicle',
        icon = 'fa-solid fa-hands-bubbles',
        onSelect =  washing,
      },
      {
        title = 'Unlock vehicle',
        description = 'You will use x1 soldering tool for unlocking the vehicle',
        icon = 'fa-solid fa-unlock',
        onSelect =  unlockcar,
      }, 
      {
        title = 'Connect/Place',
        description = 'Connect/place vehicle on flatbed',
        icon = 'fa-solid fa-hand',
        onSelect =  linkcar,
      },
      {
        title = 'Seize',
        description = 'Impound current vehicle',
        icon = 'file-lines',
        onSelect =  delcar,
      },
    }
  })
  lib.showContext('mechanic_menulib')
end)

-- Main function for unlocking vehicle
function unlockcar()
  lib.hideContext()

  local playerPed = PlayerPedId()
  local vehicle = ESX.Game.GetVehicleInDirection(playerPed)
  local weldingtorch = ox_inventory:Search('count', 'welding_torch') 

  if IsPedSittingInAnyVehicle(playerPed) then
    lib.notify({
      title = 'There are players inside', 
      type = 'error'
    })
    return
  end

  if weldingtorch >= 1 and DoesEntityExist(vehicle) then 
    lib.callback('hackcar:remove', false, function(Player) end)
    if DoesEntityExist(vehicle) then
      TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)

      if lib.progressBar({
        duration = 10000,
        label = 'Unlocking',
        useWhileDead = false,
        canCancel = false,
        disable = {
          car = true,
          move = true,
          combat = true,
          mouse = false,
        },
      }) then    
        SetVehicleDoorsLocked(vehicle, 1)
        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
        ClearPedTasksImmediately(playerPed)
      end
    end 
  else
    lib.notify({
      title = 'You need x1 welding gun or are too far from the car', 
      type = 'error'
    })    
  end
end

-- Main function to repair vehicle
function repaircar()
  lib.hideContext()
  local playerPed = PlayerPedId()
  local vehicle = ESX.Game.GetVehicleInDirection(playerPed)
  local repairkit = ox_inventory:Search('count', 'repair_kit') 
  if  repairkit >= 1  and DoesEntityExist(vehicle)  then 
    FreezeEntityPosition(vehicle, true) 
 
     lib.callback('repairkit:remove', false, function(Player)end)
    if DoesEntityExist(vehicle) then
      if lib.progressBar({
        duration = 10000,
        label = 'Vehicle being repaired',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true,
            mouse = true,
        },
        anim = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            clip = 'machinic_loop_mechandplayer'
        },
    }) then    
      SetVehicleFixed(vehicle)
      FreezeEntityPosition(vehicle, false)
      else   
 
      end
    end 
  else
    lib.notify({
      title = 'You need x1 repair tools or too far away from the car', 
      type = 'error'
  })   
  end
end

-- Main function to wash vehicle
function washing()
  lib.hideContext()
  local playerPed = PlayerPedId()
  local vehicle = ESX.Game.GetVehicleInDirection(playerPed)
  local washtool = ox_inventory:Search('count', 'wash_tool').count
  local sponge = ox_inventory:Search('count', 'sponge').count
  
  if washtool >= 1 and sponge >= 1 and DoesEntityExist(vehicle) then 
    FreezeEntityPosition(vehicle, true) 

    lib.callback('washing:remove', false, function(Player) end)

    if lib.progressBar({
      duration = 5000,
      label = 'Cleaning',
      useWhileDead = false,
      canCancel = false,
      disable = {
        car = true,
        move = true,
        combat = true,
        mouse = false,
      },
      anim = {
        dict = 'anim@mp_player_intmenu@key_fob@',
        clip = 'fob_click',
      },
      prop = {
        model = GetHashKey('prop_cs_wipe_strip_s'),
        bone = 57005,
        pos = vector3(0.0, 0.0, 0.0),
        rot = vector3(0.0, 0.0, 0.0),
      },
    }) then   
      washtwo()
    else   
    end
  else
    lib.notify({
      title = 'You need at least x1 cleaning tool and x1 sponge, or are too far from the car', 
      type = 'error'
    })   
  end
end

-- Function to wash vehicle
function washtwo()
  local playerPed = PlayerPedId()
  local vehicle = ESX.Game.GetVehicleInDirection(playerPed)

  if DoesEntityExist(vehicle) then
    if lib.progressBar({
      duration = 5000,
      label = 'Cleaning',
      useWhileDead = false,
      canCancel = false,
      disable = {
        car = true,
        move = true,
        combat = true,
        mouse = false,
      },
      anim = {
        dict = 'timetable@floyd@clean_kitchen@base',
        clip = 'base'
      },
      prop = {
        model = GetHashKey('prop_sponge_01'),
        bone = 28422,
        pos = vector3(0.0, 0.0, -0.01),
        rot = vector3(90.0, 0.0, 0.0)
      },
    }) then    
      SetVehicleDirtLevel(vehicle, 0)
      FreezeEntityPosition(vehicle, false)
      lib.callback('washing:dirtysponge', false, function(Player) end)
    else   
      -- Handle if progress bar was canceled or failed
    end
  else
    -- Handle if vehicle does not exist
  end
end

-- Sink target location
exports.ox_target:addBoxZone({
  coords = vec3(-206.8220, -1332.8005, 30.8903),
  size = vec3(1, 2, 1),
  rotation = 275.8271,
  distance = 2,
  debug = false,
  options = {
      {
        name = 'washsponge',
        event = 'washdirtysponge',
        icon = 'fa-solid fa-hands-bubbles',
        label = 'sink', 
        groups = {["mechanic"] = 0},

      }
  }
})

-- Define a network event handler for washing dirty sponges
RegisterNetEvent('washdirtysponge', function()
  local dirtysponge = ox_inventory:Search('count', 'dirty_sponge').count
   
  if dirtysponge >= 1 then 
    if lib.progressBar({
      duration = 5000,
      label = 'Washing',
      useWhileDead = false,
      canCancel = false,
      disable = {
        car = true,
        move = true,
        combat = true,
        mouse = false,
      },
      anim = {
        dict = 'anim@heists@prison_heistig1_p1_guard_checks_bus',
        clip = 'loop'
      },
      prop = {
        model = GetHashKey('prop_sponge_01'),
        bone = 28422,
        pos = vector3(0.03, 0.05, -0.01),
        rot = vector3(90.0, 0.0, 0.0)
      },
    }) then     
      lib.callback('washing:spongeadd', false, function(Player) end)
    else   
      -- Handle if progress bar was canceled or failed
    end
  else
    lib.notify({
      title = 'You need at least x1 dirty sponge', 
      type = 'error'
    })  
  end  
end)

-- Define a network event handler for when a mechanic shop is accessed
RegisterNetEvent('mechanicshot', function()
  exports.ox_inventory:openInventory('shop', { type = 'mechanicshop', id = 1 })
end)  

-- Function to link vehicles together
function linkcar() 
  lib.hideContext()
  local playerPed = PlayerPedId()
  local vehicle = GetVehiclePedIsIn(playerPed, true)

  local towModel = GetHashKey('flatbed')
  local isVehicleTow = IsVehicleModel(vehicle, towModel)

  if isVehicleTow then
    local targetVehicle = ESX.Game.GetVehicleInDirection()

    if targetVehicle ~= 0 then
      if not IsPedInAnyVehicle(playerPed, true) then
        if vehicle ~= targetVehicle then
          if CurrentlyTowedVehicle == nil then
            AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
            CurrentlyTowedVehicle = targetVehicle 
            lib.notify({
              title = 'Vehicle successfully connected', 
              type = 'inform'
            })
          else 
            lib.notify({
              title = 'You cannot hook up your own trailer', 
              type = 'error'
            })
          end
        else 
          lib.notify({
            title = 'You cannot hook up your own vehicle', 
            type = 'error'
          })
        end
      else 
        lib.notify({
          title = 'You must exit your vehicle to attach another', 
          type = 'error'
        })
      end
    else 
      lib.notify({
        title = 'There are no vehicles to attach', 
        type = 'error'
      })
    end
  else 
    lib.notify({
      title = 'You need a flatbed to link vehicles', 
      type = 'error'
    })
  end
end

-- Function to delete (impund) vehicles
function delcar()
  lib.hideContext()
  local playerPed = PlayerPedId()
  local vehicle = ESX.Game.GetVehicleInDirection(playerPed)

  if IsPedSittingInAnyVehicle(playerPed) then
    lib.notify({
      title = 'There are players inside', 
      type = 'error'
    })
    return
  end

  if DoesEntityExist(vehicle) then 
    TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
    if lib.progressBar({
      duration = 10000,
      label = 'Under seizure',
      useWhileDead = false,
      canCancel = false,
      disable = {
        car = true,
        move = true,
        combat = true,
        mouse = false,
      },
    }) then     
      ESX.Game.DeleteVehicle(vehicle)
      ClearPedTasksImmediately(playerPed)
    else   
      -- Handle if progress bar was canceled or failed
    end
  else
    lib.notify({
      title = 'Too far from the car', 
      type = 'error'
    })    
  end
end

-- Warderobe target location
exports.ox_target:addBoxZone({
  coords = vec3(-224.0325, -1319.8673, 30.8906),
  size = vec3(1, 2, 1),
  rotation = 269.7522,
  distance = 2,
  debug = false,
  options = {
      {
        name = 'mechanicclothing',
        event = 'mechanic_clothing',
        icon = 'fa-solid fa-shirt',
        label = 'Wardrobe', 
        groups = {["mechanic"] = 0},
      }
  }
})

-- Define a network event handler for mechanic clothing selection
RegisterNetEvent('mechanic_clothing', function(args)
  lib.registerContext({
    id = 'mechanic_clothing',
    title = 'Wardrobe', 
    options = {
      {
        title = 'Work clothes',
        description ='Choose',
        onSelect = workclothing,
      },
      {
        title = 'Casual clothes',
        description ='Choose',
        onSelect = loadSkinclothing,
      },
    }
  })
  lib.showContext('mechanic_clothing')
end)

-- Function to apply work clothing to the player
function workclothing(uniform)
  TriggerEvent('skinchanger:getSkin', function(skin)
    local uniformObject

    if skin.sex == 0 then
      uniformObject = Config.Uniforms.work.male
    else
      uniformObject = Config.Uniforms.work.female
    end

    if uniformObject then
      TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
    else
      -- Handle case where uniform object is not found
      print("Uniform object not found.")
    end
  end)
end

-- Function to load skin clothing for the player
function loadSkinclothing()
  ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
    TriggerEvent('skinchanger:loadSkin', skin)
  end)
end

-- Create a new thread that runs indefinitely
Citizen.CreateThread(function()
  while true do
    local sleep = 0
    if IsControlJustReleased(0, 167) and  not insidee  and ESX.PlayerData.job and ESX.PlayerData.job.name == 'burgershot' then  
      lib.showContext('mechanicbillingtwo')
    elseif IsControlJustReleased(0, 177) then      
      HideUI()
    end  
    Citizen.Wait(sleep)
  end      
end)   

-- Function to indicate that the player is inside a specific area
function inside()
  insidee = true
  if IsControlJustReleased(0, 167) and    insidee  and ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then  
    lib.showContext('mechanicbillingone')
  end 
end

-- Function to indicate that the player has exited a specific area
function onExit()
  insidee = false
end

-- Create a new thread that runs indefinitely
Citizen.CreateThread(function()
  while true do
    local sleep = 0
    if IsControlJustReleased(0, 167) and  not insidee  and ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then  
      lib.showContext('mechanicbillingtwo')
    elseif IsControlJustReleased(0, 177) then      
      HideUI()
    end  
    Citizen.Wait(sleep)
  end      
end)  

-- Create a box-shaped zone
local box = lib.zones.box({
  coords = vec3(-201.9793, -1300.0927, 31.2961),
  size = vec3(18, 28, 5),
  rotation = 93.6036,
  debug = false,
  inside = inside, 
  onExit = onExit,
})

-- Function to hide UI elements
function HideUI()
  lib.hideTextUI()
end

-- Register a context menu for mechanic billing
lib.registerContext({
  id = 'mechanicbillingone',
  title = 'Billing',
  options = {
      {
        title = 'Billing',
        description = 'Bill attached players', 
        event = 'advanced_mechanic:mechanicbilling', 
        icon = 'file-lines',
        
      },
      {
        title = 'Take out',
        description = 'Take out the vehicle',
        event = 'advanced_mechanic:mechanicgarageSpawnVehicle',
        icon = 'left-long',
        
      },
      {
        title = 'Deposit',
        description = 'Deposit vehicle',
        event = 'advanced_mechanic:mechanicgarageDeleteVehicle', 
        icon = 'right-long',
        
      },
      {
        title = 'Toolbox',
        description = 'Toolbox', 
        event = 'mechanic:toolchest', 
        icon = 'fa-toolbox',
      },
      {
        title = 'Road Cones',
        description = 'Road Cones', 
        event = 'mechanic:roadcone', 
        icon = 'fa-road-spikes',
      },
    
  },
})

-- Register another context menu for mechanic billing
lib.registerContext({
  id = 'mechanicbillingtwo',
  title = 'Billing',
  options = {
      {
        title = 'Billing',
        description = 'Bill attached players', 
        event = 'advanced_mechanic:mechanicbilling', 
        icon = 'file-lines',
      }, 
      {
        title = 'Toolbox',
        description = 'Toolbox', 
        event = 'mechanic:toolchest', 
        icon = 'fa-toolbox',
      },
      {
        title = 'Road Cones',
        description = 'Road Cones', 
        event = 'mechanic:roadcone', 
        icon = 'fa-road-spikes',
      },
  },
})

-- Register network event for mechanic billing
RegisterNetEvent('advanced_mechanic:mechanicbilling')
AddEventHandler('advanced_mechanic:mechanicbilling', function()
  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
  local input = lib.inputDialog('bill', {{ type = "number", label = 'quantity', default = 0 }, })
  if not input then return end
   local amount = tonumber(input[1])
   if amount >0  then
      if closestPlayer == -1 or closestDistance > 3.0 then 
          lib.notify({
            title = 'Bill',
            description = 'There are no players nearby',
            type = 'error'
        })
      else
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_burgershot',
              'mechanic', amount)
        
          lib.notify({
            title ='Bill',
            description = 'Bill has been sent',
            type = 'success'
        })
      end
   else 
      lib.notify({
        title = 'Bill',
        description = 'Invalid number entered',
        type = 'error'
    })
   end
end)

-- Register network event for spawning mechanic garage vehicles
RegisterNetEvent('advanced_mechanic:mechanicgarageSpawnVehicle')
AddEventHandler('advanced_mechanic:mechanicgarageSpawnVehicle', function(vehicle)
  local playerPed = PlayerPedId()
  local pedCoords = GetEntityCoords(playerPed)

  	ESX.Game.SpawnVehicle(Config.SpawnVehicle.Spawn.model, vector3(pedCoords.x,pedCoords.y, pedCoords.z), pedCoords.w, function(vehicle)
    if DoesEntityExist(vehicle) then  
      DoScreenFadeOut(100)
  		SetPedIntoVehicle(playerPed,vehicle,-1)
      SetVehicleNumberPlateText(vehicle,Config.SpawnVehicle.Spawn.Plate)
      SetVehicleNumberPlateTextIndex(vehicle,vehicle,Config.SpawnVehicle.Spawn.PlateColor)
 
      local ped = PlayerPedId()
      local vehicle = GetVehiclePedIsUsing(ped)
      local model = GetEntityModel(vehicle)
      local name = GetDisplayNameFromVehicleModel(model)
      local plate = GetVehicleNumberPlateText(vehicle)

      TriggerServerEvent('sy_carkeys:CreateKey', plate, name)  
      lib.notify({
        title = 'Mechanic garage',
        description = 'Already obtained the car key, press [U] to lock the vehicle',
        type = 'inform'
    })
    Wait(1000)
    DoScreenFadeIn(100)
    end
 end)
end)
 
-- Register network event for deleting mechanic garage vehicles
RegisterNetEvent('advanced_mechanic:mechanicgarageDeleteVehicle')
AddEventHandler('advanced_mechanic:mechanicgarageDeleteVehicle', function(vehicle)
  local playerPed = PlayerPedId()
  local vehicle = GetVehiclePedIsIn(playerPed, false,-1)
  if GetEntityModel(vehicle) == `flatbed` then
 
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsUsing(ped)
    local model = GetEntityModel(vehicle)
    local name = GetDisplayNameFromVehicleModel(model)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerServerEvent('sy_carkeys:DeleteKey', 1, plate, name)  

    TaskLeaveVehicle(playerPed, vehicle, 0)
    Wait(1000)
    ESX.Game.DeleteVehicle(vehicle)

  else
    lib.notify({
      title = 'Garage',
      description = 'You can only park work vehicles',
      type = 'error'
  })
  end
end)

-- Bossmenu taget location
exports.ox_target:addBoxZone({
  coords = vec3(-195.3991, -1320.9906, 31.0895),
  size = vec3(1, 1, 1),
  rotation = 94.1569,
  distance = 2,
  debug = false,
  options = {
      {
        name = 'mechanicboss',
        event = 'advanced_mechanic:bossmenu',
        icon = 'fa-solid fa-align-justify',
        label = 'Boss menu', 
        groups = {["mechanic"] = 4},
      }
  }
})

-- Register network event for opening the mechanic boss menu
RegisterNetEvent('advanced_mechanic:bossmenu')
AddEventHandler('advanced_mechanic:bossmenu', function()
  TriggerEvent('esx_society:openBossMenu', ESX.PlayerData.job.name, function(data, menu)
    menu.close()
end, {wash = true})
end)   

-- Define an array of model hashes representing mechanic-related objects
local mechanicmodels = {`prop_toolchest_01`,`prop_roadcone02a`}

-- Define options for interacting with mechanic objects
local mechanicoptions = {
  {
    event = "mechanic:pickup", 
    label = "pick up", 
    icon = 'fa-solid fa-hand',
    groups = {["mechanic"] = 0},
    distance = 1.2
  },
}

-- Register network event for mechanic pickup action
RegisterNetEvent('mechanic:pickup', function(data)
  NetworkRequestControlOfEntity(data.entity)
  while not NetworkRequestControlOfEntity(data.entity) do
    Wait(0)
  end 

  if lib.progressCircle({
    duration = 1000,
    position = 'toolches',
    useWhileDead = false,
    canCancel = true,
    disable = {
      car = true,
    },
    anim = {
      dict = 'random@domestic',
      clip = 'pickup_low'
    }
  }) then  
    DeleteEntity(data.entity)
  else 
    -- Handle if pickup action fails
  end
end)

-- Register network event for mechanic toolchest interaction
RegisterNetEvent('mechanic:toolchest',function()
  local ped = PlayerPedId()
  local hash = GetHashKey('prop_toolchest_01')
  local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(ped,0.0,1.0,-0.85))
  RequestModel(hash)
  while not HasModelLoaded(hash) do 
        Wait(0) 
    end 
    if lib.progressCircle({
      duration = 1000,
      position = 'toolches',
      useWhileDead = false,
      canCancel = true,
      disable = {
          car = true,
      },
      anim = {
          dict = 'random@domestic',
          clip = 'pickup_low'
      } 
  }) then  
    toolchest = CreateObjectNoOffset(hash, x, y, z, true, false)
      SetModelAsNoLongerNeeded(hash)
      PlaceObjectOnGroundProperly(toolchest) 
    else 
   end
end)

-- Register network event for mechanic roadcone interaction
RegisterNetEvent('mechanic:roadcone',function()
    local ped = PlayerPedId()
    local hash = GetHashKey('prop_roadcone02a')
    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(ped,0.0,1.0,-0.85))
    RequestModel(hash)
    while not HasModelLoaded(hash) do 
          Wait(0) 
      end 
      if lib.progressCircle({
        duration = 1000,
        position = 'toolches',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'random@domestic',
            clip = 'pickup_low'
        } 
    }) then  
        roadcone = CreateObjectNoOffset(hash, x, y, z, true, false)
        SetModelAsNoLongerNeeded(hash)
        PlaceObjectOnGroundProperly(roadcone) 
      else 
     end
end)