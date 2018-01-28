local Class = require "libs.hump.class"
local Entity = require "libs.entities.entity"

local Player = Class{
    __includes = Entity
}

function Player:init(hp, atk)
  Entity.init(self, hp, atk)
  self.name = "Archie Pelago"
end

return Player