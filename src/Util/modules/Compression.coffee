


class Compression

  GZIP:
    decompress: (bytes)->
      gunzip = new Zlib.Zlib.Gunzip atob(bytes)
      plain = gunzip.decompress();
      return plain





module.exports = new Compression()