# CoffeeScript

# Third Party
window.Howler       =     require './Dependencies/howler.js'
window.PIXI         =     require './Dependencies/pixi.js'
window.SignalR      =     require './Dependencies/signalR.js'
window.Taffy        =     require './Dependencies/taffy-min'

# pixi.js Extensions
require './Extensions/DisplayObjectContainer.coffee'
require './Extensions/CanvasRenderer.coffee'
require './Extensions/WebGLRenderer.coffee'
require './Extensions/Array.coffee'
require './Extensions/Object.coffee'


class Gotham
  window.Gotham = Gotham


  # Modules
  @Sound        = require './Modules/Sound.coffee'
  @Graphics     = require './Modules/Graphics.coffee'
  @Tween        = require './Modules/Tween.cs/Tween.coffee'
  @Util         = require './Util/Util.coffee'
  @Network      = require './Modules/Network.coffee'
  @Filter       = require './Modules/Filter.coffee'
  @Controls     = require './Modules/Controls.coffee'

  # Gotham Engine Dependency Modules
  @GameLoop     = new (require './Modules/GameLoop.coffee')()
  @Preload      = new (require './Modules/Preload.coffee')()



module.exports = Gotham

