

###*
# Utils for compressing
# @class Compression
# @module Framework
# @submodule Framework.Util
# @namespace Gotham.Util
###
class Compression

  ###*
  # GZIP Compression
  # @property {Object} GZIP
  # @property {Function} GZIP.decompress
  # @static
  ###
  GZIP:
    decompress: (bytes)->
      gunzip = new Zlib.Zlib.Gunzip atob(bytes)
      plain = gunzip.decompress();
      return plain





module.exports = new Compression()