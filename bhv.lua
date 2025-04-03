define_custom_obj_fields({
    oToadDying = 'u32',
    oToadDyingTimer = 'u32',
    oToadAssassin = 'u32'
})
--- @param obj Object
--- @param die_function function
local function die_by_timer(obj, die_function)
    if obj.oToadDyingTimer == 0 then
        obj.oToadDyingTimer = 90
    end
    obj.oToadDyingTimer = obj.oToadDyingTimer - 1
    if obj.oToadDyingTimer == 1 then
        die_function(obj)
    end
end

--- @param toad Object
local function die_toad(toad)
    obj_mark_for_deletion(toad)
    spawn_mist_particles();
    spawn_triangle_break_particles(20, 138, 0.7, 3);
    play_sound(SOUND_GENERAL_BREAK_BOX, toad.header.gfx.cameraToObject);
    gMarioStates[toad.oToadAssassin].numLives = gMarioStates[toad.oToadAssassin].numLives + 1
end

--- @param toad Object
local function bhv_custom_toad(toad)

    if toad.oToadDying == 1 then
        local collisionFlags = object_step();
        if ((collisionFlags & OBJ_COL_FLAG_GROUNDED) == OBJ_COL_FLAG_GROUNDED) then
            die_toad(toad)
        end
        die_by_timer(toad, die_toad)
    end
end

hook_behavior(id_bhvToadMessage, OBJ_LIST_PUSHABLE, false, nil, bhv_custom_toad)

--- @param panel Object
local function die_panel(panel)
    obj_mark_for_deletion(panel)
    spawn_mist_particles();
    spawn_triangle_break_particles(20, 138, 0.7, 3);
    play_sound(SOUND_GENERAL_BREAK_BOX, panel.header.gfx.cameraToObject);
end

--- @param panel Object
local function bhv_custom_message_panel(panel)
    if panel.oToadDying == 1 then
        local collisionFlags = object_step();
        if ((collisionFlags & OBJ_COL_FLAG_GROUNDED) == OBJ_COL_FLAG_GROUNDED) then
            die_panel(panel)
        end

        die_by_timer(panel, die_panel)
    end
end

hook_behavior(id_bhvMessagePanel, OBJ_LIST_PUSHABLE, false, nil, bhv_custom_message_panel)

--- @param bomb_on Object
local function die_bomb_on(bomb_on)
    obj_mark_for_deletion(bomb_on)
    spawn_sync_object(id_bhvExplosion, E_MODEL_EXPLOSION, bomb_on.oPosX, bomb_on.oPosY, bomb_on.oPosZ, nil)
end

--- @param bomb_on Object
local function bhv_custom_pink_bomb_on(bomb_on)
    if bomb_on.oToadDying == 1 then
        local collisionFlags = object_step();
        if ((collisionFlags & OBJ_COL_FLAG_GROUNDED) == OBJ_COL_FLAG_GROUNDED) then
            die_bomb_on(bomb_on)
        end

        die_by_timer(bomb_on, die_bomb_on)
    end
end

hook_behavior(id_bhvBobombBuddyOpensCannon, OBJ_LIST_PUSHABLE, false, nil, bhv_custom_pink_bomb_on)
hook_behavior(id_bhvBobombBuddy, OBJ_LIST_PUSHABLE, false, nil, bhv_custom_pink_bomb_on)
