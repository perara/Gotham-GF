
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
    @_Gotham = Gotham
    @_totalObjects = 0
    @_loadedObjects = 0
    @_onLoad = ->
    @_onComplete = ->
  
    # Storage container
    @storage = 
      audio: []
      video: []
      image: []
      json: []

    # Private Members
    @jsonFromUrl = (url, name) ->
      that = @
      storage = @storage
      Gotham.Util.Ajax.GET url, (data, response) ->
        storage.json[name] = data
  
        that._loadedObjects++
        that._onLoad(@src, @_name, (that._loadedObjects / that._totalObjects ) * 100.0)
        if that.isPreloadComplete()
          that._onComplete()
      
      
      

    @imageFromUrl = (url, name) ->
      that = @

      texture = Gotham.Graphics.Texture.fromImage(url)
      texture._name = name
      texture.addEventListener "update", ->

        # Unset the Update Listener
        this.addEventListener "update", ->

        # Increment Loaded objects
        that._loadedObjects++

        # URL, Name, Percent
        that._onLoad(@src, @_name, (that._loadedObjects / that._totalObjects ) * 100.0)

        # Check if preload is complete, call onComplete if true
        if that.isPreloadComplete() 
          that._onComplete()
    
    @soundFromUrl = (item, name, options) ->
      that = @

      # HowlerJS Parameters
      howlParameters =   
        urls: [item]
        onload : ->
          that._loadedObjects++
          that._onLoad(@_src, @_name, (that._loadedObjects / that._totalObjects ) * 100.0)
          if that.isPreloadComplete() 
            that._onComplete()
    
      # If Option is set, merge with Howler.js options
      if options?
        howlParameters.merge(options)

      # Load the Sound
      _howlerSound = new Howl(howlParameters)

      sound = new Gotham.Sound(_howlerSound)
      sound._name = name

      return sound
  

  # Callback which fires when an object is being loaded
  #
  # @param [Callback] callback the callback which are returned
  onLoad: (callback) ->
    @_onLoad = callback

  # Callback which fires when preloading is complete
  #
  # @param [Callback] callback the callback which are returned
  onComplete: (callback) ->
    @_onComplete = callback


  #
  # Check for weither preloading is complete or not
  #
  isPreloadComplete: () ->
    return (((@._loadedObjects / @._totalObjects ) * 100.0) == 100)


  # Function for preloading image
  #
  # @param [Object] item The item to Preload
  # @param [String] name The name of the object
  image: (item, name) ->
    @_totalObjects++
    @getType("image")[name] = @imageFromUrl(item, name)

  # Function for preloading mp3
  #
  # @param [Object] item The item to Preload
  # @param [String] name The name of the object
  # @param [Object] options Options for howler
  mp3: (item, name, options) -> 
    @_totalObjects++
    @getType("audio")[name] = @soundFromUrl(item, name, options)


  # Function for preloading json
  #
  # @param [Object] item The item to Preload
  # @param [String] name The name of the object
  json: (item, name) ->
    @_totalObjects++
    @getType("json")[name] = @jsonFromUrl(item, name)


  # Function for fetching an preloaded item
  # @param [String] name Name of the file
  # @param [String] type The type of the file
  fetch: (name, type) ->
    
    # If no type is defined, attempt to find. (Give warning)
    if not type?
      console.log "Optimization potential detected: Define Type"
      return Gotham.Util.SearchTools.FindKey(@storage, name)

    return @getType(type)[name]

  # Function which returns the storage for the given type
  # @param [String] type The type of the storage
  getType: (type) ->
    switch type
      when "image"
        return @storage.image
      when "audio" 
        return @storage.audio
      when "json"
        return @storage.json
      else
        throw new Error "Format Not Supported, Preload"
    return @storage
  

module.exports = Preload