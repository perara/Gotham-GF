
# Preload Class
# This class contains storage for audio, video, image and json
# It keeps track of current loaded object, and the total number of objects
# It can serve these preloaded files on the fly.
# @example Preload element
#   Gotham.Preload.image("/assets/img/settings_close.png", "settings_close", "image")
#   Gotham.Preload.json("/assets/json/json.json", "map")
#
# @example Fetching Element
#   Gotham.Preload.fetch("map", "json")
#   Gotham.Preload.fetch("settings_close", "image")
#
class Preload

  # Setups the preloader
  # Creating Storage array
  constructor: ->

    # Define Databases
    @db_image = Gotham.Database.createTable "preload_images"
    @db_audio = Gotham.Database.createTable "preload_audio"
    @db_data = Gotham.Database.createTable "preload_data"
    #@db_video = Gotham.Database.createTable "preload_video"

    # Callbacks
    @onLoad = ->
    @onComplete = ->

    @_numNetworkLoaded = 0
    @_totalCount = 0


  getTotalCount: ->
    return @_totalCount

  incrementTotalCount: ->
    @_totalCount++

  getNumLoaded: ->
    dbs = [@db_audio, @db_image, @db_data]
    total = @_numNetworkLoaded
    for db in dbs
      total += db().count()
    return total



  downloadJSON = (url, callback) ->
    Gotham.Util.Ajax.GET url, (data, response) ->
      callback(data)

  downloadImage = (url, callback) ->

    texture = Gotham.Graphics.Texture.fromImage(url)

    texture.addListener "update", ->

      # Unset the Update Listener
      this.addListener "update", ->

      callback(texture)

  downloadSound = (url, options, callback) ->


    # HowlerJS Parameters
    howlParameters =
      urls: [url]


    # If Option is set, merge with Howler.js options
    if options?
      howlParameters.merge(options)

    # Load the Sound
    howler = new Howl(howlParameters)
    sound = new Gotham.Sound(howler)
    sound._name = name
    howler.on 'load', ->
      callback(sound)


  # Callback which fires when preloading is complete
  #
  # @param [Callback] callback the callback which are returned
  _onComplete: () ->
    @onComplete()


  # Callback which fires when preloading is complete
  #
  # @param [Callback] callback the callback which are returned
  _onLoad: (source,type, name) ->
    percent = (@getNumLoaded() / @getTotalCount() ) * 100.0

    @onLoad(source, type, name, percent)

    # Call complete if 100%
    if Math.round(percent) == 100
      @_onComplete()

  #
  # Check for weither preloading is complete or not
  #
  isPreloadComplete: () ->
    return (((@._loadedObjects / @._totalObjects ) * 100.0) == 100)


  # Function for preloading image
  #
  # @param [Object] url The item to Preload
  # @param [String] name The name of the object
  image: (url, name) ->
    that = @

    @incrementTotalCount()
    downloadImage url, (image) ->
      that.db_image.insert { name: name, object: image, type: 'image'}
      that._onLoad(image, 'Image', name)

  # Function for preloading mp3
  #
  # @param [Object] url The item to Preload
  # @param [String] name The name of the object
  # @param [Object] options Options for howler
  mp3: (url, name, options) ->
    that = @

    @incrementTotalCount()
    downloadSound url, options, (sound) ->
      that.db_audio.insert { name: name, object: sound, type: 'audio'}
      that._onLoad(sound, 'Audio', name)

  # Function for preloading json
  #
  # @param [Object] url The item to Preload
  # @param [String] name The name of the object
  json: (url, name) ->
    that = @

    @incrementTotalCount()
    downloadJSON url, (json) ->
      that.db_data.insert { name: name, object: json, type: 'json'}
      that._onLoad(json,'JSON', name)

  # Function for preloading network data
  #
  # @param [Object] name - The callback name
  # @param [Table] table - The database table
  # @param [Table] socket - The connected socket
  network: (name, table, socket) ->
    that = @

    @incrementTotalCount()
    socket.Socket.emit name
    socket.Socket.on name , (data) ->
      console.log data
      that._numNetworkLoaded = that._numNetworkLoaded + 1

      if typeof data == 'array'
        table.merge data
      else
        table.insert data

      that._onLoad(data, 'Data', name)







  # Function for fetching an preloaded item
  # @param [String] name Name of the file
  # @param [String] type The type of the file
  fetch: (name, type) ->
    db = @getDatabase(type)
    return db({name: name}).first().object

  # Function which returns the storage for the given type
  # @param [String] type The type of the storage
  getDatabase: (type) ->
    switch type
      when "image"
        return @db_image
      when "audio" 
        return @db_audio
      when "json"
        return @db_data
      else
        throw new Error "Format Not Supported, Preload"
  

module.exports = Preload