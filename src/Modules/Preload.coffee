
###*
# Preload Class
# This class contains storage for audio, video, image and json
# It keeps track of current loaded object, and the total number of objects
# It can serve these preloaded files on the fly.
#
# @class Preload
# @module Framework
# @submodule Framework
# @namespace Gotham
# @constructor
# @example
#     # Examples
#     # Preloading a Image file
#     Gotham.Preload.image("/assets/img/settings_close.png", "settings_close", "image")
#     # Preloading a JSON File
#     Gotham.Preload.json("/assets/json/json.json", "map")
#     # Fetching the JSON file
#     Gotham.Preload.fetch("map", "json")
#     # Fetching the image file
#     Gotham.Preload.fetch("settings_close", "image")
#
###
class Preload

  # Setups the preloader
  # Creating Storage array
  constructor: ->

    ###*
    # The table of image preloading
    # @property db_image {LokiJS}
    # @private
    ###
    @db_image = Gotham.Database.table "preload_images"

    ###*
    # The table of audio preloading
    # @property db_audio {LokiJS}
    # @private
    ###
    @db_audio = Gotham.Database.table "preload_audio"

    ###*
    # The table of data (json) preloading
    # @property db_data {LokiJS}
    # @private
    ###
    @db_data = Gotham.Database.table "preload_data"


    #@db_video = Gotham.Database.createTable "preload_video"

    ###*
    # Callback for when a item is loaded
    # @method onLoad
    ###
    @onLoad = ->

    ###*
    # Callback for when all items are loaded
    # @method onComplete
    ###
    @onComplete = ->

    ###*
    # Number of network items loaded
    # @property _numNetworkLoaded {Integer}
    # @private
    ###
    @_numNetworkLoaded = 0

    ###*
    # Total count for preloaded items
    # @property _totalCount {Integer}
    # @private
    ###
    @_totalCount = 0


  ###*
  # Get total number items subject for preloading
  # @method getTotalCount
  # @private
  # @return {Number}
  ###
  getTotalCount: ->
    return @_totalCount

  ###*
  # Increments the total item count
  # @method incrementTotalCount
  # @private
  ###
  incrementTotalCount: ->
    @_totalCount++

  ###*
  # Get number of items current loaded
  # @method getNumLoaded
  # @private
  # @return {Number} Total of elements currently loaded
  ###
  getNumLoaded: ->
    dbs = [@db_audio, @db_image, @db_data]
    total = @_numNetworkLoaded
    for db in dbs
      total += db.data.length
    return total


  ###*
  # Function for downloading a json file, Runs callback when done
  # @method downloadJSON
  # @param url {String} the url
  # @param callback {Callback} The complete callback
  # @private
  ###
  downloadJSON = (url, callback) ->
    Gotham.Util.Ajax.GET url, (data, response) ->
      callback(data)

  ###*
  # Function for downloading a image, runs callback on end
  # @method downloadJSON
  # @param url {String} the url
  # @param callback {Callback} The complete callback
  # @private
  ###
  downloadImage = (url, callback) ->

    texture = Gotham.Graphics.Texture.fromImage(url)

    texture.addListener "update", ->

      # Unset the Update Listener
      this.addListener "update", ->

      callback(texture)


  ###*
  # Function for downloading a sound elements, runs callback on end
  # @method downloadSound
  # @param url {String} the url
  # @param options {Object} Sound options
  # @param callback {Callback} The complete callback
  # @private
  ###
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

  ###*
  # Callback which fires when preloading is complete
  # @method _onComplete
  # @private
  ###
  _onComplete: () ->
    @onComplete()

  ###*
  # Callback which fires when preloading is complete
  # @method _onLoad
  # @param source {Object} The loaded object
  # @param type {String} The object type (Sound, Image, etc)
  # @param name {String} The object name
  # @private
  ###
  _onLoad: (source, type, name) ->
    percent = (@getNumLoaded() / @getTotalCount() ) * 100.0

    @onLoad(source, type, name, percent)

    # Call complete if 100%
    if Math.round(percent) == 100
      @_onComplete()

  ###*
  # Check for weither preloading is complete or not
  # @method isPreloadComplete
  # @private
  # @return {Boolean} Weither preloading is complete or not
  ###
  isPreloadComplete: () ->
    return (((@._loadedObjects / @._totalObjects ) * 100.0) == 100)

  ###*
  # Function for preloading image
  # @method image
  # @param url {Object} The item to Preload
  # @param name {String} The name of the object
  ###
  image: (url, name) ->
    that = @

    @incrementTotalCount()
    downloadImage url, (image) ->
      that.db_image.insert { name: name, object: image, type: 'image'}
      that._onLoad(image, 'Image', name)

  ###*
  # Function for preloading mp3
  # @method mp3
  # @param url {Object} The item to Preload
  # @param name {String} The name of the object
  # @param options {Object} Options for howler
  ###
  mp3: (url, name, options) ->
    that = @

    @incrementTotalCount()
    downloadSound url, options, (sound) ->
      that.db_audio.insert { name: name, object: sound, type: 'audio'}
      that._onLoad(sound, 'Audio', name)

  ###*
  # Function for preloading json
  # @method json
  # @param url {Object} The item to Preload
  # @param name {String} The name of the object
  ###
  json: (url, name) ->
    that = @

    @incrementTotalCount()
    downloadJSON url, (json) ->
      that.db_data.insert { name: name, object: json, type: 'json'}
      that._onLoad(json,'JSON', name)

  ###*
  # Function for preloading network data
  # @method network
  # @param name {Object} The callback name
  # @param table {Table} The database table
  # @param socket {SocketIO} The connected socket
  ###
  network: (name, table, socket) ->
    that = @

    @incrementTotalCount()
    socket.Socket.emit name
    socket.Socket.on name , (data) ->
      that._numNetworkLoaded = that._numNetworkLoaded + 1

      if typeof data == 'array'
        table.merge data
      else
        table.insert data

      that._onLoad(data, 'Data', name)

  ###*
  # Function for fetching an preloaded item
  # @method fetch
  # @param name {String} Name of the file
  # @param type {String} The type of the file
  # @return {Object} The element retrieved
  ###
  fetch: (name, type) ->
    db = @getDatabase(type)
    return db.findOne(name: name).object

  ###*
  # Function which returns the storage for the given type
  # @method getDatabase
  # @param type {String} The type of the storage
  # @return {Database} The database retrieved
  ###
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