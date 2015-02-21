class Preload

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
  

  onLoad: (callback) ->
    @_onLoad = callback

  onComplete: (callback) ->
    @_onComplete = callback

  isPreloadComplete: () ->
    return (((@._loadedObjects / @._totalObjects ) * 100.0) == 100)


  image: (item, name, options) -> 
    @_totalObjects++
    @getType("image")[name] = @imageFromUrl(item, name)

  mp3: (item, name, options) -> 
    @_totalObjects++
    @getType("audio")[name] = @soundFromUrl(item, name, options)

  json: (item, name) ->
    @_totalObjects++
    @getType("json")[name] = @jsonFromUrl(item, name)
    


  fetch: (name, type) ->
    
    # If no type is defined, attempt to find. (Give warning)
    if not type?
      console.log "Optimization potential detected: Define Type"
      return Gotham.Util.SearchTools.FindKey(@storage, name)

    return @getType(type)[name]


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