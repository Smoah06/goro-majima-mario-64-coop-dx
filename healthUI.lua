local function render_boss_title(text)
    local scale = 3
    
    -- render to native screen space, with the MENU font
    djui_hud_set_resolution(RESOLUTION_DJUI)
    djui_hud_set_font(FONT_RECOLOR_HUD)

    -- get width of screen and text
    local screenWidth = djui_hud_get_screen_width()
    local width = djui_hud_measure_text(text) * scale
    -- get height of screen and text
    local screenHeight = djui_hud_get_screen_height()
    local height = 64 * scale

    -- set location
    local x = screenWidth - width - 64
    local y = screenHeight*9/12 - height/2

    djui_hud_set_color(0, 0, 0, 128)
    djui_hud_print_text(text, x, y+ 4*scale, scale)
    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_print_text(text, x, y, scale)
end

local function render_background_rect()
    local screenWidth = djui_hud_get_screen_width()
    local width = 1028

    local screenHeight = djui_hud_get_screen_height()
    local height = 64

    local x = screenWidth - width - 32
    local y = screenHeight*4/5 - height/2

    djui_hud_set_color(0, 0, 0, 192)
    djui_hud_render_rect(x, y, width, height)
end

local health_prev_x = 0
local health_prev_width = 0

local HEALTH_BAR_COLORS = {
    {0, 0, 0, 0},
    {251, 165, 4, 255},
    {255, 204, 0, 255},
    {28, 214, 68, 255}
}

local function render_health_bar(health)

    local health_bars = math.floor(health/100)
    local screenWidth = djui_hud_get_screen_width()
    local width = (health - (health_bars)*100) * 1012/100

    local screenHeight = djui_hud_get_screen_height()
    local height = 48

    local x = screenWidth - width - 40
    local y = screenHeight*4/5 - height/2
    if health_bars >= 0 then
        djui_hud_set_color(HEALTH_BAR_COLORS[health_bars + 1][1], HEALTH_BAR_COLORS[health_bars + 1][2], HEALTH_BAR_COLORS[health_bars + 1][3], HEALTH_BAR_COLORS[health_bars + 1][4])
        djui_hud_render_rect(screenWidth - 1012 - 40, y, 1012, height)

        djui_hud_set_color(HEALTH_BAR_COLORS[health_bars + 2][1], HEALTH_BAR_COLORS[health_bars + 2][2], HEALTH_BAR_COLORS[health_bars + 2][3], HEALTH_BAR_COLORS[health_bars + 2][4])
        --djui_hud_render_rect(x, y, width, height)
        djui_hud_render_rect_interpolated(health_prev_x, y, health_prev_width, height, x, y, width, height)
    end
    health_prev_x = x
    health_prev_width = width

end

function render_boss_health(name, health)
    render_boss_title(name)
    render_background_rect()
    render_health_bar(health)
end

gPlayerSyncTable[0].healthbarTimer = 0

currentBossHealth = 0
function on_hud_render()
    if currentBoss ~= nil then
        render_boss_health(currentBoss, currentBossHealth)
    end
    if prevBossHealth == currentBossHealth then
        gPlayerSyncTable[0].healthbarTimer = gPlayerSyncTable[0].healthbarTimer + 1
    else
        gPlayerSyncTable[0].healthbarTimer = 0
    end
    if gPlayerSyncTable[0].healthbarTimer == 300 then
        currentBoss = nil
    end

    prevBossHealth = currentBossHealth
end

hook_event(HOOK_ON_HUD_RENDER, on_hud_render)