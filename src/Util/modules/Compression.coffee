

###*
# Utils for compressing
# @class Compression
# @module Framework
# @submodule Framework.Util
# @namespace Gotham.Util
###
class Compression

  GZIP:
    decompress: (bytes)->
      gunzip = new Zlib.Zlib.Gunzip atob(bytes)
      plain = gunzip.decompress();
      return plain





module.exports = new Compression()