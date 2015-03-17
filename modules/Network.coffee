

# Network Class, Build atop of SignalR
class Network


  # Contstructor of the network class
  # Sets up required info to connect to server
  #
  # @param [String] host Hostname of the server
  # @param [Integer] port Port of the server
  # @param [Domain] domain SignalR domain (For example: ws://test.com/domain
  constructor: (host, port, domain) ->
    @host = host
    @port = port
    @domain = domain

    @_isConnected = false
    @connection = null

    if not port ?
      @port = 8080
    else
      @port = port

  # Connects to the host returning onHubCallback when connected
  #
  # @param [Callback] onHubCallback this callback is ran  when the hub info is retrieved. It then connects to the host
  connect: (onHubCallback)->
    that = @
    url = "http://" + @host + ":" + @port + "/" + @domain

    $.getScript url + "/hubs", (data, textStatus, jqxhr) ->
      that.connection = $.connection
      console.log "SignalR: Hub information received..."

      onHubCallback ->
        $.connection.hub.url = url
        $.connection.hub.start().done (e) ->
          console.log "SignalR: Connected to " + e.url + " with ID: " + e.id
          for item in Object.keys(e.proxies)
            if typeof e.proxies[item].onConnect == 'function'
              e.proxies[item].onConnect(e.proxies[item])



module.exports = Network