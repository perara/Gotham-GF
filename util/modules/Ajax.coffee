

class Ajax

  @getXmlDoc: ->
    xmlDoc = null

    if window.XMLHttpRequest
      xmlDoc = new XMLHttpRequest()
    else
      xmlDoc = new ActiveXObject("Microsoft.XMLHTTP")
    return xmlDoc;


  @GET: (url, callback) ->
    xmlDoc = Ajax.getXmlDoc()
    xmlDoc.open 'GET', url, true 

    xmlDoc.onreadystatechange = ->
      if xmlDoc.readyState == 4 && xmlDoc.status == 200
        callback JSON.parse(xmlDoc.response), xmlDoc
    xmlDoc.send()




module.exports = Ajax