Howler = require '../dependencies/howler.js'

# This class wraps the functionality of Howler.JS {http://goldfirestudios.com/blog/104/howler.js-Modern-Web-Audio-Javascript-Library HowlerJS}
#
# Is protects Howl Object so that its not accessible from this class.
#
# Sound class is generated when preloading the audio file {Preload}
#
# @example Creating a sound object
#   # Preload the audio file
#   Gotham.Preload.mp3("./assets/audio/menu.mp3", "boud", volume: 0.2)
#
# @example Using the sound object
#   # Fetch the sound file
#   sound = Gotham.Preload.fetch("boud", "audio")
#   # Set Volume
#   sound.volume(0.3)
#   # Play Audio
#   sound.play()
#   # Stop Audio
#   sound.stop()
#
class Sound

  # @param {Howl} Howler Sound Object
  constructor: (sound) ->
    @_sound = sound
  
  # Call Howl object's play function Howl.play()
  # @return [void] None
  play: ->
    @_sound.play()

  # Call Howl object's stop function Howl.stop()
  # @return [void] None
  stop: ->
    @_sound.stop()

  # Call Howl object's pause function Howl.pause()
  # @return [void] None
  pause: ->
    @_sound.pause()

  # Call Howl object's play function Howl.play()
  # @param val [Double] between 0.0 and 1.0
  # @return [void] None
  volume: (val) ->
    @_sound.volume(val)
 
  # Seek Forward the Audio Position on the Howl Object
  # @param sec [Integer] Number of seconds to forward
  # @return [void] None
  forward: (sec) ->
    currPos = @_sound.pos()
    @_sound.pos(currPos + sec)

  # Seek Backwards the Audio Position on the Howl Object
  # @param sec [Integer] Number of seconds to forward
  # @return [void] None
  backward: (sec) ->
    currPos = @_sound.pos()
    @_sound.pos(currPos - sec)

  # Mute the Sound, Calling Howl Object's Mute function
  # @return [void] None
  mute: ->
    @_sound.mute()

  # Unmute the Sound, Calling Howl Object's Mute function
  # @return [void] None
  unmute: ->
    @_sound.unmute()

  loop: (state) ->
    @_sound.loop(state)
  




module.exports = Sound