--- Libraries
local Class = require "libs.hump.class"
local Color = require "libs.colors"

local sound = love.audio.newSource("media/sounds/select.wav")

--- Instantiation
local HUD = Class{}
local main_font = love.graphics.newFont("media/fonts/consola.ttf", 25)
local main_font_height = main_font:getHeight()
local sub_font = love.graphics.newFont("media/fonts/consola.ttf", 30)
local sub_font_height = sub_font:getHeight()

--- Constants
local RECTANGLE_RADIUS = 5
local MENU_PADDING = 25
local HUD_RATIO = .25

function HUD:init(enemies, width, height, padding, player)  
  self.player = player
  self.width = width
  self.height = height
  self.padding = padding
  
  self.x = self.padding
  self.y = love.graphics.getHeight() - self.height - self.padding
  
  self.leftX = self.x
  self.leftWidth = self.width * HUD_RATIO
  
  self.rightX = self.leftX + self.leftWidth + self.padding
  self.rightWidth = self.width * (1 - HUD_RATIO) - self.padding
  
  self.menuItemX = self.x + MENU_PADDING
  self.menuItemY = (2 * self.y - main_font_height)/2 
  
  self.menu_items = {"Attack", "Defend", "Escape"}
  
  self.enemies = enemies
  self.sub_items = {
    self.enemies
  }

  
  self.cursor_height = 10
  self.cursor_width = 10
  
  self.menu_cursor = 1
  self.menu_cursor_x = self.leftX + self.padding 
  self.menu_cursor_y = main_font_height/2 - self.cursor_height/2  + self.menuItemY
  
  self.sub_cursor = 0
  self.sub_cursor_x = self.rightX + self.padding 
  self.sub_cursor_y = sub_font_height/2 - self.cursor_height/2  + self.menuItemY
  
  self.action = {""}
  
  self.displaying = false
  self.messages = {}
  
end


function HUD:draw()
  love.graphics.setFont(main_font)
  local r,g,b = love.graphics.getColor()
  
  --- draws the left side
  love.graphics.setColor(0,0,0,225)
  love.graphics.rectangle(
    "fill", self.leftX, self.y, self.leftWidth, self.height, 
    RECTANGLE_RADIUS, RECTANGLE_RADIUS
  )
  
  love.graphics.setColor(r,g,b)
  love.graphics.rectangle(
    "line", self.leftX, self.y, self.leftWidth, self.height, 
    RECTANGLE_RADIUS, RECTANGLE_RADIUS
  )
  
  --- draws the right side
  love.graphics.setColor(0,0,0,225)
  love.graphics.rectangle(
    "fill", self.rightX, self.y, self.rightWidth, self.height, 
    RECTANGLE_RADIUS, RECTANGLE_RADIUS
  )
  
  love.graphics.setColor(r,g,b)
  love.graphics.rectangle(
    "line", self.rightX, self.y, self.rightWidth, self.height, 
    RECTANGLE_RADIUS, RECTANGLE_RADIUS
  )
  
  for i, v in ipairs(self.menu_items) do
    love.graphics.print(
      v, 
      math.floor(self.menuItemX),
      math.floor(self.menuItemY + (MENU_PADDING + main_font_height) * i / 2)
    )
  end
  
  -- main cursor
  love.graphics.rectangle(
    "fill", 
    self.menu_cursor_x, 
    self.menu_cursor_y + (MENU_PADDING + main_font_height)/2 * self.menu_cursor,
    self.cursor_height, self.cursor_width
  )
  
  if(self:hasQueue()) then
    local origFont = love.graphics.getFont()
    love.graphics.setFont(sub_font)
    love.graphics.printf(
      self.messages[1], 
      math.floor(self.rightX + MENU_PADDING),
      math.floor(self.menuItemY + (MENU_PADDING + sub_font_height)/2),
      math.floor(self.rightWidth - MENU_PADDING)
    )
    love.graphics.setFont(origFont)   
    
  -- sub cursor
  elseif(self.sub_cursor ~= 0 and self:checkCommand("attack")) then
    love.graphics.rectangle(
      "fill", 
      self.sub_cursor_x, 
      self.sub_cursor_y + (MENU_PADDING + sub_font_height)/2 * self.sub_cursor,
      self.cursor_height, self.cursor_width
    )
    
    love.graphics.setFont(sub_font)
  
    for i, v in pairs(self.sub_items[self.menu_cursor]) do
      love.graphics.print(
        v.name, 
        math.floor(self.menuItemX + self.rightX),
        math.floor(self.menuItemY + (MENU_PADDING + sub_font_height) * i / 2)
      )
      love.graphics.print(
        "HP: " .. v:getHP() .. "/" .. v:getMaxHP(), 
        math.floor(self.menuItemX + self.rightX + self.rightWidth/2),
        math.floor(self.menuItemY + (MENU_PADDING + sub_font_height) * i / 2)
      )
    end
  else
    love.graphics.setFont(sub_font)
    love.graphics.print(
      self.player.name, 
      math.floor(self.menuItemX + self.rightX),
      math.floor(self.menuItemY + (MENU_PADDING + sub_font_height)/ 2)
    )
    love.graphics.print(
      "HP: " .. self.player:getHP() .. "/" .. self.player:getMaxHP(), 
      math.floor(self.menuItemX + self.rightX + self.rightWidth/2),
      math.floor(self.menuItemY + (MENU_PADDING + sub_font_height)/ 2)
    )
  end
  
end


function HUD:update(dt)
  
end


function HUD:checkCommand(command)
  if(self.sub_cursor ~= 0) then 
    return command == string.lower(self.menu_items[self.menu_cursor])
  end
end


function HUD:selectItem()
  if(self.sub_cursor == 0) then
    command = string.lower(self.menu_items[self.menu_cursor])
    if(command == "attack") then
      self.sub_cursor = 1
      print("Selecting attack target")
    elseif(command == "defend") then
      print("Defending")
    elseif(command == "escape") then
      print("Escaping")
    end
  elseif(self:checkCommand("attack")) then
    -- if attacking, return the command and location of victim
    self.action = {"attack", self.sub_cursor}
  end
end

function HUD:getAction()
  return self.action
end

function HUD:queueMessage(message)
  table.insert(self.messages, message)
end


function HUD:completeAction()
  self.action = {""}
end


function HUD:deselectItem()
  self.sub_cursor = 0
end

function HUD:hasQueue()
  return #self.messages > 0
end

function HUD:dequeueMessage()
  if(self.messages[1] == "You win!") then
    love.event.push("quit")
  elseif(#self.messages == 1) then
    self:deselectItem()
  end
  table.remove(self.messages, 1)
end

function HUD:keypressed(key)
  if(key == "z" and #self.messages > 0 and CURRENT_GAMESTATE == "battlescreen") then
    self:dequeueMessage()
    love.graphics.setColor(Color.WHITE)
    love.audio.play(sound, "static")
  elseif(self.displaying) then
    
  elseif(key == "up") then
    love.audio.play(sound, "static")
    self:moveCursor(-1)
  elseif(key == "down") then
    self:moveCursor(1)
    love.audio.play(sound, "static")
  elseif(key == "z" or key == "return") then
    self:selectItem()
    love.audio.play(sound, "static")
  elseif(key == "x" or key == "backspace") then
    self:deselectItem()
  end
end


function HUD:moveCursor(value)
  if(self.sub_cursor == 0) then
    items = self.menu_items
    self.menu_cursor = (self.menu_cursor + value) % #items
    if self.menu_cursor == 0 then self.menu_cursor = #items end
  else
    items = {}
    for i, v in ipairs(self.sub_items[self.menu_cursor]) do
      table.insert(items, v.name)
    end
    self.sub_cursor = (self.sub_cursor + value) % #items
    if self.sub_cursor == 0 then self.sub_cursor = #items end
  end
end

return HUD