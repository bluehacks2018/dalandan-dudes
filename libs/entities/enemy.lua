local Class = require "libs.hump.class"
local Entity = require "libs.entities.entity"
local height = 250
local width = 150
local y = 120

local Enemy = Class{
    __includes = Entity
}

local Enemies = {
  Person= {hp = 20, atk = 2},
  Stranger = {hp = 35, atk = 4}
}

function Enemy:init(x, name)
  Entity.init(self, Enemies[name].hp, Enemies[name].atk)
  self.x= x
  self.name = name
end

function Enemy:draw()
  love.graphics.rectangle("line",self.x, y, width, height)
end

return Enemy