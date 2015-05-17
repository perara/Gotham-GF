Howler = require '../dependencies/howler.js'



###*
# This class wraps the functionality of Howler.JS {http://goldfirestudios.com/blog/104/howler.js-Modern-Web-Audio-Javascript-Library HowlerJS}
#
# Is protects Howl Object so that its not accessible from this class.
#
# Sound class is generated when preloading the audio file {Preload}
#
# @class Sound
# @module Framework
# @submodule Framework
# @namespace Gotham
# @example
#   **Preload the audio file**
#
#   ``Gotham.Preload.mp3("./assets/audio/menu.mp3", "boud", volume: 0.2)``
#
#   **Fetch the sound file**
#
#   ``sound = Gotham.Preload.fetch("boud", "audio")``
#
#   **Set Volume**
#
#   ``sound.volume(0.3)``
#
#   **Play Audio**
#
#   ``sound.play()``
#
#   **Stop Audio**
#
#   ``sound.stop()``
# @constructor
# @param {Howl} sound Howler sound object
###
class Sound


  constructor: (sound) ->
    ###*
    # The howler sound object
    # @property {Howl} _sound
    # @private
    ###
    @_sound = sound

  ###*
  # Call Howl object's play function Howl.play()
  # @method play
  # @return [void] None
  ###
  play: ->
    @_sound.play()

  ###*
  # Call Howl object's stop function Howl.stop()
  # @method stop
  # @return [void] None
  ###
  stop: ->
    @_sound.stop()

  ###*
  # Call Howl object's pause function Howl.pause()
  # @method pause
  # @return [void] None
  ###
  pause: ->
    @_sound.pause()

  ###*
  # Call Howl object's play function Howl.play()
  # @method volume
  # @param val {Double} between 0.0 and 1.0
  # @return [void] None
  ###
  volume: (val) ->
    @_sound.volume(val)

  ###*
  # Seek Forward the Audio Position on the Howl Object
  # @method forward
  # @param sec {Integer} Number of seconds to forward
  # @return [void] None
  ###
  forward: (sec) ->
    currPos = @_sound.pos()
    @_sound.pos(currPos + sec)

  ###*
  # Seek Backwards the Audio Position on the Howl Object
  # @method backward
  # @param sec {Integer} Number of seconds to forward
  # @return [void] None
  ###
  backward: (sec) ->
    currPos = @_sound.pos()
    @_sound.pos(currPos - sec)

  ###*
  # Mute the Sound, Calling Howl Object's Mute function
  # @method mute
  # @return [void] None
  ###
  mute: ->
    @_sound.mute()

  ###*
  # Unmute the Sound, Calling Howl Object's Mute function
  # @method unmute
  # @return [void] None
  ###
  unmute: ->
    @_sound.unmute()

  ###*
  # Sets the loop state of the Howl sound
  # @method loop
  # @param state {Boolean} Either true or false based on weither to loop or not
  # @return [void] None
  ###
  loop: (state) ->
    @_sound.loop state
  

module.exports = Sound