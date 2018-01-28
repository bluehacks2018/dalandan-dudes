local Class = require "libs.hump.class"
local Entity = require "libs.entities.entity"
local height = 250
local width = 150
local y = 120

local Enemy = Class{
    __includes = Entity
}
local a = love.graphics.newImage("media/images/guyman_determined.png")
local b = love.graphics.newImage("media/images/guyman_grin.png")
-- Chino Nava's artwork
local Enemies = {
  Person= {hp = 20, atk = 2, img = a},
  Stranger = {hp = 35, atk = 4, img = b}
}

function Enemy:init(x, name)
  Entity.init(self, Enemies[name].hp, Enemies[name].atk)
  self.x= x
  self.name = name
  self.img = Enemies[name].img
  print(self.img)
end

function Enemy:draw()
  --love.graphics.rectangle("line",self.x, y, width, height)
  love.graphics.draw(self.img, self.x-20, y-10, nil, .55, .55)
end

return Enemy