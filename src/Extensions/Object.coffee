###
# object.watch polyfill
#
# 2012-04-03
#
# By Eli Grey, http://eligrey.com
# Public Domain.
# NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
###

# object.watch
if !Object::watch
  Object.defineProperty Object.prototype, 'watch',
    enumerable: false
    configurable: true
    writable: false
    value: (prop, handler) ->
      oldval = @[prop]
      newval = oldval

      getter = ->
        newval

      setter = (val) ->
        oldval = newval
        newval = handler.call(this, prop, oldval, val)

      if delete @[prop]
        # can't watch constants
        Object.defineProperty this, prop,
          get: getter
          set: setter
          enumerable: true
          configurable: true
      return


# object.unwatch
if !Object::unwatch
  Object.defineProperty Object.prototype, 'unwatch',
    enumerable: false
    configurable: true
    writable: false
    value: (prop) ->
      val = @[prop]
      delete @[prop]
      # remove accessors
      @[prop] = val
      return