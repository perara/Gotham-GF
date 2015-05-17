

###*
# AJAX Class to retrieve and post without the use of JQUERY
# IT does only rely on the normal javascript library
# @class Ajax
# @module Framework
# @submodule Framework.Util
# @namespace Gotham.Util
###
class Ajax

  ###*
  # Fetches the XML Document from  the request,
  # It can also handle Internet Explorer via ActiveX
  # @method getXmlDoc
  # @static
  ###
  @getXmlDoc: ->
    xmlDoc = null

    if window.XMLHttpRequest
      xmlDoc = new XMLHttpRequest()
    else
      xmlDoc = new ActiveXObject("Microsoft.XMLHTTP")
    return xmlDoc;

  ###*
  # GET request to URL, which then returns the data to the callback
  # @method GET
  # @param url {String} The url of the request
  # @param callback {Callback} The resulting success callback of the request
  # @static
  ###
  @GET: (url, callback) ->
    xmlDoc = Ajax.getXmlDoc()
    xmlDoc.open 'GET', url, true 

    xmlDoc.onreadystatechange = ->
      if xmlDoc.readyState == 4 && xmlDoc.status == 200
        callback JSON.parse(xmlDoc.response), xmlDoc
    xmlDoc.send()


module.exports = Ajax