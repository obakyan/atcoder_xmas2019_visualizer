local mfl, mce = math.floor, math.ceil

local pic = {}
local design = nil
local focus = 0


function love.load()
  for i = 1, 64 do
    pic[i] = {}
    pic[i].image = love.graphics.newImage("pieces/p_" .. i .. ".png")
    pic[i].pos = i
  end
  design = love.graphics.newImage("design.png")
end

local function load()
  local f = io.open("out.lua", "r")
  if f then
    f:read("*l")
    local s = f:read("*l")
    local i = 0
    for w in s:gmatch("%d+") do
      i = i + 1
      pic[tonumber(w)].pos = i
    end
    f:close()
  end
end

local function save()
  local f = io.open("out.lua", "w")
  f:write("-- https://github.com/obakyan/atcoder_xmas2019_visualizer\n")
  local picidx = {}
  for i = 1, 64 do
    picidx[i] = 0
  end
  for i = 1, 64 do
    local pos = pic[i].pos
    picidx[pos] = i
  end
  f:write("-- " .. table.concat(picidx, " ") .."\n")
  -- print(1 .. " " .. 2 .. " " .. 3)
  for i = 1, 64 do
    if i % 8 == 1 then
      f:write("print(" .. picidx[i])
    else
      f:write(" .. \" \" .. " .. picidx[i])
      if i % 8 == 0 then
        f:write(")\n")
      end
    end
  end
  f:close()
end

function love.keypressed(key, scancode, rep)
  if key == "s" then
    save()
  elseif key == "r" then
    if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
      load()
    end
  end
end

function love.draw()
  love.graphics.print("press [s] to save", 0, 256)
  love.graphics.print("press [shift + r] to load", 0, 288)
  love.graphics.draw(design, 256, 256)
  for i = 1, 64 do
    local pos = pic[i].pos
    local x = pos % 8
    if x == 0 then x = 8 end
    local y = mce(pos / 8)
    x, y = (x - 1) * 32, (y - 1) * 32
    love.graphics.draw(pic[i].image, x, y)
    love.graphics.print(tostring(i), x + 256, y)
    if i == focus then
      love.graphics.setColor(255, 0, 0)
      love.graphics.rectangle("line", x, y, 32, 32)
      love.graphics.setColor(255, 255, 255)
    end
  end
  love.graphics.setColor(128, 0, 255)
  for i = 1, 7 do
    love.graphics.line(32 * i, 0, 32 * i, 256)
    love.graphics.line(0, 32 * i, 256, 32 * i)
  end
  love.graphics.setColor(255, 255, 255)
  if 0 < focus then
    for i = 1, 64 do
      if i == focus then
        local pos = pic[i].pos
        local x = pos % 8
        if x == 0 then x = 8 end
        local y = mce(pos / 8)
        x, y = (x - 1) * 32, (y - 1) * 32
        love.graphics.setColor(255, 0, 0)
        love.graphics.rectangle("line", x, y, 32, 32)
        love.graphics.setColor(255, 255, 255)
        break
      end
    end
  end
end

function love.mousepressed(x, y, btn, _u)
  x = mce(x / 32)
  y = mce(y / 32)
  local pos = (y - 1) * 8 + x
  local tgt = 0
  for i = 1, 64 do
    if pic[i].pos == pos then
      tgt = i
      break
    end
  end
  if 0 < tgt then
    if focus == 0 then
      focus = tgt
    else
      pic[tgt].pos, pic[focus].pos = pic[focus].pos, pic[tgt].pos
      focus = 0
    end
  end
end
