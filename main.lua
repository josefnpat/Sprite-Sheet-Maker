input = love.image.newImageData("input.gif")
sprite_size = 16
spritesheet_sprite_width = 8
output = "output.png"


if input:getWidth()/sprite_size == math.floor(input:getWidth()/sprite_size) then
  print("Image is "..input:getWidth()/sprite_size.." tiles wide.")
else
  print("Error: Image is width not divisible by "..sprite_size)
  love.event.push("q")
end

if input:getHeight()/sprite_size == math.floor(input:getHeight()/sprite_size) then
  print("Image is "..input:getHeight()/sprite_size.." tiles high.")
else
  print("Error: Image height is not divisible by "..sprite_size)
  love.event.push("q")
end

tile_table = {}

max_cycle = (input:getWidth()*input:getHeight())/10
cur_cycle = 0
perc_out = 0

print("Building Hash Table")
print("0%")
for x = 0,(input:getWidth()/sprite_size)-1 do
  for y = 0,(input:getHeight()/sprite_size)-1 do
    local tile_index = "!"
    for ix = 0,sprite_size-1 do
      for iy = 0,sprite_size-1 do
        cur_cycle = cur_cycle + 1
        if cur_cycle >= max_cycle then
          cur_cycle = 0
          perc_out = perc_out + 10
          print(perc_out.."%")
        end
        r,g,b,a=input:getPixel(x*sprite_size+ix,y*sprite_size+iy)
        tile_index = tile_index.."r"..r.."g"..g.."b"..b.."a"..a.."x"
      end
    end
    tile = {}
    tile.x,tile.y = x,y
    if not tile_table[tile_index] then
      tile_table[tile_index] = tile
    end
  end
end

print("100%")

local c = 0
for i,v in pairs(tile_table) do
  c = c + 1
end
print("Unique tiles: "..c)

spritesheet_sprite_height = math.ceil(c / spritesheet_sprite_width)
print("Creating Spritesheet: "..spritesheet_sprite_width.."x"..spritesheet_sprite_height.." ("..spritesheet_sprite_width*sprite_size.."x"..spritesheet_sprite_height*sprite_size..")")
spritesheet = love.image.newImageData(spritesheet_sprite_width * sprite_size,spritesheet_sprite_height * sprite_size)

dx_tile,dy_tile = 0,0

table.sort(tile_table)

for _,v in pairs(tile_table) do
  --print("v.x & v.y",v.x*sprite_size,v.y*sprite_size,"=>","dx&dy",dx_tile*sprite_size,dy_tile*sprite_size)
  --print("v.x & v.y",v.x,v.y,"=>","dx&dy",dx_tile,dy_tile)
  spritesheet:paste(input,
                    dx_tile*sprite_size,dy_tile*sprite_size,
                    v.x*sprite_size,v.y*sprite_size,
                    sprite_size,sprite_size)
  dx_tile = dx_tile + 1
  if dx_tile >= spritesheet_sprite_width then
    dx_tile = 0
    dy_tile = dy_tile + 1
  end
end

local s = spritesheet
s:encode(output)

love.event.quit()
