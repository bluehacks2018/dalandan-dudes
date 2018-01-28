local Dictionary = require "libs.dictionary"
local Gamestate = require "libs.hump.gamestate"
local Class = require "libs.hump.class"
local Terminal = require "libs.terminal"
local Color = require "libs.colors"

FONT = love.graphics.newFont("media/fonts/consola.ttf", 50)

local TranslationGame = Class{}

function TranslationGame:init(bs)
  self.bs = bs
  love.keyboard.setKeyRepeat(true)

  self.offset =50
  
  self.win = false
  self.lose = false
  self.num = 1
  self.time= 0
  self.ctime = 30
  self.wtime = 30
  
  self. timeLeft = 10
  self.isMoving = true
  self.once = true
  
  --language/dialect of the word that will be shown
  self.lang = lang
  
  self.terminal = Terminal(200, 350)
  self.dict = Dictionary()
  
  size50 = love.graphics.newFont(50)
  
end


function TranslationGame:update(dt)
  if(CURRENT_GAMESTATE == "translationgame") then
    if self.once then
      self.timeTemp = self.timeLeft
      self.once = false
    end
    if self.isMoving then
      self.timeLeft = self.timeLeft - dt
    end
    if self.timeLeft >= -1 and self.timeLeft < self.timeTemp then
      self.once = true
      --print(math.floor(timeLeft+0.5))
    end
    if math.floor(self.timeLeft+0.5) == -1 then
      self.lose = true
    end
    self.terminal:update(dt)
  end
end

function TranslationGame:display()
  CURRENT_GAMESTATE = "translationgame"
  love.graphics.setColor(Color.WHITE)
end



function TranslationGame:draw()
  if(CURRENT_GAMESTATE == "translationgame") then
    
    local r,g,b = love.graphics.getColor()
    love.graphics.setColor(0,0,0,240)
    love.graphics.rectangle("fill", 0, 0, 800, 600)
    love.graphics.setColor(r,g,b)
    
    self.terminal:draw()
    
    -- gets a word from the dictionary
    --string = self.dict:getWord(num, lang)
    self.s1, self.s2 = self.dict:getWords("tag","ceb", self.num)
    -- prints the word (centered)
    love.graphics.setFont(TERMINAL_FONT)
    
    -- draw timer
    if self.timeLeft >= 0 and self.timeLeft <= 10 then
      love.graphics.rectangle('fill', 10, 10, self.timeLeft*78, 30)
    end

    --print(time, string, win, lose)
    -- if answer is correct, word changes to the next tone
    if self.win==true then
      self.terminal:setEditable(false)
      self.terminal:setFontColor(Color.GREEN)
      self.lose = false
      self.time = self.time + 1
      self.isMoving = false
      self.timeLeft = 0
      if(self.time == self.ctime) then
          self.terminal:setEditable(true)
          self.time = 0
          self.terminal:setText('')
          self.num = self.num + 1          
          self.timeLeft = 10
          self.isMoving = true
          love.graphics.setColor(Color.WHITE)
          self.terminal:setFontColor(Color.WHITE)
          CURRENT_GAMESTATE = "battlescreen"
          dmg = self.bs.player:dealDamage() * 2
          table.insert(self.bs.hud.messages, 2, "BONUS DAMAGE!")
          message2 = "You deal " .. dmg .. " damage! ..."
          table.insert(self.bs.hud.messages, 3, message2)
          self.bs.enemy_list[self.bs.currentEnemy]:takeDamage(dmg)
          if(self.bs.enemy_list[self.bs.currentEnemy]:isDead()) then
            self.bs.hud:queueMessage(self.bs.enemy_list[self.bs.currentEnemy].name .. " is defeated!")
          end
          
          for i, v in ipairs(self.bs.enemy_list) do
        
            if(v:getHP() > 0) then
              message1 = v.name .. " attacks!"
              message2 = v.name .. " deals "  .. self.bs.player:dealDamage() .. " damage! ..."
              
              self.bs.hud:queueMessage(message1)
              self.bs.hud:queueMessage(message2)
              
              self.bs:battle(v, self.bs.player)
              print(self.bs.player:getHP())
            end
            
            if(i == #self.bs.enemy_list and v:getHP() <= 0) then
                self.bs.hud:queueMessage("All enemies defeated!")
                self.bs.hud:queueMessage("You win!")
             end
          end
          
          self.win = false
      end
          
    elseif self.lose==true then
      self.terminal:setEditable(false)
      self.terminal:setFontColor(Color.RED)
      self.terminal:setText(self.s1)
      self.win = false
      self.time = self.time + 1
      self.isMoving = false
      self.timeLeft = 0
        if(self.time == self.wtime) then
          self.terminal:setEditable(true)
          self.time = 0
          self.terminal:setText('')
          self.num = self.num + 1
          self.timeLeft = 10
          self.isMoving = true
          love.graphics.setColor(Color.WHITE)
          self.terminal:setFontColor(Color.WHITE)
          CURRENT_GAMESTATE = "battlescreen"
          dmg = self.bs.player:dealDamage()
          message2 = "You deal " .. dmg .. " damage! ..."
          table.insert(self.bs.hud.messages, 2, message2)
          self.bs.enemy_list[self.bs.currentEnemy]:takeDamage(dmg)
          
          if(self.bs.enemy_list[self.bs.currentEnemy]:isDead()) then
            self.bs.hud:queueMessage(self.bs.enemy_list[self.bs.currentEnemy].name .. " is defeated!")
          end
          
          for i, v in ipairs(self.bs.enemy_list) do
        
            if(v:getHP() > 0) then
              message1 = v.name .. " attacks!"
              message2 = v.name .. " deals "  .. self.bs.player:dealDamage() .. " damage! ..."
              
              self.bs.hud:queueMessage(message1)
              self.bs.hud:queueMessage(message2)
              
              self.bs:battle(v, self.bs.player)
              print(self.bs.player:getHP())
            end
            
            if(i == #self.bs.enemy_list and v:getHP() <= 0) then
                self.bs.hud:queueMessage("All enemies defeated!")
                self.bs.hud:queueMessage("You win!")
             end
          end
          
          self.lose = false
          
          
          
        end
        
    end
    -- prints the word (centered)
    love.graphics.print(self.s2, (800-(self.terminal:getFontPixel()*#self.s2))/2, 150)
  
  end

end


function TranslationGame:textinput(t)
  self.terminal:addText(t)
end


function TranslationGame:keypressed(key)
  if key == "backspace" then
    if self.terminal:getEditable()==true then
      self.terminal:deleteChar()
    end
  elseif key == "return" then
    if self.terminal:getEditable()==true then
      hold = self.terminal:returnInput()
    end
    if string.lower(self.s1)==string.lower(hold) then
      self.win=true
    elseif string.lower(self.s1)~=string.lower(hold) then
      self.lose=true
    end
  elseif key == "left" then
    self.terminal:increaseCursor(-1)
  elseif key == "right" then
    self.terminal:increaseCursor(1)
  end
end

function TranslationGame:play(num, lang)
  self.dict:getWord(num, lang)
end

function TranslationGame:getWords(l1, l2)
  self.dict:getWords(l1, l2, self.num)
end

function TranslationGame:setLang(l)
  self.lang= l
end

return TranslationGame