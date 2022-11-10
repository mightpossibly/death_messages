--[[
death_messages - A Minetest mod which sends a chat message when a player dies.
Copyright (C) 2016  EvergreenTree

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]

-----------------------------------------------------------------------------------------------
local title = "Death Messages"
local version = "0.1.2"
local mname = "death_messages"
-----------------------------------------------------------------------------------------------
dofile(minetest.get_modpath("death_messages").."/settings.txt")
-----------------------------------------------------------------------------------------------

-- A table of quips for death messages.  The first item in each sub table is the
-- default message used when RANDOM_MESSAGES is disabled.
local messages = {}

-- Lava death messages
messages.lava = {
	" ended their life in a pool lava.",
	" fell into lava.",
	" dug straight down.",
	" became the cheese in the mac.",
	" died like Gollum.",
	" was inspired by the Pompeii incident.",
	" melted like wax over a flame.",
	" submerged themselves in lava.",
	" mistook lava for a mud bath.",
	" figured they'd go for a swim in molten rock.",
}

-- Drowning death messages
messages.water = {
	" drowned.",
	" ran out of air.",
	" tried to impersonate an anchor.",
	" forgot he wasn't a fish.",
	" blew one too many bubbles.",
	" apparently thought they had gills.",
	" is sleeping with the fishes.",
	" thought they didn't need oxygen.",
	" was not a mermaid after all.",
	" tried to live life as a fish.",
	" did not figure out how to breathe underwater.",
	" went under."
}

-- Burning death messages
messages.fire = {
	" burned to a crisp.",
	" got a little too warm.",
	" got too close to the camp fire.",
	" just got roasted, hotdog style.",
	" gout burned up. More light that way.",
	" flew too close to the sun.",
	" got burned to a crisp.",
	" is resembling bacon now.",
	" got burnt like an unattended marshmallow.",
	" got cooked like a roast.",
	" squealed like a pig.",
	" did a good job as firewood.",
	" got burnt like it was the dark ages",
	" is now toast."
}

-- Other death messages
messages.other = {
	" died.",
	" did something fatal.",
	" gave up on life.",
	" passed out – permanently.",
	" could not take it anymore.",
	" was outlived.",
	" perished.",
	" died and ressurected.",
	" did not survive.",
	" thought it was all fun and games.",
	" wanted to live, but in the end could not.",
	" forgot to wear their hazmat suit.",
	" found their way to an early grave.",
	" wanted more out of life.",
	" met their fate.",
	" had an appointment with Death.",
	" left this world, only to return moments later.",
	" died a horrible death.",
	" was written into the history books.",
	" is no more.",
	" got reincarnated.",
	" went to visit Hades.",
	" went for a cruise on the River of Death.",
	" thought they were bigger than life.",
	" succumbed to their circumstances.",
	" could not be saved.",
	" probably didn't die from food poisoning.",
	" probably did better than that guy in Saw.",
	" probably didn't choke on a grape seed.",
	" had an idea, but it just didn't work out.",
	" sacrificed themselves for the greater good."
}

--[[ FALL DAMAGE (NOT SUPPORTED IN CURRENT API)

<player> took a nose dive.
<player> thought they could fly.
<player> was not the Wright Brothers after all.
<player> died imitating a seagull.
<player> went bungee jumping without a rope.
<player> hit the ground too fast.
<player> had a hard landing.
<player> failed their experiment with gravity. 

--]]


function get_message(mtype)
	if RANDOM_MESSAGES then
		return messages[mtype][math.random(1, #messages[mtype])]
	else
		return messages[1] -- 1 is the index for the non-random message
	end
end

minetest.register_on_dieplayer(function(player)
	local player_name = player:get_player_name()
	local node = minetest.registered_nodes[minetest.get_node(player:getpos()).name]
	if minetest.is_singleplayer() then
		player_name = "You"
	end
	-- Death by lava
	if node.groups.lava ~= nil then
		minetest.chat_send_all(player_name .. get_message("lava"))
	-- Death by drowning
	elseif player:get_breath() == 0 then
		minetest.chat_send_all(player_name .. get_message("water"))
	-- Death by fire
	elseif node.name == "fire:basic_flame" then
		minetest.chat_send_all(player_name .. get_message("fire"))
	-- Death by something else
	else
		minetest.chat_send_all(player_name .. get_message("other"))
	end

end)

-----------------------------------------------------------------------------------------------
print("[Mod] "..title.." ["..version.."] ["..mname.."] Loaded...")
-----------------------------------------------------------------------------------------------
