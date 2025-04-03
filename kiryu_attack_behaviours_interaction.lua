--- @param m MarioState
--- @param enemyobj Object
function check_for_toad(m, enemyobj)
    enemyobj.oToadDying = 1
    enemyobj.oToadAssassin = m.playerIndex
    enemyobj.oGravity = 4

    local player = nearest_player_to_object(enemyobj);
    if (player ~= nil) then
        enemyobj.oMoveAngleYaw = obj_angle_to_object(player, enemyobj);
    end
    enemyobj.oInteractStatus = 0

    if executing_strong_attack(m) then
        enemyobj.oForwardVel = 20;
        enemyobj.oVelY = 50;
    else
        enemyobj.oForwardVel = 50;
        enemyobj.oVelY = 30;
    end
end

--- @param m MarioState
--- @param enemyobj Object
function check_pink_bomb_on(m, enemyobj)
    if has_action(m, {ACT_SLIDE_KICK, ACT_DIVE_SLIDE, ACT_DIVE, ACT_CHOMP, ACT_DROPKICK}) then
        enemyobj.oToadDying = 1
        enemyobj.oForwardVel = 20;
        enemyobj.oVelY = 40;
        enemyobj.oGravity = 3
        enemyobj.oBounciness = -20

        local player = nearest_player_to_object(enemyobj);
        if (player ~= nil) then
            enemyobj.oMoveAngleYaw = obj_angle_to_object(player, enemyobj);
        end
        enemyobj.oInteractStatus = 0
    else
        obj_mark_for_deletion(enemyobj)
        spawn_sync_object(id_bhvExplosion, E_MODEL_EXPLOSION, enemyobj.oPosX, enemyobj.oPosY, enemyobj.oPosZ, nil)
    end
end

majima_attack_interaction_targets = {
    [id_bhvToadMessage] = check_for_toad,
    [id_bhvBobombBuddyOpensCannon] = check_pink_bomb_on,
    [id_bhvBobombBuddy] = check_pink_bomb_on,
    [id_bhvMessagePanel] = check_for_toad
}

--- @param m MarioState
--- @param interactee Object
function on_interaction(m, interactee)
    if (m.action & ACT_FLAG_ATTACKING) == 0 or not executing_majima_attack(m)  then
        return
    end

    for behavior_id, func in pairs(majima_attack_interaction_targets) do
        if obj_has_behavior_id(interactee, behavior_id) == 1 then
            if interactee.oToadDying ~= 1 or obj_has_behavior_id(interactee, id_bhvToadMessage) == 1 then
                m.particleFlags = m.particleFlags | PARTICLE_HORIZONTAL_STAR
                audio_sample_play(HIT_SOUND, m.pos, 1)
            end
            func(m, interactee)
        end
    end
end

hook_event(HOOK_ON_INTERACT, on_interaction)

--- @param m MarioState
--- @param interactee Object
function allow_interact(m, interactee)
    if (m.action & ACT_FLAG_ATTACKING) == 0 and interactee.oToadDying == 1 then
        return false
    end
    return true
end
hook_event(HOOK_ALLOW_INTERACT, allow_interact)
--- @param m MarioState
--- @return boolean
function executing_strong_attack(m)
    return has_action(m, {ACT_CHOMP, ACT_DROPKICK, ACT_HEAVY_COMBO_4, ACT_HEAVY_COMBO_3, ACT_HEAVY_COMBO_2,
                          ACT_HEAVY_COMBO_1})
end

function executing_majima_attack(m)
    return has_action(m,
        {ACT_MAJIMA_ATTACK, ACT_COMBO_1, ACT_COMBO_2, ACT_COMBO_3, ACT_COMBO_4, ACT_CHOMP, ACT_DROPKICK,
         ACT_HEAVY_COMBO_4, ACT_HEAVY_COMBO_3, ACT_HEAVY_COMBO_2, ACT_HEAVY_COMBO_1})
end

--- @param m MarioState
--- @param actions number[]
--- @return boolean
function has_action(m, actions)
    for _, act in ipairs(actions) do
        if m.action == act then
            return true
        end
    end
    return false
end
