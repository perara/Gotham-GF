# CoffeeScript

# Third Party
window.Howler       =     require './Dependencies/howler.js'
window.PIXI         =     require './Dependencies/pixi.js'
window.SignalR      =     require './Dependencies/signalR.js'

# 
Sound       =     require './Modules/Sound.coffee'
Tween       =     require './Modules/Tween.coffee'
Graphics    =     require './Modules/Graphics.coffee'
Preload     =     require './Modules/Preload.coffee'
GameLoop    =     require './Modules/GameLoop.coffee'
Util        =     require './Util/Util.coffee'
Network     =     require './Modules/Network.coffee'
Filter      =     require './Modules/Filter.coffee'

# PIXI Extensions
DisplayObjectContainer    =   require './Extensions/DisplayObjectContainer.coffee'
CanvasRenderer            =   require './Extensions/CanvasRenderer.coffee'
WebGLRenderer             =   require './Extensions/WebGLRenderer.coffee'
Array                     =   require './Extensions/Array.coffee'
Object                     =   require './Extensions/Object.coffee'


class Gotham
  window.Gotham = Gotham

  # Modules
  @Sound = Sound
  @Graphics = Graphics
  @Tween = Tween
  @Util = Util
  @Network = Network
  @Filter = Filter

  # Gotham Engine Dependency Modules
  @GameLoop = new GameLoop()
  @Preload = new Preload()



module.exports = Gotham

