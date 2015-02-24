NetworkInstance = require './Network/NetworkInstance.coffee'


class Network
  @NetworkInstance = NetworkInstance

  constructor: (host, port) ->

    @_isConnected = false
    @connection = null

    if not port ?
      @port = 8080
    else
      @port = port

  connect: (onHubCallback)->
    that = @
    $.getScript "http://hybel.keel.no:8091/gotham/hubs", (data, textStatus, jqxhr) ->
      that.connection = $.connection
      console.log "SignalR: Hub information received..."

      onHubCallback ->
        $.connection.hub.url = 'http://hybel.keel.no:8091/gotham/'
        $.connection.hub.start().done (e) ->
          console.log "SignalR: Connected to " + e.url + " with ID: " + e.id
          for item in Object.keys(e.proxies)
            if typeof e.proxies[item].onConnect == 'function'
              e.proxies[item].onConnect(e.proxies[item])









module.exports = Network