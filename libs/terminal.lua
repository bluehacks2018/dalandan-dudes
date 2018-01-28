local Class = require "libs.hump.class"
local Color = require "libs.colors"
local utf8 = require "utf8"

local Terminal = Class{}

TERMINAL_PREFIX = ''
TERMINAL_FONT = love.graphics.newFont('media/fonts/consola.ttf', 30)
TERMINAL_FONT_PIXEL = TERMINAL_FONT:getWidth('a')
TERMINAL_HEIGHT = 70
TERMINAL_PADDING = 10
TERMINAL_BG_COLOR = Color.BLACK
TERMINAL_FG_COLOR = Color.WHITE
TERMINAL_WIDTH = 700

CURSOR_BLINK = 1
CURSOR_HEIGHT = 7
CURSOR_WIDTH = TERMINAL_FONT_PIXEL

--- Goes to the first gamestate.
function Terminal:init(x,y)
  self.text = ''
  self.x = x
  self.y = y
  
  self.editable= true
  
  self.textX = TERMINAL_PADDING + TERMINAL_FONT:getWidth('aaa')
  self.textY = self.y + TERMINAL_HEIGHT/2 - TERMINAL_FONT:getHeight()/2
  
  self.cursor = #TERMINAL_PREFIX 
  self.cursorX = TERMINAL_FONT:getWidth(self.text) + TERMINAL_PADDING 
  self.cursorY = self.textY + TERMINAL_FONT:getHeight()
  self.cursorWidth = CURSOR_WIDTH
  self.cursorHeight = CURSOR_HEIGHT
  self.cursorBlinkTimer = CURSOR_BLINK
end


function Terminal:draw()
  love.graphics.setFont(TERMINAL_FONT)
  
  love.graphics.setColor(Color.GRAY)
  
  love.graphics.line(self.x, math.floor(self.y+50), 600, math.floor(self.y+50))
  
  love.graphics.setColor(TERMINAL_FG_COLOR)
  love.graphics.printf(
    self.text, (math.floor(800-(self:getFontPixel()*#self.text))/2), math.floor(self.textY), TERMINAL_WIDTH
  )
  
  if(self.cursorBlinkTimer >= 0) then
    love.graphics.rectangle(
      "fill", 
      ((800-(self:getFontPixel()*#self.text))/2) + self.cursorX, 
      self.cursorY, 
      self.cursorWidth, self.cursorHeight
    )
  end
  
end


--- Updates the title with the game's current FPS.
-- @param dt delta time or time passed since last frame
function Terminal:update(dt)
  
  self:setCursor()
  
  self.cursorBlinkTimer = self.cursorBlinkTimer - dt
  if(self.cursorBlinkTimer <= -CURSOR_BLINK) then
    self.cursorBlinkTimer = CURSOR_BLINK
  end
  
  print(self.cursor)
  
end

function Terminal:addText(t)
  local substring1 = self:substringAt(1, self.cursor)
  local substring2 = self:substringAt(self.cursor + 1)
  self.text = substring1 .. t .. substring2
  self:increaseCursor(1)
end


function Terminal:deleteChar()
    local text = self.text
    local byteoffset = utf8.offset(text, -1)
    if byteoffset and text ~= TERMINAL_PREFIX then
      if(self.cursor >= #text) then
        text = self:substringAt(1, byteoffset - 1)
      elseif(self.cursor == #TERMINAL_PREFIX) then
        text = TERMINAL_PREFIX .. self:substringAt(self.cursor + 2)
      else
        substring1 = self:substringAt(1, self.cursor - 1) 
        substring2 = self:substringAt(self.cursor + 1)
        text = substring1 .. substring2
      end
      self:increaseCursor(-1)
    end
    self.text = text
end


function Terminal:returnInput()
  input = self:substringAt(#TERMINAL_PREFIX + 1)
  --self.text=TERMINAL_PREFIX
  return input
end

function Terminal:increaseCursor(increment)
  self.cursor = self.cursor + increment
  if(self.cursor <= #TERMINAL_PREFIX) then
    self.cursor = #TERMINAL_PREFIX 
  elseif(self.cursor > #self.text) then
    self.cursor = #self.text
  end
  
end


function Terminal:substringAt(a, b)
    if(b) then
      return string.sub(self.text, a, b)
    end
    return string.sub(self.text, a)
end


function Terminal:setCursor()
  if(self.text == TERMINAL_PREFIX) then
    self.cursorWidth = 15
    self.cursorX = TERMINAL_FONT:getWidth(TERMINAL_PREFIX) + TERMINAL_PADDING
  else
    self.cursorWidth = TERMINAL_FONT:getWidth(
      self:substringAt(self.cursor, self.cursor)
    )
    self.cursorX = TERMINAL_FONT:getWidth(
      self:substringAt(1, self.cursor)
    ) + TERMINAL_PADDING
  end
end

function Terminal:getY()
  return self.y
end

function Terminal:getX()
  return self.x
end

function Terminal:setText(t)
  self.text=t
end

function Terminal:setFontColor(c)
  TERMINAL_FG_COLOR = c
end

function Terminal:getFontPixel()
  return TERMINAL_FONT_PIXEL
end

function Terminal:setEditable(b)
  self.editable=b
end

function Terminal:getEditable()
  return self.editable
end

return Terminal