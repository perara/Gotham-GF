﻿

# The tween class of Gotham
# This class animates objects of any format
# It features to reach deep proprerties in an object
# @example How to use
#    # Start
#    tweenTo =
#      scale:
#        x: 2
#        y: 2
#      rotation: 0.1
#
#    # End
#    tweenBack =
#      scale:
#        x: 1
#        y: 1
#      rotation: -0.1
#
#    tween = new Tween object
#    tween.startDelay 500
#    tween.repeat(Infinity)
#    tween.easing Tween.Easing.Circular.InOut
#    tween.to tweenTo, 1500
#    tween.to tweenBack, 1500
#    tween.onStart ->
#      console.log @ + " started!"
#    tween.start()
class Tween

  # @property [Array[Tween]] List of current/ ongoing Tweens
  @_objects = []

  # @property [Array[Tween]] List of old/completed tweens
  @_oldObjects = []

  # @property [Long] Current runtime time, Retreived from GameLoop's update()
  @_currentTime = 0


  # Initializes the Tween object
  # Does however not start the tween
  # Adds "this" tween to the Static tween array
  constructor: (object) ->


    @_object = object
    @_properties = []
    @_tweenChain = []

    @_startDelay = 0
    @_easing = Tween.Easing.Linear.None
    @_interpolation = Tween.Interpolation.Linear

    # Callbacks
    @_onUpdate = null
    @_onComplete = null
    @_onStart = null

    # States
    @_started = false
    @_paused = false
    @_complete = false

    @_remainingRuns = 0 # Remaining runs the tweet should do (default: 1 time) , Modified by .repeat(xx)



    Tween._objects.push(@)

  # Retrieve "this" tween's TweenChain
  # @return [Array[Object]] The tween Chain
  getTweenChain: ->
    return @_tweenChain



############################################
##
## Events Like:
## * Start
## * Stop
## * Pause
##
############################################

  # Starts the tween calling the _onStart callback
  start: ->
    @_onStart(@_object)

  # Stops the tween calling the _onStop callback
  # TODO - Implement
  stop: ->

  # Pauses the tween calling the _onPause callback
  # TODO - Implement
  pause: ->




############################################
##
## Function which manipulate tween behaviour
##
############################################

  # Set Initial Start delay of the tween
  # @param [Long] time Time in milliseconds
  startDelay: (time) ->
    @_startDelay = time

  # Set the easing algorithm for the tween
  # @param [Tween.Easing] easing The easing algorithm
  # @example How to use
  #   obj.easing(Tween.Easing.Linear.None)
  #
  # The easing algorithms are found in the Tween.Easing object.
  easing: (easing) ->
    @_easing = easing

  # Add tween action to the tween chain
  # @param [Object] property The "goal" property of the tween (Where you want the target object to end up)
  # @param [Long] duration Duration of the tween from start --> end (In milliseconds)
  to: (property, duration) ->

    path =
      "property" : property # The Property to translate to
      "duration" : duration # Duration of the tween event
      "startTime" : null # Set when starting tween .start()
      "endTime" : null # Set when starting tween .start()
      "inited" : false
      "type" : "translate" # The type of the tweenEvent

    # Add to the tweenChain
    @_tweenChain.push(path)

    # Add properties to the property list
    for prop in Tween.flattenKeys property
      @_properties.push(prop)

  # Add a delay between two tween goto's
  # @param [Long] time Delay in Milliseconds
  delay: (time) ->

    if typeof time isnt 'number'
      throw new Error "Time was not a number!"

    delayItem =
      "duration" : time
      "startTime" : null # Set when starting tween .start()
      "endTime" : null # Set when starting tween .start()
      "type" : "delay"

    @_tweenChain.push(delayItem)

  # How many times you want to repeat the Tween
  # To repeat "forever", use Infinity
  # @param [Integer] num Number of times to repeat
  repeat: (num) ->
    @_remainingRuns = num


  # TODO - Needs Documentation ??!?
  # @param [Object] property The property
  addCutsomProperty: (property) ->
    @_properties.push(property)

  # TODO - Needs Documentation ??!?
  # @param [Array[Object]] property The properties
  addCutsomProperties: (properties) ->
    for property in properties
      @addProperty(property)



############################################
##
## Callbacks
##
############################################

  # The onUpdate callback
  # Is called when the tween is updated
  # @param [Callback] callback The onUpdate callback
  onUpdate: (callback) ->
    @_onUpdate = callback

  # The onComplete callback
  # Is called when the tween is completed
  # @param [Callback] callback The onComplete callback
  onComplete: (callback) ->
    @_onComplete = callback

  # The onStart callback
  # Is called when the tween is started
  # @param [Callback] callback The onStart callback
  onStart: (callback) ->
    @_onStart = callback

  # Update loop of the tween engine ensures that tweening actually happens
  # IT is called from GameLoop.update()
  # @param [Long] Render runtime in milliseconds
  @update: (time) ->
    Gotham.Tween._currentTime = time

    objects = Tween._objects

    # Check if Empty for objects
    if objects.length > 0

      for tweenObject in objects

        # TODO , Any consequences in having the tweenObject going undefined?
        if tweenObject is undefined
          continue

        # Pass if not yet at start time
        if time < tweenObject._startTime
          continue

        # Skip if tween complete TODO - Should be in separate list
        if tweenObject._complete
          continue


        if tweenObject._tweenChain.length > 0


          tween = tweenObject._tweenChain[0]


          # Set tweet start and entime if not inited
          if !tween.inited
            tween["startTime"] =  time
            tween["endTime"] = tween["startTime"] + tween["duration"]

            tween["startPos"] = {}
            for property in tweenObject._properties
              key = property.split('.')[0]
              value = tweenObject._object[key]
              tween["startPos"][key] = value

            tween.inited = true




          # Remove if old tweenItem
          if time > tween.endTime

            # Remove it from the front
            tweenObject._tweenChain.shift()

            # Decremt remaining runs and readd it to the chain if having remaining runs
            if tweenObject._remainingRuns-- > 0

              #console.log("Requeue")
              # Requeue it
              lastItem = tweenObject._tweenChain[tweenObject._tweenChain.length - 1]
              tween["startTime"] = null
              tween["endTime"] = null
              tween["inited"] = false
              tweenObject._tweenChain.push(tween)


          # Continue if its a delay tween
          if tween.type is "delay"
            continue



          # Elapsed Time of the tween
          startTime = tween.startTime
          endTime = tween.endTime

          # Start and end of the tween
          start = tween.startPos
          end = tween.property


          # The elapsed time of the tween
          elapsed = (time - startTime) / tween.duration
          elapsed = if elapsed > 1 then  1 else elapsed

          # Calculate the new multiplication value
          value = tweenObject._easing elapsed

          # TODO , this is heavily shitty.
          for prop in tweenObject._properties
            eval("tweenObject._object." + prop + " = start." + prop + " + ( end."+prop+" - start."+prop+" ) * value")

            current = eval("tweenObject._object." + prop)
            target = eval("end."+prop)

            if (current - target) == 0
              tween["endTime"] = time - 1




        else
          tweenObject._complete = true
          Tween._objects.remove(tweenObject)
          Tween._oldObjects.push(tweenObject)


  # Function for finding properties recursively in an Object
  # @param [Object] obj Start/Parent Node
  # @param [String] delimiter The Delimeter of the result. Default: "."
  # @param [Integer] max_depth Max Depth of the recursion
  # @return [Array] Array with the resulting properties
  @flattenKeys = (obj, delimiter, max_depth) ->
    delimiter = delimiter or '.'
    max_depth = max_depth or 2

    # Recurse function
    recurse = (obj, path, result, level) ->

      if level > max_depth
        return

      level++
      if typeof obj == 'object' and obj
        Object.keys(obj).forEach (key) ->
            path.push key
            recurse obj[key], path, result, level
            path.pop()
      else
        result.push path.join(delimiter)
      return result

    recurse obj, [], [], 0

  # Easing Algorithms
  @Easing =
    Linear: None: (k) ->
      k
    Quadratic:
      In: (k) ->
        k * k
      Out: (k) ->
        k * (2 - k)
      InOut: (k) ->
        if (k *= 2) < 1
          return 0.5 * k * k
        -0.5 * (--k * (k - 2) - 1)
    Cubic:
      In: (k) ->
        k * k * k
      Out: (k) ->
        --k * k * k + 1
      InOut: (k) ->
        if (k *= 2) < 1
          return 0.5 * k * k * k
        0.5 * ((k -= 2) * k * k + 2)
    Quartic:
      In: (k) ->
        k * k * k * k
      Out: (k) ->
        1 - --k * k * k * k
      InOut: (k) ->
        if (k *= 2) < 1
          return 0.5 * k * k * k * k
        -0.5 * ((k -= 2) * k * k * k - 2)
    Quintic:
      In: (k) ->
        k * k * k * k * k
      Out: (k) ->
        --k * k * k * k * k + 1
      InOut: (k) ->
        if (k *= 2) < 1
          return 0.5 * k * k * k * k * k
        0.5 * ((k -= 2) * k * k * k * k + 2)
    Sinusoidal:
      In: (k) ->
        1 - Math.cos(k * Math.PI / 2)
      Out: (k) ->
        Math.sin k * Math.PI / 2
      InOut: (k) ->
        0.5 * (1 - Math.cos(Math.PI * k))
    Exponential:
      In: (k) ->
        if k == 0 then 0 else 1024 ** (k - 1)
      Out: (k) ->
        if k == 1 then 1 else 1 - 2 ** (-10 * k)
      InOut: (k) ->
        if k == 0
          return 0
        if k == 1
          return 1
        if (k *= 2) < 1
          return 0.5 * 1024 ** (k - 1)
        0.5 * (-2 ** (-10 * (k - 1)) + 2)
    Circular:
      In: (k) ->
        1 - Math.sqrt(1 - k * k)
      Out: (k) ->
        Math.sqrt 1 - --k * k
      InOut: (k) ->
        if (k *= 2) < 1
          return -0.5 * (Math.sqrt(1 - k * k) - 1)
        0.5 * (Math.sqrt(1 - (k -= 2) * k) + 1)
    Elastic:
      In: (k) ->
        s = undefined
        a = 0.1
        p = 0.4
        if k == 0
          return 0
        if k == 1
          return 1
        if !a or a < 1
          a = 1
          s = p / 4
        else
          s = p * Math.asin(1 / a) / 2 * Math.PI
        -(a * 2 ** (10 * (k -= 1)) * Math.sin((k - s) * 2 * Math.PI / p))
      Out: (k) ->
        s = undefined
        a = 0.1
        p = 0.4
        if k == 0
          return 0
        if k == 1
          return 1
        if !a or a < 1
          a = 1
          s = p / 4
        else
          s = p * Math.asin(1 / a) / 2 * Math.PI
        a * 2 ** (-10 * k) * Math.sin((k - s) * 2 * Math.PI / p) + 1
      InOut: (k) ->
        s = undefined
        a = 0.1
        p = 0.4
        if k == 0
          return 0
        if k == 1
          return 1
        if !a or a < 1
          a = 1
          s = p / 4
        else
          s = p * Math.asin(1 / a) / 2 * Math.PI
        if (k *= 2) < 1
          return -0.5 * a * 2 ** (10 * (k -= 1)) * Math.sin((k - s) * 2 * Math.PI / p)
        a * 2 ** (-10 * (k -= 1)) * Math.sin((k - s) * 2 * Math.PI / p) * 0.5 + 1
    Back:
      In: (k) ->
        s = 1.70158
        k * k * ((s + 1) * k - s)
      Out: (k) ->
        s = 1.70158
        --k * k * ((s + 1) * k + s) + 1
      InOut: (k) ->
        s = 1.70158 * 1.525
        if (k *= 2) < 1
          return 0.5 * k * k * ((s + 1) * k - s)
        0.5 * ((k -= 2) * k * ((s + 1) * k + s) + 2)
    Bounce:
      In: (k) ->
        1 - Tween.Easing.Bounce.Out(1 - k)
      Out: (k) ->
        if k < 1 / 2.75
          7.5625 * k * k
        else if k < 2 / 2.75
          7.5625 * (k -= 1.5 / 2.75) * k + 0.75
        else if k < 2.5 / 2.75
          7.5625 * (k -= 2.25 / 2.75) * k + 0.9375
        else
          7.5625 * (k -= 2.625 / 2.75) * k + 0.984375
      InOut: (k) ->
        if k < 0.5
          return Tween.Easing.Bounce.In(k * 2) * 0.5
        Tween.Easing.Bounce.Out(k * 2 - 1) * 0.5 + 0.5

  @Interpolation =
    Linear: (v, k) ->
      m = v.length - 1
      f = m * k
      i = Math.floor(f)
      fn = Tween.Interpolation.Utils.Linear
      if k < 0
        return fn(v[0], v[1], f)
      if k > 1
        return fn(v[m], v[m - 1], m - f)
      fn v[i], v[if i + 1 > m then m else i + 1], f - i
    Bezier: (v, k) ->
      b = 0
      n = v.length - 1
      pw = Math.pow
      bn = Tween.Interpolation.Utils.Bernstein
      i = undefined
      i = 0
      while i <= n
        b += pw(1 - k, n - i) * pw(k, i) * v[i] * bn(n, i)
        i++
      b
    CatmullRom: (v, k) ->
      m = v.length - 1
      f = m * k
      i = Math.floor(f)
      fn = Tween.Interpolation.Utils.CatmullRom
      if v[0] == v[m]
        if k < 0
          i = Math.floor(f = m * (1 + k))
        fn v[(i - 1 + m) % m], v[i], v[(i + 1) % m], v[(i + 2) % m], f - i
      else
        if k < 0
          return v[0] - (fn(v[0], v[0], v[1], v[1], -f) - v[0])
        if k > 1
          return v[m] - (fn(v[m], v[m], v[m - 1], v[m - 1], f - m) - v[m])
        fn v[if i then i - 1 else 0], v[i], v[if m < i + 1 then m else i + 1], v[if m < i + 2 then m else i + 2], f - i
    Utils:
      Linear: (p0, p1, t) ->
        (p1 - p0) * t + p0
      Bernstein: (n, i) ->
        fc = Tween.Interpolation.Utils.Factorial
        fc(n) / fc(i) / fc(n - i)
      Factorial: do ->
        a = [ 1 ]
        (n) ->
          s = 1
          i = undefined
          if a[n]
            return a[n]
          i = n
          while i > 1
            s *= i
            i--
          a[n] = s
      CatmullRom: (p0, p1, p2, p3, t) ->
        v0 = (p2 - p0) * 0.5
        v1 = (p3 - p1) * 0.5
        t2 = t * t
        t3 = t * t2
        (2 * p1 - 2 * p2 + v0 + v1) * t3 + (-3 * p1 + 3 * p2 - 2 * v0 - v1) * t2 + v0 * t + p1





















module.exports = Tween