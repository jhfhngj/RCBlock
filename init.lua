minetest.register_node("rcblock:rc_block", {
    description = "Remote Control Block",
    tiles = {"rcblock.png"},
    after_place_node = function(pos,placer)
        local meta = minetest.get_meta(pos)
        local secret = tostring(minetest.get_us_time())
        local toSend =  "Hello dear player! Your Control ID is '" .. secret .. "'. Keep this safe unless you want other players using your block!"
        meta:set_int("id",secret)
        minetest.chat_send_player(placer:get_player_name(),toSend)
        minetest.get_node_timer(pos):start(0.1)  -- runs every 100 ms
    end,
    groups = {machine = 5, misc = 1},
    sounds = default.node_sound_metal_defaults()
})
