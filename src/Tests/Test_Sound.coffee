

describe 'Sound Module Tests', ->

  # Initialize
  # Preload Sound
  Gotham.Preload.mp3("https://dl.dropboxusercontent.com/u/14613147/test_audio.mp3", "test")

  # Fetch it
  sound = Gotham.Preload.fetch("test", "audio")


  it 'Sound object should not be null, and of type Object', ->
    assert.isNotNull sound, 'Sound are null'
    assert.instanceOf sound, Gotham.Sound, 'Sound are not Gotham.Sound'

  it 'Play() function', ->
    assert.typeOf sound.play , "Function"

  it 'Pause() function', ->
    assert.typeOf sound.pause , "Function"
