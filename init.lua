local rc_registry = {}

minetest.register_node("rcblock:controller", {
    description = "RC Block",
    tiles = {"rcblock_controller.png"},
    sounds = default.node_sound_metal_defaults(),

    after_place_node = function(pos, placer)
        local meta = minetest.get_meta(pos)
        local id = tostring(minetest.get_us_time())  -- unique ID
        meta:set_string("id", id)

        rc_registry[id] = pos
        minetest.chat_send_player(placer:get_player_name(),
            "RC Block placed with ID: " .. id)
    end,

    after_dig_node = function(pos, oldnode, oldmeta, digger)
        local id = oldmeta:get_string("id")
        rc_registry[id] = nil
    end,
})
minetest.register_chatcommand("rc", {
    params = "<id> <dir>",
    description = "Move an RC block",
    func = function(name, param)
        local id, dir = param:match("^(%S+)%s+(%S+)$")
        if not id or not dir then
            return false, "Usage: /rc <id> <X+/X-/Y+/Y-/Z+/Z->"
        end

        local pos = rc_registry[id]
        if not pos then
            return false, "No RC block with ID " .. id
        end

        local new = vector.new(pos)

        if dir == "X+" then new.x = new.x + 1 end
        if dir == "X-" then new.x = new.x - 1 end
        if dir == "Y+" then new.y = new.y + 1 end
        if dir == "Y-" then new.y = new.y - 1 end
        if dir == "Z+" then new.z = new.z + 1 end
        if dir == "Z-" then new.z = new.z - 1 end

        -- Move the block
        local node = minetest.get_node(pos)
        minetest.set_node(pos, {name="air"})
        minetest.set_node(new, node)

        -- Update registry
        rc_registry[id] = new

        return true, "Moved RC block " .. id .. " to " .. minetest.pos_to_string(new)
    end
})