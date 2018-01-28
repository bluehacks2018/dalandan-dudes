local Class = require "libs.hump.class"

local Entity = Class{}

function Entity:init(hp, atk)
  self.maxhp = hp
  self.hp = hp
  self.atk = atk
  self.dead = false
end

function Entity:draw()
  --love.graphics.print(self.name ..  " HP: " .. self.hp)
end

function Entity:getHP()
  return self.hp
end

function Entity:getMaxHP()
  return self.maxhp
end

function Entity:dealDamage()
  return self.atk
end

function Entity:isDead()
  return self.dead
end

function Entity:takeDamage(x)
  self.hp = self.hp - x
  if self.hp <= 0 then
    self.hp = 0
    self.dead = true
  end
end

return Entity