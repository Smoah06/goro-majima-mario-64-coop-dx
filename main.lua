-- name: [CS] Goro Majima
-- description: \\#FF0D00\\KIRYU CHAN!

--Erm 'scuse me what the actual Polony are you doing here?

--[[
    Refrences:
    a good link to be able to make a basic 3D model:
    https://github.com/coop-deluxe/character-template

    API Documentation for Character Select can be found below:
    https://github.com/Squishy6094/character-select-coop/wiki/API-Documentation

    Mario 64 coop dx lua documentation:
    https://github.com/coop-deluxe/sm64coopdx/blob/main/docs/lua/lua.md

    Use some code / used to understand how to make a character mod with moveset:
    https://mods.sm64coopdx.com/mods/milne-the-crystal-fox.194/
]]

function majima_command(msg)
    if msg == "on" then
        djui_chat_message_create("\\#de04fa\\majima\\#ffffff\\ is \\#00C7FF\\on\\#ffffff\\!")
        gPlayerSyncTable[0].overwriteCharToMario = true
        gPlayerSyncTable[0].geodeChar = 1
        gPlayerSyncTable[0].charMoveset = true
        return true
    elseif msg == "off" then
        djui_chat_message_create("\\#de04fa\\majima\\#ffffff\\ is \\#A02200\\off\\#ffffff\\!")
        gPlayerSyncTable[0].overwriteCharToMario = false
        gPlayerSyncTable[0].geodeChar = 0
        gPlayerSyncTable[0].charMoveset = false
        return true
    end
end

local E_MODEL_MAJIMA_MODEL = smlua_model_util_get_id("majima_geo")

local TEXT_MOD_NAME = "Goro Majima Pack"

local PALETTE_CHAR = {
    [PANTS]  = "ffffff",
    [SHIRT]  = "ffffff",
    [GLOVES] = "ffffff",
    [SHOES]  = "000000",
    [HAIR]   = "140800",
    [SKIN]   = "d6b89f",
    [CAP]    = "000000",
    [EMBLEM] = "FF87A7"
}

local VOICETABLE_CHAR = {
    [CHAR_SOUND_ATTACKED] = 'attacked.ogg',
    [CHAR_SOUND_DOH] = 'doh.ogg',
    [CHAR_SOUND_DROWNING] = 'drowning.ogg',
    [CHAR_SOUND_DYING] = 'dying.ogg',
    [CHAR_SOUND_GROUND_POUND_WAH] = 'ground_pound.ogg',
    [CHAR_SOUND_HAHA] = 'haha.ogg',
    [CHAR_SOUND_HAHA_2] = 'haha2.ogg',
    [CHAR_SOUND_HERE_WE_GO] = 'victory.ogg',
    [CHAR_SOUND_HOOHOO] = 'hoohoo.ogg',
    [CHAR_SOUND_MAMA_MIA] = 'mamamia.ogg',
    [CHAR_SOUND_OKEY_DOKEY] = 'okeydokey.ogg',
    [CHAR_SOUND_ON_FIRE] = 'fire.ogg',
    [CHAR_SOUND_OOOF] = 'oof1.ogg',
    [CHAR_SOUND_OOOF2] = 'oof2.ogg',
    [CHAR_SOUND_PUNCH_HOO] = 'kickhoo.ogg',
    [CHAR_SOUND_PUNCH_WAH] = 'wah.ogg',
    [CHAR_SOUND_PUNCH_YAH] = 'yah.ogg',
    [CHAR_SOUND_SO_LONGA_BOWSER] = 'gaybowser.ogg',
    [CHAR_SOUND_TWIRL_BOUNCE] = 'twirl.ogg',
    [CHAR_SOUND_WAAAOOOW] = 'waoow.ogg',
    [CHAR_SOUND_WAH2] = 'wah2.ogg',
    [CHAR_SOUND_WHOA] = 'woah.ogg',
    [CHAR_SOUND_YAHOO] = 'wahoo1.ogg',
    [CHAR_SOUND_YAHOO_WAHA_YIPPEE] = {'wahoo1.ogg','wahoo2.ogg','wahoo3.ogg'},
    [CHAR_SOUND_YAH_WAH_HOO] = {'punch1.ogg','punch2.ogg','punch3.ogg'},
    [CHAR_SOUND_YAWNING] = 'snore.ogg',

}

if _G.charSelectExists then
    myCharPlacement = _G.charSelect.character_add("Goro Majima", {"KIRYU CHAN!!!!", "Press B for light attack.", "Press A after light attack for heavy attack."}, "Mediocre Metastasis", {r = 176, g = 144, b = 28}, E_MODEL_MAJIMA_MODEL, CT_MARIO, get_texture_info("majima"))

    hook_event(HOOK_ON_MODS_LOADED, function()
        _G.charSelect.character_add_palette_preset(E_MODEL_MAJIMA_MODEL, PALETTE_CHAR)
    end)
    _G.charSelect.character_add_voice(E_MODEL_MAJIMA_MODEL, VOICETABLE_CHAR)
    hook_event(HOOK_CHARACTER_SOUND, function (m, sound)
        if _G.charSelect.character_get_voice(m) == VOICETABLE_CHAR then return _G.charSelect.voice.sound(m, sound) end
    end)
    hook_event(HOOK_MARIO_UPDATE, function (m)
        if _G.charSelect.character_get_voice(m) == VOICETABLE_CHAR then return _G.charSelect.voice.snore(m) end
    end)
else
    hook_chat_command(
        "majima",
        "[\\#00C7FF\\on\\#ffffff\\|\\#A02200\\off\\#ffffff\\] turn \\#de04fa\\majima \\#00C7FF\\on \\#ffffff\\or \\#A02200\\off",
        majima_command
    )
    djui_popup_create("\\#ffffdc\\\n To use "..TEXT_MOD_NAME.."\nDownload Character Select Mod\n or type the command \\#00ff37\\ /majima on", 6)
end

function set_mario_model(o)
    if obj_has_behavior_id(o, id_bhvMario) ~= 0 then
        local i = network_local_index_from_global(o.globalPlayerIndex)
        if gPlayerSyncTable[i].geodeChar == 1 then
            if gPlayerSyncTable[i].modelId ~= nil and obj_has_model_extended(o, gPlayerSyncTable[i].modelId) == 0 then
                obj_set_model_extended(o, gPlayerSyncTable[i].modelId)
            end
        end
    end
end

function mario_update(m)

    -- if gPlayerSyncTable[m.playerIndex].overwriteCharToMario then
    --     gNetworkPlayers[m.playerIndex].overrideModelIndex = 0
    -- else
    --     gNetworkPlayers[m.playerIndex].overrideModelIndex = gNetworkPlayers[m.playerIndex].modelIndex
    -- end

    if m.playerIndex == 0 then
        gPlayerSyncTable[0].modelId = E_MODEL_MAJIMA_MODEL
    end

    if m.playerIndex == 0 and _G.charSelectExists then
        if myCharPlacement == _G.charSelect.character_get_current_number() then
            
            gPlayerSyncTable[m.playerIndex].charMoveset = true
        else
            gPlayerSyncTable[m.playerIndex].charMoveset = false
        end
    else
        gPlayerSyncTable[m.playerIndex].charMoveset = false
    end
    if gPlayerSyncTable[m.playerIndex].charMoveset == true
        if (m.action == ACT_WALKING or m.action == ACT_HOLD_WALKING) and m.forwardVel > 0 then
            m.forwardVel = m.forwardVel * 1.05
        end
    end

end

hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_OBJECT_SET_MODEL, set_mario_model)