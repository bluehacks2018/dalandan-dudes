--- Main file for starting up the game.

--- LIBRARIES
local Gamestate = require "libs.hump.gamestate"
local BattleScreen = require "gamestates.battlescreen"
--local LoveDebug = require "libs.LOVEDEBUG.lovedebug"

--- CONSTANTS
local SCREEN_WIDTH = 800
local SCREEN_HEIGHT = 600
local TITLE = "Blue Hacks"

CURRENT_GAMESTATE = "main"

--- Goes to the first gamestate.
function love.load()
  love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
  love.graphics.setDefaultFilter("nearest","nearest")
  Gamestate.registerEvents()
  Gamestate.switch(BattleScreen)
end


--- Updates the title with the game's current FPS.
-- @param dt delta time or time passed since last frame
function love.update(dt)
  love.window.setTitle(TITLE .. " (".. love.timer.getFPS() .. "FPS)")
end


function love.keypressed(key)
  if(key == "q") then 
    print(CURRENT_GAMESTATE)
  elseif(key == "escape") then
    love.event.push("quit")
  end
end
