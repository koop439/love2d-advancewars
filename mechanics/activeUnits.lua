local towers = require("data.towers")
local cursor = require("mechanics/cursor_movement")
local troops = require("data.troops")
local loveframes = require("lib/LoveFrames-master/loveframes")
active_buildings = {}
active_troops = {}
local ui = require("mechanics/ui")

--Makes a table that shows whats selectable ran on startup
function build_selectable_lookup()
	local lookup = {}
	local layers_to_check = { "Buildings", "Troops", "Ground", "Trees" }

	for _, layer_name in ipairs(layers_to_check) do
		local layer = map.layers[layer_name]
		if layer and layer.type == "tilelayer" then
			for y = 1, map.height do
				for x = 1, map.width do
					local tile = layer.data[y][x]
					if tile and tile.properties and tile.properties.Selectable == true then
						lookup[y] = lookup[y] or {}
						lookup[y][x] = true
					end
				end
			end
		end
	end

	return lookup
end

--Searches for capitals in the beginning from Tiled
function active_search()
	for i = 1, map.height do
		for k = 1, map.width do
			local layer = map.layers["Buildings"]
			local tile = layer.data[i][k]
			if tile and tile.properties and tile.properties.type == "capital" then
				print(k, i)
				print(tile.properties.color)
				local base = towers["capital"]
				local new_capital = {}

				setmetatable(new_capital, { __index = base })

				new_capital:spawn(k, i, tile.properties.color)
				table.insert(active_buildings, new_capital)
			end
		end
	end
end

--This starts the drawing on a selected object --Make esc deselect
function if_selected(selectable)
	for _, building in ipairs(active_buildings) do
		if building.selected then
			draw_spawnable_tiles(get_valid_spawn_tiles(building.x, building.y, building.range, selectable))
			if not building.has_ui then
				building:ui(loveframes)
				building.has_ui = true
			end
		end
	end
end

-- Looks at active buildings and checks if the cursor is equal to where they are gonna add troops
function to_select()
	for _, building in ipairs(active_buildings) do
		if cursor.tileX + 1 == building.x and cursor.tileY + 1 == building.y then
			building.selected = true
			break
		end
	end
end

--[[Not being used
function get_tiles_in_range(origin_x, origin_y, range)
	local tiles = {}

	for dy = -range, range do
		for dx = -range, range do
			-- Skip center tile (optional)
			if dx ~= 0 or dy ~= 0 then
				local tx = origin_x + dx
				local ty = origin_y + dy

				-- You can add bounds checking here if needed
				table.insert(tiles, { x = tx, y = ty })
			end
		end
	end

	return tiles
end

--Not being used
function draw_range(tiles)
	local gid = 80
	local tiler = map.tiles[gid]
	local img = map.tilesets[tiler.tileset].image
	for _, tile in ipairs(tiles) do
		love.graphics.draw(img, tiler.quad, (tile.x - 1) * map.tilewidth, (tile.y - 1) * map.tilewidth)
	end
end
]]

--Puts valid tiles into a list 
function get_valid_spawn_tiles(origin_x, origin_y, range, selectable_lookup)
	local valid_tiles = {}

	for dy = -range, range do
		for dx = -range, range do
			local tx = origin_x + dx
			local ty = origin_y + dy

			if
				(dx ~= 0 or dy ~= 0)
				and tx >= 1
				and tx <= map.width
				and ty >= 1
				and ty <= map.height
				and selectable_lookup[ty]
				and selectable_lookup[ty][tx]
			then
				table.insert(valid_tiles, { x = tx, y = ty })
			end
		end
	end

	return valid_tiles
end

-- Works with the other function to draw from the valid tiles
function draw_spawnable_tiles(valid_tiles)
	local gid = 80
	local tiler = map.tiles[gid]
	local img = map.tilesets[tiler.tileset].image

	for _, tile in ipairs(valid_tiles) do
		love.graphics.draw(img, tiler.quad, (tile.x - 1) * map.tilewidth, (tile.y - 1) * map.tilewidth)
	end
end
