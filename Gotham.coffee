# CoffeeScript

# Third Party
window.Howler       =     require "./dependencies/howler.js"
window.PIXI         =     require './dependencies/pixi.js'

# 
Sound       =     require "./modules/Sound.coffee" 
Tween       =     require "./modules/Tween.coffee"
Graphics    =     require "./modules/Graphics.coffee"
Preload     =     require "./modules/Preload.coffee"
GameLoop    =     require "./modules/GameLoop.coffee"
Util        =     require "./util/Util.coffee"

# PIXI Extensions
DisplayObjectContainer    =   require './modules/Extensions/DisplayObjectContainer.coffee'
CanvasRenderer            =   require './modules/Extensions/CanvasRenderer.coffee'
WebGLRenderer             =   require './modules/Extensions/WebGLRenderer.coffee'



class Gotham
  window.Gotham = Gotham

  # Modules
  @Sound = Sound
  @Graphics = Graphics
  @Tween = Tween
  @Util = Util

  # Gotham Engine Dependency Modules
  @GameLoop = new GameLoop()
  @Preload = new Preload()



module.exports = Gotham

