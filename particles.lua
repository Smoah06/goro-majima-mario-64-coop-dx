local sins, coss, cur_obj_resolve_wall_collisions, obj_mark_for_deletion, network_player_from_global_index,
 obj_scale, calculate_pitch, obj_move_xyz, spawn_non_sync_object = 
sins, coss, cur_obj_resolve_wall_collisions, obj_mark_for_deletion, network_player_from_global_index,
 obj_scale, calculate_pitch, obj_move_xyz, spawn_non_sync_object

define_custom_obj_fields({
    oOwner = 'u32',
    oShotLevel = 'f32',
    oShotChar = 'u32',  -- 0 is X, 1 is Vile
    oLightArmorShotOffset = 'u32',
    oShotDestroyNextFrame = 'u32',
    oChargeSize = 'f32',
    -- Also used for light armor shot initial phase
    oChargeRot = 'u32',
    oChargeMinSize = 'f32',
    oChargeScaleDownFactor = 'f32',
    oChargeIndex = 'u32',
})

E_blue_fire = smlua_model_util_get_id("bluefire_geo")

local heat_fire_init = function(o)
    o.oFlags = (OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE | OBJ_FLAG_SET_FACE_ANGLE_TO_MOVE_ANGLE)

    local np = network_player_from_global_index(o.oOwner)
    local m = gMarioStates[np.localIndex]
    local m0 = gMarioStates[0]
    local s = gPlayerSyncTable[m.playerIndex]

    local mGfx = m.marioObj.header.gfx

    o.oPosY = mGfx.pos.y + 170

    o.header.gfx.scale.x = 0.8
    o.header.gfx.scale.y = 0.8
    o.header.gfx.scale.z = 0.8

    o.oMoveAngleYaw = m0.area.camera.yaw
    local pitch = calculate_pitch(m0.pos, m0.area.camera.pos)
    o.oMoveAnglePitch = -pitch

    o.oPosX = o.oPosX - 50 * sins(o.oMoveAngleYaw)
    o.oPosZ = o.oPosZ - 50 * coss(o.oMoveAngleYaw)

end

emitting_fire = true
fire_timer = 30

local heat_fire_loop = function(o)

    if (o.oTimer == 1) then
        cur_obj_unhide()
    end
    local np = network_player_from_global_index(o.oOwner)
    local m = gMarioStates[np.localIndex]
    local m0 = gMarioStates[0]
    local s = gPlayerSyncTable[m.playerIndex]

    local mGfx = m.marioObj.header.gfx

    o.oPosX = mGfx.pos.x
    o.oPosY = mGfx.pos.y + 170 + o.oTimer
    o.oPosZ = mGfx.pos.z

    o.header.gfx.scale.x = (1.25) * ((12 - (o.oTimer/1.25))/12)
    o.header.gfx.scale.y = (1.25) * ((12 - o.oTimer)/12)
    o.header.gfx.scale.z = (1.25) * ((12 - (o.oTimer/1.25))/12)

    o.oMoveAngleYaw =  m0.area.camera.yaw
    local pitch = calculate_pitch(m0.pos, m0.area.camera.pos)
    o.oMoveAnglePitch = -pitch

    o.oPosX = o.oPosX - 50 * sins(o.oMoveAngleYaw)
    o.oPosZ = o.oPosZ - 50 * coss(o.oMoveAngleYaw)

    if o.oTimer == 8 then
        if emitting_fire then
            spawn_non_sync_object(id_bhvHeatFire, E_blue_fire, mGfx.pos.x, mGfx.pos.y + 80, mGfx.pos.z, function (obj)
            end)
        end
    end
    if o.oTimer >= 12 then
        cur_obj_hide()
        obj_mark_for_deletion(o)
    end

    if fire_timer >= 30 then
        emitting_fire = false
    else
        emitting_fire = true
    end

    fire_timer = fire_timer + 1

end

function spawn_blue_fire(m)
    local mGfx = m.marioObj.header.gfx
    if fire_timer >= 30 then
        spawn_non_sync_object(id_bhvHeatFire, E_blue_fire, mGfx.pos.x, mGfx.pos.y + 80, mGfx.pos.z, function (obj)
            fire_timer = 0
        end)
    else
        fire_timer = 0
    end
end



id_bhvHeatFire = hook_behavior(nil, OBJ_LIST_UNIMPORTANT, false, heat_fire_init, heat_fire_loop)