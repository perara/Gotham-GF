
require './Extensions/Container.coffee'
require './Extensions/PixiRenderer.coffee'
require './Extensions/Array.coffee'
require './Extensions/Object.coffee'
require './Extensions/String.coffee'
require './Extensions/JQuery.coffee'
###*
# Acs as a namespace class,
# @class Gotham
# @module Framework
# @submodule Framework
# @namespace Gotham
###
class Gotham
  window.Gotham = Gotham

  @VERSION = "1.0"

  # Flag for when gotham engine is running (Disabled when not window focus)
  @Running = true

  @Graphics =
    # @property [Gotham.Graphics.Renderer] Renderer Class
    Renderer:           require './Modules/Renderer.coffee'

    # @property [Gotham.Graphics.Scene] Scene Class
    Scene:              require './Modules/Scene.coffee'

    # @property [Gotham.Graphics.Container] Container Class
    Container:          require './Modules/Graphics/Container.coffee'

    # @property [Gotham.Graphics.Graphics] Graphics Class
    Graphics:           require './Modules/Graphics/Graphics.coffee'

    # @property [Gotham.Graphics.Polygon] Polygon Class
    Polygon:            require './Modules/Graphics/Polygon.coffee'

    # @property [Gotham.Graphics.Rectangle] Rectangle Class
    Rectangle:          require './Modules/Graphics/Rectangle.coffee'

    # @property [Gotham.Graphics.Sprite] Sprite Class
    Sprite:             require './Modules/Graphics/Sprite.coffee'

    # @property [Gotham.Graphics.Text] Text Class
    Text:               require './Modules/Graphics/Text.coffee'

    # @property [Gotham.Graphics.Texture] Texture Class
    Texture:            require './Modules/Graphics/Texture.coffee'

    # @property [Gotham.Graphics.Tools] Tools Class
    Tools:              require './Modules/Graphics/Tools.coffee'

  @Controls =
    # @property [Gotham.Controls.Button] Button Class
    Button:             require './Modules/Controls/Button.coffee'

    # @property [Gotham.Controls.Slider] Slider Class
    Slider:             require './Modules/Controls/Slider.coffee'

  @Pattern =
    MVC:
      # @property [Gotham.Pattern.MVC.Controller] MVC Controller Class
      Controller:       require './Modules/Pattern/MVC/Controller.coffee'

      # @property [Gotham.Pattern.MVC.View] MVC View Class
      View:             require './Modules/Pattern/MVC/View.coffee'

  # @property [Gotham.Sound] Sound Class
  @Sound  =             require './Modules/Sound.coffee'

  # @property [Gotham.Tween] Tween.cs Class
  @Tween        =       require './Modules/Tween/Tween.coffee'

  # @property [Gotham.Util] Util Class
  @Util         =       require './Util/Util.coffee'

  # @property [Gotham.Network] Network Class
  @Network      =       require './Modules/Network.coffee'

  # @property [Gotham.Database] Database Class
  @Database     =       new (require './Modules/Database.coffee')()

  # @property [Gotham.GameLoop] Game Loop Class
  @GameLoop     =       new (require './Modules/GameLoop.coffee')()

  # @property [Gotham.Preload] Preloading class
  @Preload      =       new (require './Modules/Preload.coffee')()

if navigator.userAgent.toLowerCase().indexOf('chrome') > -1
  args = [
    '%c %c %c Gotham Game Framework %c %c %c',
    'background: #323232; padding:5px 0;',
    'background: #323232; padding:5px 0;',
    'color: #4169e1; background: #030307; padding:5px 0;',
    'background: #323232; padding:5px 0;',
    'background: #323232; padding:5px 0;',
    'color: #4169e1; background: #030307; padding:5px 0;',
  ];

  window.console.log.apply(console, args);

else if (window.console)
  window.console.log "Gotham Game Framework #{@VERSION} - http://gotham.no"

module.exports = window.Gotham  = Gotham

