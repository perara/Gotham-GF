

String.prototype.contains = (it) ->
  return this.indexOf(it) != -1;

String.prototype.startsWith = (str) ->
  return this.slice(0, str.length) == str;

String.prototype.endsWith = (str) ->
  return this.slice(-str.length) == str;

String.prototype.camelCase = () ->
  return this.replace(/(?:^\w|[A-Z]|\b\w)/g, (letter, index) ->
    return if index == 0 then letter.toLowerCase() else letter.toUpperCase()
  ).replace(/\s+/g, '')
