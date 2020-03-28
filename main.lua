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

function love.draw()
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
