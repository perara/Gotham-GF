(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
// creates a global "addWheelListener" method
//Feature	    Chrome	Firefox (Gecko)	Internet Explorer	Opera	        Safari
//Basic support	  31	  17.0 (17.0)	   9.0[1]	      Not supported	   7.0.5
// example: addWheelListener( elem, function( e ) { console.log( e.deltaY ); e.preventDefault(); } );

module.exports = addWheelListener;

var prefix = "", _addEventListener, onwheel, support;

// detect event model
if ( window.addEventListener ) {
    _addEventListener = "addEventListener";
} else {
    _addEventListener = "attachEvent";
    prefix = "on";
}

// detect available wheel event
support = "onwheel" in document.createElement("div") ? "wheel" : // Modern browsers support "wheel"
    document.onmousewheel !== undefined ? "mousewheel" : // Webkit and IE support at least "mousewheel"
        "DOMMouseScroll"; // let's assume that remaining browsers are older Firefox

function addWheelListener( elem, callback, useCapture ) {
    _addWheelListener( elem, support, callback, useCapture );

    // handle MozMousePixelScroll in older Firefox
    if( support == "DOMMouseScroll" ) {
        _addWheelListener( elem, "MozMousePixelScroll", callback, useCapture );
    }
};

function _addWheelListener( elem, eventName, callback, useCapture ) {
    elem[ _addEventListener ]( prefix + eventName, support == "wheel" ? callback : function( originalEvent ) {
        !originalEvent && ( originalEvent = window.event );

        // create a normalized event object
        var event = {
            // keep a ref to the original event object
            originalEvent: originalEvent,
            target: originalEvent.target || originalEvent.srcElement,
            type: "wheel",
            deltaMode: originalEvent.type == "MozMousePixelScroll" ? 0 : 1,
            deltaX: 0,
            deltaZ: 0,
            preventDefault: function() {
                originalEvent.preventDefault ?
                    originalEvent.preventDefault() :
                    originalEvent.returnValue = false;
            }
        };

        // calculate deltaY (and deltaX) according to the event
        if ( support == "mousewheel" ) {
            event.deltaY = - 1/40 * originalEvent.wheelDelta;
            // Webkit also support wheelDeltaX
            originalEvent.wheelDeltaX && ( event.deltaX = - 1/40 * originalEvent.wheelDeltaX );
        } else {
            event.deltaY = originalEvent.detail;
        }

        // it's time to fire the callback
        return callback( event );

    }, useCapture || false );
}
},{}],2:[function(require,module,exports){
Array.prototype.remove = function() {
  var L, a, ax, what;
  what = void 0;
  a = arguments;
  L = a.length;
  ax = void 0;
  while (L && this.length) {
    what = a[--L];
    while ((ax = this.indexOf(what)) !== -1) {
      this.splice(ax, 1);
    }
  }
  return this;
};

Array.prototype.last = function() {
  return this[this.length - 1];
};



},{}],3:[function(require,module,exports){
PIXI.DisplayObjectContainer.prototype.onWheelScroll = function() {};

PIXI.DisplayObjectContainer.prototype.bringToFront = function() {
  var parent;
  if (this.parent) {
    parent = this.parent;
    parent.removeChild(this);
    return parent.addChild(this);
  }
};

PIXI.DisplayObjectContainer.prototype.onInteractiveChange = null;

PIXI.DisplayObjectContainer.prototype.setInteractive = function(state) {
  var item, queue, results1;
  if (this.onInteractiveChange) {
    this.onInteractiveChange(state);
  }
  queue = [];
  queue.push(this);
  results1 = [];
  while (queue.length > 0) {
    item = queue.pop();
    queue.push.apply(queue, item.children);
    item.interactive = state;
    if (!state) {
      item.__click = item.click;
      item.__mousedown = item.mousedown;
      item.__mouseup = item.mouseup;
      item.click = null;
      item.mousedown = null;
      results1.push(item.mouseup = null);
    } else {
      item.click = item.__click;
      item.mousedown = item.__mousedown;
      item.mouseup = item.__mouseup;
      item.__click = null;
      item.__mousedown = null;
      results1.push(item.__mouseup = null);
    }
  }
  return results1;
};

PIXI.DisplayObjectContainer.prototype.addChildArray = function(array) {
  var child, i, len, results1;
  results1 = [];
  for (i = 0, len = array.length; i < len; i++) {
    child = array[i];
    results1.push(this.addChild(child));
  }
  return results1;
};

PIXI.DisplayObjectContainer.prototype.setPanning = function(callback) {
  var isDragging, parent, prevX, prevY, that;
  that = this;
  parent = that.parent;
  parent.interactive = true;
  isDragging = false;
  prevX = void 0;
  prevY = void 0;
  that.offset = {
    x: 0,
    y: 0
  };
  that.diff = {
    x: 0,
    y: 0
  };
  parent.mousedown = function(moveData) {
    var pos;
    pos = moveData.global;
    prevX = pos.x;
    prevY = pos.y;
    return isDragging = true;
  };
  parent.mouseup = function(moveDate) {
    return isDragging = false;
  };
  parent.mouseout = function(moveData) {
    return isDragging = false;
  };
  return parent.mousemove = function(moveData) {
    var newPosition, pos, results;
    if (!isDragging) {
      return;
    }
    pos = moveData.global;
    that.diff.x = pos.x - prevX;
    that.diff.y = pos.y - prevY;
    newPosition = {
      x: that.position.x + that.diff.x,
      y: that.position.y + that.diff.y
    };
    results = callback(newPosition);
    if (results.x) {
      that.position.x = newPosition.x;
      prevX = pos.x;
    }
    if (results.y) {
      that.position.y = newPosition.y;
      return prevY = pos.y;
    }
  };
};

PIXI.DisplayObjectContainer.prototype.onMouseDown = function() {};

PIXI.DisplayObjectContainer.prototype.onMouseUp = function() {};

PIXI.DisplayObjectContainer.prototype.onMove = function() {};

PIXI.DisplayObjectContainer.prototype.movable = function() {
  if (!this.interactive) {
    this.interactive = true;
  }
  this.mousedown = this.touchstart = function(data) {
    this.data = data;
    this.dragging = true;
    this._sx = this.data.getLocalPosition(this).x * this.scale.x;
    this._sy = this.data.getLocalPosition(this).y * this.scale.y;
    return this.onMouseDown(data);
  };
  this.mouseup = this.mouseupoutside = this.touchend = this.touchendoutside = function(data) {
    this.alpha = 1;
    this.dragging = false;
    this.data = null;
    return this.onMouseUp(data);
  };
  return this.mousemove = this.touchmove = function(data) {
    var newPosition;
    if (this.dragging) {
      newPosition = this.data.getLocalPosition(this.parent);
      this.position.x = newPosition.x - this._sx;
      this.position.y = newPosition.y - this._sy;
      return this.onMove(data);
    }
  };
};



},{}],4:[function(require,module,exports){
/**
 * Created by PerArne on 16.04.2015.
 */
/**
 * @method rebuildInteractiveGraph
 * @private
 */
PIXI.InteractionManager.prototype.rebuildInteractiveGraph = function()
{
    this.dirty = false;

    var len = this.interactiveItems.length;

    for (var i = 0; i < len; i++) {
        this.interactiveItems[i].interactiveChildren = false;
    }

    this.interactiveItems = [];

    // Go through and collect all the objects that are interactive..
    this.collectInteractiveSprite(this.stage, this.stage);

    if (this.stage.interactive)
    {
        this.interactiveItems.push(this.stage);
    }
};

PIXI.InteractionData.prototype.stopped = false;

PIXI.InteractionData.prototype.stopPropagation = function() {
    this.stopped = true;
};

PIXI.InteractionData.prototype.startPropagation = function() {
    this.stopped = false;
};

/**
 * Is called when the mouse moves across the renderer element
 *
 * @method onMouseMove
 * @param event {Event} The DOM event of the mouse moving
 * @private
 */
PIXI.InteractionManager.prototype.onMouseMove = function(event)
{
    if (this.dirty)
    {
        this.rebuildInteractiveGraph();
    }

    this.mouse.originalEvent = event;

    // TODO optimize by not check EVERY TIME! maybe half as often? //
    var rect = this.interactionDOMElement.getBoundingClientRect();

    this.mouse.global.x = (event.clientX - rect.left) * (this.target.width / rect.width) / this.resolution;
    this.mouse.global.y = (event.clientY - rect.top) * ( this.target.height / rect.height) / this.resolution;

    var length = this.interactiveItems.length;

    for (var i = 0; i < length; i++)
    {
        var item = this.interactiveItems[i];

        // Call the function!
        if (item.mousemove)
        {
            item.mousemove(this.mouse);

            if (this.mouse.stopped) break;
        }
    }
};

/**
 * Is called when the mouse button is pressed down on the renderer element
 *
 * @method onMouseDown
 * @param event {Event} The DOM event of a mouse button being pressed down
 * @private
 */
PIXI.InteractionManager.prototype.onMouseDown = function(event)
{
    if (this.dirty)
    {
        this.rebuildInteractiveGraph();
    }

    this.mouse.originalEvent = event;

    if (PIXI.AUTO_PREVENT_DEFAULT)
    {
        this.mouse.originalEvent.preventDefault();
    }

    // loop through interaction tree...
    // hit test each item! ->
    // get interactive items under point??
    //stage.__i
    var length = this.interactiveItems.length;

    var e = this.mouse.originalEvent;
    var isRightButton = e.button === 2 || e.which === 3;
    var downFunction = isRightButton ? 'rightdown' : 'mousedown';
    var clickFunction = isRightButton ? 'rightclick' : 'click';
    var buttonIsDown = isRightButton ? '__rightIsDown' : '__mouseIsDown';
    var isDown = isRightButton ? '__isRightDown' : '__isDown';

    // while
    // hit test
    for (var i = 0; i < length; i++)
    {
        var item = this.interactiveItems[i];

        if (item[downFunction] || item[clickFunction])
        {
            item[buttonIsDown] = true;
            item.__hit = this.hitTest(item, this.mouse);

            if (item.__hit)
            {
                //call the function!
                if (item[downFunction])
                {
                    item[downFunction](this.mouse);
                }
                item[isDown] = true;

                // just the one!
                if (!item.interactiveChildren) break;

                if (this.mouse.stopped) break;
            }
        }
    }
};

/**
 * Is called when the mouse is moved out of the renderer element
 *
 * @method onMouseOut
 * @param event {Event} The DOM event of a mouse being moved out
 * @private
 */
PIXI.InteractionManager.prototype.onMouseOut = function(event)
{
    if (this.dirty)
    {
        this.rebuildInteractiveGraph();
    }

    this.mouse.originalEvent = event;

    var length = this.interactiveItems.length;

    this.interactionDOMElement.style.cursor = 'inherit';

    for (var i = 0; i < length; i++)
    {
        var item = this.interactiveItems[i];
        if (item.__isOver)
        {
            this.mouse.target = item;
            if (item.mouseout)
            {
                item.mouseout(this.mouse);

                if (this.mouse.stopped) break;
            }
            item.__isOver = false;
        }
    }

    this.mouseOut = true;

    // move the mouse to an impossible position
    this.mouse.global.x = -10000;
    this.mouse.global.y = -10000;
};

/**
 * Is called when the mouse button is released on the renderer element
 *
 * @method onMouseUp
 * @param event {Event} The DOM event of a mouse button being released
 * @private
 */
PIXI.InteractionManager.prototype.onMouseUp = function(event)
{
    if (this.dirty)
    {
        this.rebuildInteractiveGraph();
    }

    this.mouse.originalEvent = event;

    var length = this.interactiveItems.length;
    var up = false;

    var e = this.mouse.originalEvent;
    var isRightButton = e.button === 2 || e.which === 3;

    var upFunction = isRightButton ? 'rightup' : 'mouseup';
    var clickFunction = isRightButton ? 'rightclick' : 'click';
    var upOutsideFunction = isRightButton ? 'rightupoutside' : 'mouseupoutside';
    var isDown = isRightButton ? '__isRightDown' : '__isDown';

    for (var i = 0; i < length; i++)
    {
        var item = this.interactiveItems[i];

        if (item[clickFunction] || item[upFunction] || item[upOutsideFunction])
        {
            item.__hit = this.hitTest(item, this.mouse);

            if (item.__hit && !up)
            {
                //call the function!
                if (item[upFunction])
                {
                    item[upFunction](this.mouse);
                }
                if (item[isDown])
                {
                    if (item[clickFunction])
                    {
                        item[clickFunction](this.mouse);
                    }
                }

                if (!item.interactiveChildren)
                {
                    up = true;
                }
            }
            else
            {
                if (item[isDown])
                {
                    if (item[upOutsideFunction]) item[upOutsideFunction](this.mouse);
                }
            }

            item[isDown] = false;

            if (this.mouse.stopped) break;
        }
    }
};
},{}],5:[function(require,module,exports){

/*
 * object.watch polyfill
#
 * 2012-04-03
#
 * By Eli Grey, http://eligrey.com
 * Public Domain.
 * NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
 */
if (!Object.prototype.watch) {
  Object.defineProperty(Object.prototype, 'watch', {
    enumerable: false,
    configurable: true,
    writable: false,
    value: function(prop, handler) {
      var getter, newval, oldval, setter;
      oldval = this[prop];
      newval = oldval;
      getter = function() {
        return newval;
      };
      setter = function(val) {
        oldval = newval;
        return newval = handler.call(this, prop, oldval, val);
      };
      if (delete this[prop]) {
        Object.defineProperty(this, prop, {
          get: getter,
          set: setter,
          enumerable: true,
          configurable: true
        });
      }
    }
  });
}

if (!Object.prototype.unwatch) {
  Object.defineProperty(Object.prototype, 'unwatch', {
    enumerable: false,
    configurable: true,
    writable: false,
    value: function(prop) {
      var val;
      val = this[prop];
      delete this[prop];
      this[prop] = val;
    }
  });
}



},{}],6:[function(require,module,exports){
var mozAddWheelListener;

mozAddWheelListener = require('../Dependencies/mozAddWheelListener');

PIXI.WebGLRenderer.prototype.wheelScrollObjects = [];

PIXI.WebGLRenderer.prototype.addWheelScrollObject = function(object) {
  return this.wheelScrollObjects.push(object);
};

PIXI.WebGLRenderer.prototype.setWheelScroll = function(state) {
  if (state == null) {
    return mozAddWheelListener(this.view, function(e) {});
  } else {
    return mozAddWheelListener(this.view, function(e) {
      var i, len, object, ref, results;
      ref = PIXI.WebGLRenderer.prototype.wheelScrollObjects;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        object = ref[i];
        results.push(object.onWheelScroll(e));
      }
      return results;
    });
  }
};

PIXI.CanvasRenderer.prototype.wheelScrollObjects = [];

PIXI.CanvasRenderer.prototype.addWheelScrollObject = function(object) {
  return this.wheelScrollObjects.push(object);
};

PIXI.CanvasRenderer.prototype.setWheelScroll = function(state) {
  if (state == null) {
    return mozAddWheelListener(this.view, function(e) {});
  } else {
    return mozAddWheelListener(this.view, function(e) {
      var i, len, object, ref, results;
      ref = PIXI.CanvasRenderer.prototype.wheelScrollObjects;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        object = ref[i];
        results.push(object.onWheelScroll(e));
      }
      return results;
    });
  }
};



},{"../Dependencies/mozAddWheelListener":1}],7:[function(require,module,exports){
String.prototype.contains = function(it) {
  return this.indexOf(it) !== -1;
};

String.prototype.startsWith = function(str) {
  return this.slice(0, str.length) === str;
};

String.prototype.endsWith = function(str) {
  return this.slice(-str.length) === str;
};

String.prototype.camelCase = function() {
  return this.replace(/(?:^\w|[A-Z]|\b\w)/g, function(letter, index) {
    if (index === 0) {
      return letter.toLowerCase();
    } else {
      return letter.toUpperCase();
    }
  }).replace(/\s+/g, '');
};

String.prototype.toTitleCase = function() {
  return this.replace(/\w\S*/g, function(txt) {
    return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
  });
};



},{}],8:[function(require,module,exports){
var Gotham;

require('./Extensions/DisplayObjectContainer.coffee');

require('./Extensions/PixiRenderer.coffee');

require('./Extensions/Array.coffee');

require('./Extensions/Object.coffee');

require('./Extensions/String.coffee');

require('./Extensions/InteractionManager');

Gotham = (function() {
  function Gotham() {}

  window.Gotham = Gotham;

  Gotham.Graphics = {
    Renderer: require('./Modules/Renderer.coffee'),
    Scene: require('./Modules/Scene.coffee'),
    Container: require('./Modules/Graphics/Container.coffee'),
    Graphics: require('./Modules/Graphics/Graphics.coffee'),
    Polygon: require('./Modules/Graphics/Polygon.coffee'),
    Rectangle: require('./Modules/Graphics/Rectangle.coffee'),
    Sprite: require('./Modules/Graphics/Sprite.coffee'),
    Text: require('./Modules/Graphics/Text.coffee'),
    Texture: require('./Modules/Graphics/Texture.coffee'),
    Tools: require('./Modules/Graphics/Tools.coffee')
  };

  Gotham.Controls = {
    Button: require('./Modules/Controls/Button.coffee'),
    Slider: require('./Modules/Controls/Slider.coffee')
  };

  Gotham.Pattern = {
    MVC: {
      Controller: require('./Modules/Pattern/MVC/Controller.coffee'),
      View: require('./Modules/Pattern/MVC/View.coffee')
    }
  };

  Gotham.Sound = require('./Modules/Sound.coffee');

  Gotham.Tween = require('./Modules/Tween/Tween.coffee');

  Gotham.Util = require('./Util/Util.coffee');

  Gotham.Network = require('./Modules/Network.coffee');

  Gotham.Database = new (require('./Modules/Database.coffee'))();

  Gotham.GameLoop = new (require('./Modules/GameLoop.coffee'))();

  Gotham.Preload = new (require('./Modules/Preload.coffee'))();

  return Gotham;

})();

module.exports = window.Gotham = Gotham;



},{"./Extensions/Array.coffee":2,"./Extensions/DisplayObjectContainer.coffee":3,"./Extensions/InteractionManager":4,"./Extensions/Object.coffee":5,"./Extensions/PixiRenderer.coffee":6,"./Extensions/String.coffee":7,"./Modules/Controls/Button.coffee":9,"./Modules/Controls/Slider.coffee":10,"./Modules/Database.coffee":11,"./Modules/GameLoop.coffee":12,"./Modules/Graphics/Container.coffee":13,"./Modules/Graphics/Graphics.coffee":14,"./Modules/Graphics/Polygon.coffee":15,"./Modules/Graphics/Rectangle.coffee":16,"./Modules/Graphics/Sprite.coffee":17,"./Modules/Graphics/Text.coffee":18,"./Modules/Graphics/Texture.coffee":19,"./Modules/Graphics/Tools.coffee":20,"./Modules/Network.coffee":21,"./Modules/Pattern/MVC/Controller.coffee":22,"./Modules/Pattern/MVC/View.coffee":23,"./Modules/Preload.coffee":24,"./Modules/Renderer.coffee":25,"./Modules/Scene.coffee":26,"./Modules/Sound.coffee":27,"./Modules/Tween/Tween.coffee":28,"./Util/Util.coffee":29}],9:[function(require,module,exports){
var Button,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Button = (function(superClass) {
  extend(Button, superClass);

  function Button(text, width, height, isClickOnly) {
    var button_text, button_texture, that;
    that = this;
    this._isClickOnly = isClickOnly;
    this._isToggled = false;
    button_texture = new Gotham.Graphics.Graphics;
    button_texture.lineStyle(1, 0xD3D3D3);
    button_texture.beginFill(0x000000);
    button_texture.drawRect(0, 0, 100, 50);
    button_texture.endFill();
    button_texture = button_texture.generateTexture();
    Button.__super__.constructor.call(this, button_texture);
    this.tint = 0x000000;
    this.width = width;
    this.height = height;
    this.setInteractive(true);
    button_text = new Gotham.Graphics.Text(text, {
      font: "bold 40px Arial",
      fill: "#ffffff",
      align: "left"
    });
    button_text.position.x = (this.width / this.scale.x) / 2;
    button_text.position.y = (this.height / this.scale.y) / 2;
    button_text.width = this.width / this.scale.x;
    button_text.height = this.height / this.scale.y;
    button_text.anchor = {
      x: 0.5,
      y: 0.5
    };
    this.addChild(button_text);
    this.click = function(e) {
      if (this._isClickOnly) {
        this.onClick();
        return;
      }
      this._isToggled = !this._isToggled;
      if (this._isToggled) {
        this.tint = 0xD3D3D3;
        return this.toggleOn();
      } else {
        this.tint = 0x000000;
        return this.toggleOff();
      }
    };
  }

  Button.prototype.setBackground = function(hex) {
    return this.tint = hex;
  };

  Button.prototype.onClick = function() {};

  Button.prototype.toggleOn = function() {};

  Button.prototype.toggleOff = function() {};

  return Button;

})(Gotham.Graphics.Sprite);

module.exports = Button;



},{}],10:[function(require,module,exports){
var Slider,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Slider = (function(superClass) {
  extend(Slider, superClass);

  function Slider(knobTexture, background) {
    var knob, progress_text, that;
    Slider.__super__.constructor.apply(this, arguments);
    that = this;
    this.onProgress = null;
    this.progress = 0;
    this.texture = background;
    this.tint = 0xFFFF00;
    knob = this.knob = new Gotham.Graphics.Sprite(knobTexture);
    knob.width = this.height;
    knob.height = this.height;
    knob.setInteractive(true);
    progress_text = new Gotham.Graphics.Text("0%", {
      font: "bold 20px Arial",
      fill: "#ffffff",
      align: "left"
    });
    progress_text.x = this.width / 2;
    progress_text.y = this.height / 2;
    progress_text.anchor = {
      x: 0.5,
      y: 0.5
    };
    this.addChild(progress_text);
    knob.mousedown = knob.touchstart = function(data) {
      this.data = data;
      this.sx = data.getLocalPosition(this).x * this.scale.x;
      return this.dragging = true;
    };
    knob.mouseup = knob.mouseupoutside = knob.touchend = knob.touchendoutside = function(data) {
      this.data = null;
      return this.dragging = false;
    };
    knob.mousemove = knob.touchmove = function(data) {
      var newData, newX;
      if (this.dragging) {
        newData = this.data.getLocalPosition(this.parent);
        newX = newData.x - this.sx;
        if (newX * this.parent.scale.x > this.parent.width - (this.width * this.parent.scale.x) || newX < 0) {
          return;
        }
        this.x = newX;
        that.progress = Math.round(that.calculateProgress(this.x));
        progress_text.setText(that.progress + "%");
        if (that.onProgress) {
          return that.onProgress(that.progress);
        }
      }
    };
    this.addChild(knob);
  }

  Slider.prototype.calculateProgress = function(x) {
    return ((x * this.scale.x) / (this.width - (this.knob.width * this.scale.x))) * 100;
  };

  return Slider;

})(Gotham.Graphics.Sprite);

module.exports = Slider;



},{}],11:[function(require,module,exports){
var Database;

Database = (function() {
  function Database() {
    this.tables = {};
    return this;
  }

  Database.prototype.createTable = function(tableName) {
    this.tables[tableName] = Taffy.taffy();
    return this.tables[tableName];
  };

  Database.prototype.table = function(tableName) {
    try {
      return this.tables[tableName];
    } catch (_error) {
      throw new ReferenceError("No table exists with that name: '" + tableName + "'");
    }
  };

  Database.prototype.getTables = function() {
    return this.tables;
  };

  return Database;

})();

module.exports = Database;



},{}],12:[function(require,module,exports){
var GameLoop;

GameLoop = (function() {
  function GameLoop(fps) {
    var animate, that;
    that = this;
    this.renderer = function() {};
    this._tasks = [];
    if (!fps) {
      this.fps = 200;
    } else {
      this.fps = fps;
    }
    PIXI.INTERACTION_FREQUENCY = 60;
    animate = function(time) {
      requestAnimationFrame(animate);
      return that.update(time);
    };
    requestAnimationFrame(animate);
  }

  GameLoop.prototype.setRenderer = function(renderer) {
    return this.renderer = renderer;
  };

  GameLoop.prototype.update = function(time) {
    var _task, i, len, ref, s;
    this.renderer();
    ref = this._tasks;
    for (i = 0, len = ref.length; i < len; i++) {
      _task = ref[i];
      s = _task();
      if (!s) {
        this._tasks.remove(_task);
      }
    }
    return Gotham.Tween.update(time);
  };

  GameLoop.prototype.addTask = function(task) {
    return this._tasks.push(task);
  };

  return GameLoop;

})();

module.exports = GameLoop;



},{}],13:[function(require,module,exports){
var Container,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Container = (function(superClass) {
  var _created;

  extend(Container, superClass);

  function Container() {
    return Container.__super__.constructor.apply(this, arguments);
  }

  _created = false;

  Container.prototype.create = function() {
    throw new Exception("Override Create Method");
  };

  Container.prototype.update = function() {
    throw new Exception("Override Update Method");
  };

  return Container;

})(PIXI.DisplayObjectContainer);

module.exports = Container;



},{}],14:[function(require,module,exports){
var Graphics,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Graphics = (function(superClass) {
  extend(Graphics, superClass);

  function Graphics() {
    Graphics.__super__.constructor.apply(this, arguments);
    this._dx = 0;
    this._dy = 0;
  }

  return Graphics;

})(PIXI.Graphics);

module.exports = Graphics;



},{}],15:[function(require,module,exports){
var Polygon,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Polygon = (function(superClass) {
  extend(Polygon, superClass);

  function Polygon() {
    Polygon.__super__.constructor.apply(this, arguments);
  }

  return Polygon;

})(PIXI.Polygon);

module.exports = Polygon;



},{}],16:[function(require,module,exports){
var Rectangle,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Rectangle = (function(superClass) {
  extend(Rectangle, superClass);

  function Rectangle() {
    return Rectangle.__super__.constructor.apply(this, arguments);
  }

  return Rectangle;

})(PIXI.Rectangle);

module.exports = Rectangle;



},{}],17:[function(require,module,exports){
var Sprite,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Sprite = (function(superClass) {
  extend(Sprite, superClass);

  function Sprite(texture) {
    Sprite.__super__.constructor.apply(this, arguments);
    this.hoverTexture = null;
    this.normalTexture = texture;
  }

  return Sprite;

})(PIXI.Sprite);

module.exports = Sprite;



},{}],18:[function(require,module,exports){
var Text,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Text = (function(superClass) {
  extend(Text, superClass);

  function Text(text, style, x, y) {
    Text.__super__.constructor.apply(this, arguments);
    this.setText(text);
    this.position.x = x;
    this.position.y = y;
    if (style != null) {
      this.setStyle(style);
    }
  }

  return Text;

})(PIXI.Text);

module.exports = Text;



},{}],19:[function(require,module,exports){
var Texture,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Texture = (function(superClass) {
  extend(Texture, superClass);

  function Texture() {
    return Texture.__super__.constructor.apply(this, arguments);
  }

  return Texture;

})(PIXI.Texture);

module.exports = Texture;



},{}],20:[function(require,module,exports){
var Tools;

Tools = (function() {
  function Tools() {}

  Tools.PolygonFromJSON = function(json, skipRatio, scale) {
    var _key, count, i, j, key, len, len1, point, pointList, polygon, polygonList;
    if (skipRatio == null) {
      skipRatio = 5;
    }
    if (scale == null) {
      scale = {
        x: 1,
        y: 1
      };
    }
    polygonList = new Array;
    for (key = i = 0, len = json.length; i < len; key = ++i) {
      polygon = json[key];
      pointList = new Array;
      count = 0;
      for (_key = j = 0, len1 = polygon.length; j < len1; _key = ++j) {
        point = polygon[_key];
        if (count++ % skipRatio === 0) {
          pointList.push(new PIXI.Point(point[0] / (scale.x * 1.0), point[1] / (scale.y * 1.0)));
        }
      }
      polygonList.push(new Gotham.Graphics.Polygon(pointList));
    }
    return polygonList;
  };

  Tools.PolygonToGraphics = function(polygon, interactive) {
    var graphicsList, grp, i, j, key, len, len1, minX, minY, point, polygonList, ref, xory;
    polygonList = [];
    graphicsList = [];
    if (polygon.constructor !== Array) {
      polygonList.push(polygon);
    } else {
      polygonList = polygon;
    }
    for (key = i = 0, len = polygonList.length; i < len; key = ++i) {
      polygon = polygonList[key];
      xory = 0;
      minX = 10000000;
      minY = 10000000;
      ref = polygon.points;
      for (j = 0, len1 = ref.length; j < len1; j++) {
        point = ref[j];
        if (xory++ % 2 === 0) {
          if (point < minX) {
            minX = point;
          }
        } else {
          if (point < minY) {
            minY = point;
          }
        }
      }
      grp = new Gotham.Graphics.Graphics();
      grp.minX = minX;
      grp.minY = minY;
      graphicsList.push(grp);
      grp.lineStyle(2, 0x000000, 1);
      grp.beginFill(0xffffff, 0.5);
      grp.polygon = polygon;
      grp.drawPolygon(polygon.points);
      if (interactive != null) {
        grp.interactive = true;
        grp.buttonMode = true;
        grp.hitArea = new Gotham.Graphics.Polygon(polygon.points);
      }
    }
    return graphicsList;
  };

  return Tools;

})();

module.exports = Tools;



},{}],21:[function(require,module,exports){
var Network;

Network = (function() {
  function Network(host, port) {
    var ref;
    this.host = host;
    this.port = port;
    this.Socket = this._socket = null;
    this.onConnect = function() {};
    this.onReconnect = function() {};
    this.onReconnecting = function() {};
    if ((ref = !port) != null ? ref : this.port = 8080) {

    } else {
      this.port = port;
    }
  }

  Network.prototype.connect = function(callback) {
    var that;
    that = this;
    this.Socket = this._socket = io.connect(this.host + ":" + this.port);
    this._socket.on('connect', function() {
      that.onConnect(this);
      return that.onConnect = function() {};
    });
    this._socket.on('reconnect', function() {
      return that.onReconnect(this);
    });
    return this._socket.on('reconnecting', function() {
      return that.onReconnecting(this);
    });
  };

  return Network;

})();

module.exports = Network;



},{}],22:[function(require,module,exports){
var Controller;

Controller = (function() {
  function Controller(View, name) {
    var ViewObject;
    ViewObject = new View;
    if (!ViewObject._v) {
      throw Error("View is missing in super constructor (Have your view inherited GothamGame.View ?");
    }
    this._created = false;
    this._processes = [];
    this.name = name;
    this.View = ViewObject;
  }

  Controller.prototype.create = function() {
    throw new Error("create() must be overriden");
  };

  Controller.prototype.addProcess = function(func) {
    return this._processes.push(func);
  };

  return Controller;

})();

module.exports = Controller;



},{}],23:[function(require,module,exports){
var View,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

View = (function(superClass) {
  extend(View, superClass);

  function View() {
    View.__super__.constructor.apply(this, arguments);
    this._v = true;
    this._created = false;
    this._processes = [];
  }

  View.prototype.create = function() {
    throw new Error("create() must be overriden");
  };

  View.prototype.addProcess = function(func) {
    return this._processes.push(func);
  };

  return View;

})(Gotham.Graphics.Container);

module.exports = View;



},{}],24:[function(require,module,exports){
var Preload;

Preload = (function() {
  var DownloadImage, DownloadJSON, DownloadSound;

  function Preload() {
    this.db_image = Gotham.Database.createTable("preload_images");
    this.db_audio = Gotham.Database.createTable("preload_audio");
    this.db_data = Gotham.Database.createTable("preload_data");
    this.onLoad = function() {};
    this.onComplete = function() {};
    this._numNetworkLoaded = 0;
    this._totalCount = 0;
  }

  Preload.prototype.getTotalCount = function() {
    return this._totalCount;
  };

  Preload.prototype.incrementTotalCount = function() {
    return this._totalCount++;
  };

  Preload.prototype.getNumLoaded = function() {
    var db, dbs, i, len, total;
    dbs = [this.db_audio, this.db_image, this.db_data];
    total = this._numNetworkLoaded;
    for (i = 0, len = dbs.length; i < len; i++) {
      db = dbs[i];
      total += db().count();
    }
    return total;
  };

  DownloadJSON = function(url, callback) {
    return Gotham.Util.Ajax.GET(url, function(data, response) {
      return callback(data);
    });
  };

  DownloadImage = function(url, callback) {
    var texture;
    texture = Gotham.Graphics.Texture.fromImage(url);
    return texture.addEventListener("update", function() {
      this.addEventListener("update", function() {});
      return callback(texture);
    });
  };

  DownloadSound = function(url, options, callback) {
    var howlParameters, howler, sound;
    howlParameters = {
      urls: [url]
    };
    if (options != null) {
      howlParameters.merge(options);
    }
    howler = new Howl(howlParameters);
    sound = new Gotham.Sound(howler);
    sound._name = name;
    return howler.on('load', function() {
      return callback(sound);
    });
  };

  Preload.prototype._onComplete = function() {
    return this.onComplete();
  };

  Preload.prototype._onLoad = function(source, type, name) {
    var percent;
    percent = (this.getNumLoaded() / this.getTotalCount()) * 100.0;
    this.onLoad(source, type, name, percent);
    if (Math.round(percent) === 100) {
      return this._onComplete();
    }
  };

  Preload.prototype.isPreloadComplete = function() {
    return ((this._loadedObjects / this._totalObjects) * 100.0) === 100;
  };

  Preload.prototype.image = function(url, name) {
    var that;
    that = this;
    this.incrementTotalCount();
    return DownloadImage(url, function(image) {
      that.db_image.insert({
        name: name,
        object: image,
        type: 'image'
      });
      return that._onLoad(image, 'Image', name);
    });
  };

  Preload.prototype.mp3 = function(url, name, options) {
    var that;
    that = this;
    this.incrementTotalCount();
    return DownloadSound(url, options, function(sound) {
      that.db_audio.insert({
        name: name,
        object: sound,
        type: 'audio'
      });
      return that._onLoad(sound, 'Audio', name);
    });
  };

  Preload.prototype.json = function(url, name) {
    var that;
    that = this;
    this.incrementTotalCount();
    return DownloadJSON(url, function(json) {
      that.db_data.insert({
        name: name,
        object: json,
        type: 'json'
      });
      return that._onLoad(json, 'JSON', name);
    });
  };

  Preload.prototype.network = function(name, table, socket) {
    var that;
    that = this;
    this.incrementTotalCount();
    socket.Socket.emit(name);
    return socket.Socket.on(name, function(data) {
      that._numNetworkLoaded = that._numNetworkLoaded + 1;
      if (typeof data === 'array') {
        table.merge(data);
      } else {
        table.insert(data);
      }
      return that._onLoad(data, 'Data', name);
    });
  };

  Preload.prototype.fetch = function(name, type) {
    var db;
    db = this.getDatabase(type);
    return db({
      name: name
    }).first().object;
  };

  Preload.prototype.getDatabase = function(type) {
    switch (type) {
      case "image":
        return this.db_image;
      case "audio":
        return this.db_audio;
      case "json":
        return this.db_data;
      default:
        throw new Error("Format Not Supported, Preload");
    }
    return this.storage;
  };

  return Preload;

})();

module.exports = Preload;



},{}],25:[function(require,module,exports){
var Renderer;

Renderer = (function() {
  function Renderer(width, height, options, autoResize) {
    var label, rootScene, that;
    that = this;
    this.pixi = PIXI.autoDetectRenderer(width, height, options);
    window.renderer = this;
    this.pixi.setWheelScroll(true);
    if (autoResize != null) {
      this.pixi.view.style.width = window.innerWidth + 'px';
      this.pixi.view.style.height = window.innerHeight + 'px';
      window.addEventListener("resize", function() {
        that.pixi.view.style.width = window.innerWidth + 'px';
        return that.pixi.view.style.height = window.innerHeight + 'px';
      });
    }
    rootScene = new Gotham.Graphics.Scene(0x000000, true);
    label = new Gotham.Graphics.Text("Gotham Game Engine", {
      font: "35px Arial",
      fill: "white",
      align: "left"
    }, 1920 / 2, 1080 / 2);
    label.anchor = {
      x: 0.5,
      y: 0.5
    };
    rootScene.addChild(label);
    this.pixi.stage = rootScene;
    this.scenes = {
      "root": this.pixi.stage
    };
    document.body.appendChild(this.pixi.view);
    Gotham.GameLoop.setRenderer(function() {
      return renderer.pixi.render(renderer.pixi.stage);
    });
  }

  Renderer.prototype.setScene = function(name) {
    var scene;
    scene = this.scenes[name];
    return this.pixi.stage = scene;
  };

  Renderer.prototype.addScene = function(name, scene) {
    scene._renderer = this;
    return this.scenes[name] = scene;
  };

  return Renderer;

})();

module.exports = Renderer;



},{}],26:[function(require,module,exports){
var Scene,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Scene = (function(superClass) {
  extend(Scene, superClass);

  function Scene() {
    Scene.__super__.constructor.apply(this, arguments);
    this.__children = {};
    this.create();
  }

  Scene.prototype.create = function() {};

  Scene.prototype.getObject = function(name) {
    return this.__children[name];
  };

  Scene.prototype.addObject = function(child) {
    this.addChild(child.View);
    child.scene = this;
    child.View.scene = this;
    if (!child.View._created) {
      child.View.create();
    }
    if (!child._created) {
      child.create();
    }
    child.View._created = true;
    child._created = true;
    if (!child.name) {
      throw Error("Missing @name property!");
    }
    this.__children[child.name] = child;
    return child;
  };

  Scene.prototype.removeObject = function(child) {
    delete this.__children[child.name];
    child.scene = null;
    child.View.scene = null;
    child._created = false;
    child.View._created = false;
    return this.removeChild(child.View);
  };

  return Scene;

})(PIXI.Stage);

module.exports = Scene;



},{}],27:[function(require,module,exports){
var Howler, Sound;

Howler = require('../dependencies/howler.js');

Sound = (function() {
  function Sound(sound) {
    this._sound = sound;
  }

  Sound.prototype.play = function() {
    return this._sound.play();
  };

  Sound.prototype.stop = function() {
    return this._sound.stop();
  };

  Sound.prototype.pause = function() {
    return this._sound.pause();
  };

  Sound.prototype.volume = function(val) {
    return this._sound.volume(val);
  };

  Sound.prototype.forward = function(sec) {
    var currPos;
    currPos = this._sound.pos();
    return this._sound.pos(currPos + sec);
  };

  Sound.prototype.backward = function(sec) {
    var currPos;
    currPos = this._sound.pos();
    return this._sound.pos(currPos - sec);
  };

  Sound.prototype.mute = function() {
    return this._sound.mute();
  };

  Sound.prototype.unmute = function() {
    return this._sound.unmute();
  };

  Sound.prototype.loop = function(state) {
    return this._sound.loop(state);
  };

  return Sound;

})();

module.exports = Sound;



},{"../dependencies/howler.js":34}],28:[function(require,module,exports){
'use strict';
var Tween,
  modulo = function(a, b) { return (+a % (b = +b) + b) % b; };

Tween = (function() {
  var ChainItem;

  ChainItem = (function() {
    function ChainItem() {
      this.property = null;
      this.duration = null;
      this.startTime = null;
      this.endTime = null;
      this.inited = false;
      this.type = null;
      this.next = null;
      this.previous = null;
      this.elapsed = 0;
    }

    return ChainItem;

  })();

  Tween._tweens = [];

  Tween.clear = function() {
    var j, len1, ref, results, tween;
    ref = Tween._tweens;
    results = [];
    for (j = 0, len1 = ref.length; j < len1; j++) {
      tween = ref[j];
      results.push(tween._complete = true);
    }
    return results;
  };

  Tween._currentTime = 0;

  function Tween(object) {
    this._object = object;
    this._chain = [];
    this._properties = [];
    this._easing = Tween.Easing.Linear.None;
    this._interpolation = Tween.Interpolation.Linear;
    this._onUpdate = function() {};
    this._onComplete = function() {};
    this._onStart = function() {};
    this._started = false;
    this._complete = false;
    this._lastTime = 0;
    this._runCounter = 0;
    this._remainingRuns = 1;
    Tween._tweens.push(this);
  }

  Tween.prototype.getTweenChain = function() {
    return this._chain;
  };

  Tween.prototype.addToChain = function(newPath) {
    var first, last;
    if (this._chain.length > 0) {
      last = this._chain[this._chain.length - 1];
      last.next = newPath;
      first = this._chain[0];
      first.previous = newPath;
      newPath.previous = last;
      newPath.next = first;
    } else {
      newPath.previous = newPath;
      newPath.next = newPath;
    }
    return this._chain.push(newPath);
  };

  Tween.prototype.start = function() {
    this._started = true;
    return this._onStart(this._object);
  };

  Tween.prototype.stop = function() {
    this._started = false;
    return this._complete = true;
  };

  Tween.prototype.pause = function() {
    return this._started = false;
  };

  Tween.prototype.unpause = function() {
    var chainItem, elapsedTime, time, timeLeft;
    this._started = true;
    time = performance.now();
    chainItem = this._chain[modulo(this._runCounter, this._chain.length)];
    elapsedTime = (chainItem.endTime - chainItem.startTime) * chainItem.elapsed;
    timeLeft = chainItem.duration - elapsedTime;
    chainItem.endTime = time + timeLeft;
    return chainItem.startTime = chainItem.endTime - chainItem.duration;
  };

  Tween.prototype.easing = function(easing) {
    return this._easing = easing;
  };

  Tween.prototype.to = function(property, duration) {
    var j, len1, newPath, prop, ref;
    ref = Tween.flattenKeys(property);
    for (j = 0, len1 = ref.length; j < len1; j++) {
      prop = ref[j];
      this._properties.push(prop);
    }
    newPath = new ChainItem();
    newPath.property = property;
    newPath.duration = duration;
    newPath.startTime = null;
    newPath.endTime = null;
    newPath.inited = false;
    newPath.type = "translate";
    newPath.next = null;
    newPath.previous = null;
    newPath.elapsed = 0;
    return this.addToChain(newPath);
  };

  Tween.prototype.delay = function(time) {
    var delayItem;
    if (typeof time !== 'number') {
      throw new Error("Time was not a number!");
    }
    delayItem = {
      "duration": time,
      "startTime": null,
      "endTime": null,
      "type": "delay",
      "previous": null,
      "next": null
    };
    return this.addToChain(delayItem);
  };

  Tween.prototype.repeat = function(num) {
    return this._remainingRuns = num;
  };

  Tween.prototype.addCutsomProperty = function(property) {
    return this._properties.push(property);
  };

  Tween.prototype.addCutsomProperties = function(properties) {
    var j, len1, property, results;
    results = [];
    for (j = 0, len1 = properties.length; j < len1; j++) {
      property = properties[j];
      results.push(this.addProperty(property));
    }
    return results;
  };

  Tween.prototype.onUpdate = function(callback) {
    return this._onUpdate = callback;
  };

  Tween.prototype.onComplete = function(callback) {
    return this._onComplete = callback;
  };

  Tween.prototype.onStart = function(callback) {
    return this._onStart = callback;
  };

  Tween.update = function(time) {
    var chainItem, elapsed, end, endTime, j, key, l, len1, len2, nextPos, prop, property, ref, ref1, results, start, startTime, tween, value;
    Gotham.Tween._currentTime = time;
    if (Tween._tweens.length <= 0) {
      return;
    }
    ref = Tween._tweens;
    results = [];
    for (j = 0, len1 = ref.length; j < len1; j++) {
      tween = ref[j];
      if (!tween) {
        continue;
      }
      if (!tween._started) {
        continue;
      }
      if (time < tween._startTime) {
        continue;
      }
      if (tween._complete) {
        tween._onComplete(tween._object);
        Tween._tweens.remove(tween);
        continue;
      }
      if (tween._chain.length <= 0 || tween._remainingRuns <= 0) {
        tween._complete = true;
        continue;
      }
      chainItem = tween._chain[modulo(tween._runCounter, tween._chain.length)];
      if (!chainItem.inited) {
        chainItem.startTime = performance.now();
        chainItem.endTime = chainItem.startTime + chainItem.duration;
        chainItem.inited = true;
        if (chainItem.type === "delay") {
          break;
        }
        chainItem.startPos = {};
        ref1 = tween._properties;
        for (l = 0, len2 = ref1.length; l < len2; l++) {
          property = ref1[l];
          key = property.split('.')[0];
          value = tween._object[key];
          chainItem.startPos[key] = typeof value === 'object' ? $.extend(false, {}, value) : value;
        }
      }
      if (time > chainItem.endTime) {
        tween._runCounter++;
        chainItem.startTime = null;
        chainItem.endTime = null;
        chainItem.inited = false;
        if (modulo(tween._runCounter, tween._chain.length) === 0) {
          tween._remainingRuns -= 1;
        }
        continue;
        if (chainItem.type === "delay") {
          continue;
        }
      }
      startTime = chainItem.startTime;
      endTime = startTime + chainItem.duration;
      start = chainItem.startPos;
      end = chainItem.property;
      elapsed = (performance.now() - startTime) / chainItem.duration;
      chainItem.elapsed = elapsed;
      elapsed = elapsed > 1 ? 1 : elapsed;
      value = tween._easing(elapsed);
      tween._onUpdate(chainItem);
      results.push((function() {
        var len3, o, ref2, results1;
        ref2 = tween._properties;
        results1 = [];
        for (o = 0, len3 = ref2.length; o < len3; o++) {
          prop = ref2[o];
          nextPos = Tween.resolve(start, prop) + (Tween.resolve(end, prop) - Tween.resolve(start, prop)) * value;
          results1.push(Tween.resolve(tween._object, prop, null, nextPos));
        }
        return results1;
      })());
    }
    return results;
  };

  Tween.resolve = function(obj, path, def, setValue) {
    var i, len, previous;
    i = void 0;
    len = void 0;
    previous = obj;
    i = 0;
    path = path.split('.');
    len = path.length;
    while (i < len) {
      if (!obj || typeof obj !== 'object') {
        return def;
      }
      previous = obj;
      obj = obj[path[i]];
      i++;
    }
    if (obj === void 0) {
      return def;
    }
    if (setValue) {
      previous[path[len - 1]] = setValue;
    }
    return obj;
  };

  Tween.flattenKeys = function(obj, delimiter, max_depth) {
    var recurse;
    delimiter = delimiter || '.';
    max_depth = max_depth || 2;
    recurse = function(obj, path, result, level) {
      if (level > max_depth) {
        return;
      }
      level++;
      if (typeof obj === 'object' && obj) {
        Object.keys(obj).forEach(function(key) {
          path.push(key);
          recurse(obj[key], path, result, level);
          return path.pop();
        });
      } else {
        result.push(path.join(delimiter));
      }
      return result;
    };
    return recurse(obj, [], [], 0);
  };

  Tween.Easing = {
    Linear: {
      None: function(k) {
        return k;
      }
    },
    Quadratic: {
      In: function(k) {
        return k * k;
      },
      Out: function(k) {
        return k * (2 - k);
      },
      InOut: function(k) {
        if ((k *= 2) < 1) {
          return 0.5 * k * k;
        }
        return -0.5 * (--k * (k - 2) - 1);
      }
    },
    Cubic: {
      In: function(k) {
        return k * k * k;
      },
      Out: function(k) {
        return --k * k * k + 1;
      },
      InOut: function(k) {
        if ((k *= 2) < 1) {
          return 0.5 * k * k * k;
        }
        return 0.5 * ((k -= 2) * k * k + 2);
      }
    },
    Quartic: {
      In: function(k) {
        return k * k * k * k;
      },
      Out: function(k) {
        return 1 - --k * k * k * k;
      },
      InOut: function(k) {
        if ((k *= 2) < 1) {
          return 0.5 * k * k * k * k;
        }
        return -0.5 * ((k -= 2) * k * k * k - 2);
      }
    },
    Quintic: {
      In: function(k) {
        return k * k * k * k * k;
      },
      Out: function(k) {
        return --k * k * k * k * k + 1;
      },
      InOut: function(k) {
        if ((k *= 2) < 1) {
          return 0.5 * k * k * k * k * k;
        }
        return 0.5 * ((k -= 2) * k * k * k * k + 2);
      }
    },
    Sinusoidal: {
      In: function(k) {
        return 1 - Math.cos(k * Math.PI / 2);
      },
      Out: function(k) {
        return Math.sin(k * Math.PI / 2);
      },
      InOut: function(k) {
        return 0.5 * (1 - Math.cos(Math.PI * k));
      }
    },
    Exponential: {
      In: function(k) {
        if (k === 0) {
          return 0;
        } else {
          return Math.pow(1024, k - 1);
        }
      },
      Out: function(k) {
        if (k === 1) {
          return 1;
        } else {
          return 1 - Math.pow(2, -10 * k);
        }
      },
      InOut: function(k) {
        if (k === 0) {
          return 0;
        }
        if (k === 1) {
          return 1;
        }
        if ((k *= 2) < 1) {
          return 0.5 * Math.pow(1024, k - 1);
        }
        return 0.5 * (-(Math.pow(2, -10 * (k - 1))) + 2);
      }
    },
    Circular: {
      In: function(k) {
        return 1 - Math.sqrt(1 - k * k);
      },
      Out: function(k) {
        return Math.sqrt(1 - --k * k);
      },
      InOut: function(k) {
        if ((k *= 2) < 1) {
          return -0.5 * (Math.sqrt(1 - k * k) - 1);
        }
        return 0.5 * (Math.sqrt(1 - (k -= 2) * k) + 1);
      }
    },
    Elastic: {
      In: function(k) {
        var a, p, s;
        s = void 0;
        a = 0.1;
        p = 0.4;
        if (k === 0) {
          return 0;
        }
        if (k === 1) {
          return 1;
        }
        if (!a || a < 1) {
          a = 1;
          s = p / 4;
        } else {
          s = p * Math.asin(1 / a) / 2 * Math.PI;
        }
        return -(a * Math.pow(2, 10 * (k -= 1)) * Math.sin((k - s) * 2 * Math.PI / p));
      },
      Out: function(k) {
        var a, p, s;
        s = void 0;
        a = 0.1;
        p = 0.4;
        if (k === 0) {
          return 0;
        }
        if (k === 1) {
          return 1;
        }
        if (!a || a < 1) {
          a = 1;
          s = p / 4;
        } else {
          s = p * Math.asin(1 / a) / 2 * Math.PI;
        }
        return a * Math.pow(2, -10 * k) * Math.sin((k - s) * 2 * Math.PI / p) + 1;
      },
      InOut: function(k) {
        var a, p, s;
        s = void 0;
        a = 0.1;
        p = 0.4;
        if (k === 0) {
          return 0;
        }
        if (k === 1) {
          return 1;
        }
        if (!a || a < 1) {
          a = 1;
          s = p / 4;
        } else {
          s = p * Math.asin(1 / a) / 2 * Math.PI;
        }
        if ((k *= 2) < 1) {
          return -0.5 * a * Math.pow(2, 10 * (k -= 1)) * Math.sin((k - s) * 2 * Math.PI / p);
        }
        return a * Math.pow(2, -10 * (k -= 1)) * Math.sin((k - s) * 2 * Math.PI / p) * 0.5 + 1;
      }
    },
    Back: {
      In: function(k) {
        var s;
        s = 1.70158;
        return k * k * ((s + 1) * k - s);
      },
      Out: function(k) {
        var s;
        s = 1.70158;
        return --k * k * ((s + 1) * k + s) + 1;
      },
      InOut: function(k) {
        var s;
        s = 1.70158 * 1.525;
        if ((k *= 2) < 1) {
          return 0.5 * k * k * ((s + 1) * k - s);
        }
        return 0.5 * ((k -= 2) * k * ((s + 1) * k + s) + 2);
      }
    },
    Bounce: {
      In: function(k) {
        return 1 - Tween.Easing.Bounce.Out(1 - k);
      },
      Out: function(k) {
        if (k < 1 / 2.75) {
          return 7.5625 * k * k;
        } else if (k < 2 / 2.75) {
          return 7.5625 * (k -= 1.5 / 2.75) * k + 0.75;
        } else if (k < 2.5 / 2.75) {
          return 7.5625 * (k -= 2.25 / 2.75) * k + 0.9375;
        } else {
          return 7.5625 * (k -= 2.625 / 2.75) * k + 0.984375;
        }
      },
      InOut: function(k) {
        if (k < 0.5) {
          return Tween.Easing.Bounce.In(k * 2) * 0.5;
        }
        return Tween.Easing.Bounce.Out(k * 2 - 1) * 0.5 + 0.5;
      }
    }
  };

  Tween.Interpolation = {
    Linear: function(v, k) {
      var f, fn, i, m;
      m = v.length - 1;
      f = m * k;
      i = Math.floor(f);
      fn = Tween.Interpolation.Utils.Linear;
      if (k < 0) {
        return fn(v[0], v[1], f);
      }
      if (k > 1) {
        return fn(v[m], v[m - 1], m - f);
      }
      return fn(v[i], v[i + 1 > m ? m : i + 1], f - i);
    },
    Bezier: function(v, k) {
      var b, bn, i, n, pw;
      b = 0;
      n = v.length - 1;
      pw = Math.pow;
      bn = Tween.Interpolation.Utils.Bernstein;
      i = void 0;
      i = 0;
      while (i <= n) {
        b += pw(1 - k, n - i) * pw(k, i) * v[i] * bn(n, i);
        i++;
      }
      return b;
    },
    CatmullRom: function(v, k) {
      var f, fn, i, m;
      m = v.length - 1;
      f = m * k;
      i = Math.floor(f);
      fn = Tween.Interpolation.Utils.CatmullRom;
      if (v[0] === v[m]) {
        if (k < 0) {
          i = Math.floor(f = m * (1 + k));
        }
        return fn(v[(i - 1 + m) % m], v[i], v[(i + 1) % m], v[(i + 2) % m], f - i);
      } else {
        if (k < 0) {
          return v[0] - (fn(v[0], v[0], v[1], v[1], -f) - v[0]);
        }
        if (k > 1) {
          return v[m] - (fn(v[m], v[m], v[m - 1], v[m - 1], f - m) - v[m]);
        }
        return fn(v[i ? i - 1 : 0], v[i], v[m < i + 1 ? m : i + 1], v[m < i + 2 ? m : i + 2], f - i);
      }
    },
    Utils: {
      Linear: function(p0, p1, t) {
        return (p1 - p0) * t + p0;
      },
      Bernstein: function(n, i) {
        var fc;
        fc = Tween.Interpolation.Utils.Factorial;
        return fc(n) / fc(i) / fc(n - i);
      },
      Factorial: (function() {
        var a;
        a = [1];
        return function(n) {
          var i, s;
          s = 1;
          i = void 0;
          if (a[n]) {
            return a[n];
          }
          i = n;
          while (i > 1) {
            s *= i;
            i--;
          }
          return a[n] = s;
        };
      })(),
      CatmullRom: function(p0, p1, p2, p3, t) {
        var t2, t3, v0, v1;
        v0 = (p2 - p0) * 0.5;
        v1 = (p3 - p1) * 0.5;
        t2 = t * t;
        t3 = t * t2;
        return (2 * p1 - 2 * p2 + v0 + v1) * t3 + (-3 * p1 + 3 * p2 - 2 * v0 - v1) * t2 + v0 * t + p1;
      }
    }
  };

  return Tween;

})();

module.exports = Tween;



},{}],29:[function(require,module,exports){
var Util;

Util = (function() {
  function Util() {}

  Util.Ajax = require('./modules/Ajax.coffee');

  Util.SearchTools = require('./modules/SearchTools.coffee');

  Util.Compression = require('./modules/Compression.coffee');

  Util.Geocoding = require('./modules/Geocoding.coffee');

  return Util;

})();

module.exports = Util;



},{"./modules/Ajax.coffee":30,"./modules/Compression.coffee":31,"./modules/Geocoding.coffee":32,"./modules/SearchTools.coffee":33}],30:[function(require,module,exports){
var Ajax;

Ajax = (function() {
  function Ajax() {}

  Ajax.getXmlDoc = function() {
    var xmlDoc;
    xmlDoc = null;
    if (window.XMLHttpRequest) {
      xmlDoc = new XMLHttpRequest();
    } else {
      xmlDoc = new ActiveXObject("Microsoft.XMLHTTP");
    }
    return xmlDoc;
  };

  Ajax.GET = function(url, callback) {
    var xmlDoc;
    xmlDoc = Ajax.getXmlDoc();
    xmlDoc.open('GET', url, true);
    xmlDoc.onreadystatechange = function() {
      if (xmlDoc.readyState === 4 && xmlDoc.status === 200) {
        return callback(JSON.parse(xmlDoc.response), xmlDoc);
      }
    };
    return xmlDoc.send();
  };

  return Ajax;

})();

module.exports = Ajax;



},{}],31:[function(require,module,exports){
var Compression;

Compression = (function() {
  function Compression() {}

  Compression.prototype.GZIP = {
    decompress: function(bytes) {
      var gunzip, plain;
      gunzip = new Zlib.Zlib.Gunzip(atob(bytes));
      plain = gunzip.decompress();
      return plain;
    }
  };

  return Compression;

})();

module.exports = new Compression();



},{}],32:[function(require,module,exports){
var Geocoding;

Geocoding = (function() {
  function Geocoding() {}

  Geocoding.getCountry = function(lat, lng) {
    return window.CRG.country_reverse_geocoding().get_country(lat, lng);
  };

  Geocoding.CalculateDistance = function(coordinate1, coordinate2) {
    var R, a, c, g1, g2, h1, h2;
    R = 6371000;
    g1 = coordinate1.lat * Math.PI / 180;
    g2 = coordinate2.lat * Math.PI / 180;
    h1 = (coordinate2.lat - coordinate1.lat) * Math.PI / 180;
    h2 = (coordinate2.lng - coordinate1.lng) * Math.PI / 180;
    a = Math.sin(h1 / 2) * Math.sin(h1 / 2) + Math.cos(g1) * Math.cos(g2) * Math.sin(h2 / 2) * Math.sin(h2 / 2);
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  };

  return Geocoding;

})();

module.exports = Geocoding;



},{}],33:[function(require,module,exports){
var SearchTools;

SearchTools = (function() {
  function SearchTools() {}

  SearchTools.FindKey = function(object, key, maxDepth) {
    var _key, depth, found, item, queue;
    if (maxDepth == null) {
      maxDepth = 7;
    }
    queue = [];
    queue.push(object);
    found = void 0;
    depth = 0;
    while (queue.length && !found) {
      if (depth++ > maxDepth) {
        return null;
      }
      item = queue.shift();
      if (key in item) {
        console.log("boud!");
        found = item[key];
      }
      if (typeof item === 'object') {
        for (_key in item) {
          queue.push(item[_key]);
        }
      }
    }
    return found;
  };

  return SearchTools;

})();

module.exports = SearchTools;



},{}],34:[function(require,module,exports){
/*!
 *  howler.js v1.1.25
 *  howlerjs.com
 *
 *  (c) 2013-2014, James Simpson of GoldFire Studios
 *  goldfirestudios.com
 *
 *  MIT License
 */

(function () {
  // setup
  var cache = {};

  // setup the audio context
  var ctx = null,
    usingWebAudio = true,
    noAudio = false;
  try {
    if (typeof AudioContext !== 'undefined') {
      ctx = new AudioContext();
    } else if (typeof webkitAudioContext !== 'undefined') {
      ctx = new webkitAudioContext();
    } else {
      usingWebAudio = false;
    }
  } catch (e) {
    usingWebAudio = false;
  }

  if (!usingWebAudio) {
    if (typeof Audio !== 'undefined') {
      try {
        new Audio();
      } catch (e) {
        noAudio = true;
      }
    } else {
      noAudio = true;
    }
  }

  // create a master gain node
  if (usingWebAudio) {
    var masterGain = (typeof ctx.createGain === 'undefined') ? ctx.createGainNode() : ctx.createGain();
    masterGain.gain.value = 1;
    masterGain.connect(ctx.destination);
  }

  // create global controller
  var HowlerGlobal = function (codecs) {
    this._volume = 1;
    this._muted = false;
    this.usingWebAudio = usingWebAudio;
    this.ctx = ctx;
    this.noAudio = noAudio;
    this._howls = [];
    this._codecs = codecs;
    this.iOSAutoEnable = true;
  };
  HowlerGlobal.prototype = {
    /**
     * Get/set the global volume for all sounds.
     * @param  {Float} vol Volume from 0.0 to 1.0.
     * @return {Howler/Float}     Returns self or current volume.
     */
    volume: function (vol) {
      var self = this;

      // make sure volume is a number
      vol = parseFloat(vol);

      if (vol >= 0 && vol <= 1) {
        self._volume = vol;

        if (usingWebAudio) {
          masterGain.gain.value = vol;
        }

        // loop through cache and change volume of all nodes that are using HTML5 Audio
        for (var key in self._howls) {
          if (self._howls.hasOwnProperty(key) && self._howls[key]._webAudio === false) {
            // loop through the audio nodes
            for (var i = 0; i < self._howls[key]._audioNode.length; i++) {
              self._howls[key]._audioNode[i].volume = self._howls[key]._volume * self._volume;
            }
          }
        }

        return self;
      }

      // return the current global volume
      return (usingWebAudio) ? masterGain.gain.value : self._volume;
    },

    /**
     * Mute all sounds.
     * @return {Howler}
     */
    mute: function () {
      this._setMuted(true);

      return this;
    },

    /**
     * Unmute all sounds.
     * @return {Howler}
     */
    unmute: function () {
      this._setMuted(false);

      return this;
    },

    /**
     * Handle muting and unmuting globally.
     * @param  {Boolean} muted Is muted or not.
     */
    _setMuted: function (muted) {
      var self = this;

      self._muted = muted;

      if (usingWebAudio) {
        masterGain.gain.value = muted ? 0 : self._volume;
      }

      for (var key in self._howls) {
        if (self._howls.hasOwnProperty(key) && self._howls[key]._webAudio === false) {
          // loop through the audio nodes
          for (var i = 0; i < self._howls[key]._audioNode.length; i++) {
            self._howls[key]._audioNode[i].muted = muted;
          }
        }
      }
    },

    /**
     * Check for codec support.
     * @param  {String} ext Audio file extention.
     * @return {Boolean}
     */
    codecs: function (ext) {
      return this._codecs[ext];
    },

    /**
     * iOS will only allow audio to be played after a user interaction.
     * Attempt to automatically unlock audio on the first user interaction.
     * Concept from: http://paulbakaus.com/tutorials/html5/web-audio-on-ios/
     * @return {Howler}
     */
    _enableiOSAudio: function () {
      var self = this;

      // only run this on iOS if audio isn't already eanbled
      if (ctx && (self._iOSEnabled || !/iPhone|iPad|iPod/i.test(navigator.userAgent))) {
        return;
      }

      self._iOSEnabled = false;

      // call this method on touch start to create and play a buffer,
      // then check if the audio actually played to determine if
      // audio has now been unlocked on iOS
      var unlock = function () {
        // create an empty buffer
        var buffer = ctx.createBuffer(1, 1, 22050);
        var source = ctx.createBufferSource();
        source.buffer = buffer;
        source.connect(ctx.destination);

        // play the empty buffer
        if (typeof source.start === 'undefined') {
          source.noteOn(0);
        } else {
          source.start(0);
        }

        // setup a timeout to check that we are unlocked on the next event loop
        setTimeout(function () {
          if ((source.playbackState === source.PLAYING_STATE || source.playbackState === source.FINISHED_STATE)) {
            // update the unlocked state and prevent this check from happening again
            self._iOSEnabled = true;
            self.iOSAutoEnable = false;

            // remove the touch start listener
            window.removeEventListener('touchstart', unlock, false);
          }
        }, 0);
      };

      // setup a touch start listener to attempt an unlock in
      window.addEventListener('touchstart', unlock, false);

      return self;
    }
  };

  // check for browser codec support
  var audioTest = null;
  var codecs = {};
  if (!noAudio) {
    audioTest = new Audio();
    codecs = {
      mp3: !!audioTest.canPlayType('audio/mpeg;').replace(/^no$/, ''),
      opus: !!audioTest.canPlayType('audio/ogg; codecs="opus"').replace(/^no$/, ''),
      ogg: !!audioTest.canPlayType('audio/ogg; codecs="vorbis"').replace(/^no$/, ''),
      wav: !!audioTest.canPlayType('audio/wav; codecs="1"').replace(/^no$/, ''),
      aac: !!audioTest.canPlayType('audio/aac;').replace(/^no$/, ''),
      m4a: !!(audioTest.canPlayType('audio/x-m4a;') || audioTest.canPlayType('audio/m4a;') || audioTest.canPlayType('audio/aac;')).replace(/^no$/, ''),
      mp4: !!(audioTest.canPlayType('audio/x-mp4;') || audioTest.canPlayType('audio/mp4;') || audioTest.canPlayType('audio/aac;')).replace(/^no$/, ''),
      weba: !!audioTest.canPlayType('audio/webm; codecs="vorbis"').replace(/^no$/, '')
    };
  }

  // allow access to the global audio controls
  var Howler = new HowlerGlobal(codecs);

  // setup the audio object
  var Howl = function (o) {
    var self = this;

    // setup the defaults
    self._autoplay = o.autoplay || false;
    self._buffer = o.buffer || false;
    self._duration = o.duration || 0;
    self._format = o.format || null;
    self._loop = o.loop || false;
    self._loaded = false;
    self._sprite = o.sprite || {};
    self._src = o.src || '';
    self._pos3d = o.pos3d || [0, 0, -0.5];
    self._volume = o.volume !== undefined ? o.volume : 1;
    self._urls = o.urls || [];
    self._rate = o.rate || 1;

    // allow forcing of a specific panningModel ('equalpower' or 'HRTF'),
    // if none is specified, defaults to 'equalpower' and switches to 'HRTF'
    // if 3d sound is used
    self._model = o.model || null;

    // setup event functions
    self._onload = [o.onload || function () { }];
    self._onloaderror = [o.onloaderror || function () { }];
    self._onend = [o.onend || function () { }];
    self._onpause = [o.onpause || function () { }];
    self._onplay = [o.onplay || function () { }];

    self._onendTimer = [];

    // Web Audio or HTML5 Audio?
    self._webAudio = usingWebAudio && !self._buffer;

    // check if we need to fall back to HTML5 Audio
    self._audioNode = [];
    if (self._webAudio) {
      self._setupAudioNode();
    }

    // automatically try to enable audio on iOS
    if (typeof ctx !== 'undefined' && ctx && Howler.iOSAutoEnable) {
      Howler._enableiOSAudio();
    }

    // add this to an array of Howl's to allow global control
    Howler._howls.push(self);

    // load the track
    self.load();
  };

  // setup all of the methods
  Howl.prototype = {
    /**
     * Load an audio file.
     * @return {Howl}
     */
    load: function () {
      var self = this,
        url = null;

      // if no audio is available, quit immediately
      if (noAudio) {
        self.on('loaderror');
        return;
      }

      // loop through source URLs and pick the first one that is compatible
      for (var i = 0; i < self._urls.length; i++) {
        var ext, urlItem;

        if (self._format) {
          // use specified audio format if available
          ext = self._format;
        } else {
          // figure out the filetype (whether an extension or base64 data)
          urlItem = self._urls[i];
          ext = /^data:audio\/([^;,]+);/i.exec(urlItem);
          if (!ext) {
            ext = /\.([^.]+)$/.exec(urlItem.split('?', 1)[0]);
          }

          if (ext) {
            ext = ext[1].toLowerCase();
          } else {
            self.on('loaderror');
            return;
          }
        }

        if (codecs[ext]) {
          url = self._urls[i];
          break;
        }
      }

      if (!url) {
        self.on('loaderror');
        return;
      }

      self._src = url;

      if (self._webAudio) {
        loadBuffer(self, url);
      } else {
        var newNode = new Audio();

        // listen for errors with HTML5 audio (http://dev.w3.org/html5/spec-author-view/spec.html#mediaerror)
        newNode.addEventListener('error', function () {
          if (newNode.error && newNode.error.code === 4) {
            HowlerGlobal.noAudio = true;
          }

          self.on('loaderror', { type: newNode.error ? newNode.error.code : 0 });
        }, false);

        self._audioNode.push(newNode);

        // setup the new audio node
        newNode.src = url;
        newNode._pos = 0;
        newNode.preload = 'auto';
        newNode.volume = (Howler._muted) ? 0 : self._volume * Howler.volume();

        // setup the event listener to start playing the sound
        // as soon as it has buffered enough
        var listener = function () {
          // round up the duration when using HTML5 Audio to account for the lower precision
          self._duration = Math.ceil(newNode.duration * 10) / 10;

          // setup a sprite if none is defined
          if (Object.getOwnPropertyNames(self._sprite).length === 0) {
            self._sprite = { _default: [0, self._duration * 1000] };
          }

          if (!self._loaded) {
            self._loaded = true;
            self.on('load');
          }

          if (self._autoplay) {
            self.play();
          }

          // clear the event listener
          newNode.removeEventListener('canplaythrough', listener, false);
        };
        newNode.addEventListener('canplaythrough', listener, false);
        newNode.load();
      }

      return self;
    },

    /**
     * Get/set the URLs to be pulled from to play in this source.
     * @param  {Array} urls  Arry of URLs to load from
     * @return {Howl}        Returns self or the current URLs
     */
    urls: function (urls) {
      var self = this;

      if (urls) {
        self.stop();
        self._urls = (typeof urls === 'string') ? [urls] : urls;
        self._loaded = false;
        self.load();

        return self;
      } else {
        return self._urls;
      }
    },

    /**
     * Play a sound from the current time (0 by default).
     * @param  {String}   sprite   (optional) Plays from the specified position in the sound sprite definition.
     * @param  {Function} callback (optional) Returns the unique playback id for this sound instance.
     * @return {Howl}
     */
    play: function (sprite, callback) {
      var self = this;

      // if no sprite was passed but a callback was, update the variables
      if (typeof sprite === 'function') {
        callback = sprite;
      }

      // use the default sprite if none is passed
      if (!sprite || typeof sprite === 'function') {
        sprite = '_default';
      }

      // if the sound hasn't been loaded, add it to the event queue
      if (!self._loaded) {
        self.on('load', function () {
          self.play(sprite, callback);
        });

        return self;
      }

      // if the sprite doesn't exist, play nothing
      if (!self._sprite[sprite]) {
        if (typeof callback === 'function') callback();
        return self;
      }

      // get the node to playback
      self._inactiveNode(function (node) {
        // persist the sprite being played
        node._sprite = sprite;

        // determine where to start playing from
        var pos = (node._pos > 0) ? node._pos : self._sprite[sprite][0] / 1000;

        // determine how long to play for
        var duration = 0;
        if (self._webAudio) {
          duration = self._sprite[sprite][1] / 1000 - node._pos;
          if (node._pos > 0) {
            pos = self._sprite[sprite][0] / 1000 + pos;
          }
        } else {
          duration = self._sprite[sprite][1] / 1000 - (pos - self._sprite[sprite][0] / 1000);
        }

        // determine if this sound should be looped
        var loop = !!(self._loop || self._sprite[sprite][2]);

        // set timer to fire the 'onend' event
        var soundId = (typeof callback === 'string') ? callback : Math.round(Date.now() * Math.random()) + '',
          timerId;
        (function () {
          var data = {
            id: soundId,
            sprite: sprite,
            loop: loop
          };
          timerId = setTimeout(function () {
            // if looping, restart the track
            if (!self._webAudio && loop) {
              self.stop(data.id).play(sprite, data.id);
            }

            // set web audio node to paused at end
            if (self._webAudio && !loop) {
              self._nodeById(data.id).paused = true;
              self._nodeById(data.id)._pos = 0;

              // clear the end timer
              self._clearEndTimer(data.id);
            }

            // end the track if it is HTML audio and a sprite
            if (!self._webAudio && !loop) {
              self.stop(data.id);
            }

            // fire ended event
            self.on('end', soundId);
          }, duration * 1000);

          // store the reference to the timer
          self._onendTimer.push({ timer: timerId, id: data.id });
        })();

        if (self._webAudio) {
          var loopStart = self._sprite[sprite][0] / 1000,
            loopEnd = self._sprite[sprite][1] / 1000;

          // set the play id to this node and load into context
          node.id = soundId;
          node.paused = false;
          refreshBuffer(self, [loop, loopStart, loopEnd], soundId);
          self._playStart = ctx.currentTime;
          node.gain.value = self._volume;

          if (typeof node.bufferSource.start === 'undefined') {
            node.bufferSource.noteGrainOn(0, pos, duration);
          } else {
            node.bufferSource.start(0, pos, duration);
          }
        } else {
          if (node.readyState === 4 || !node.readyState && navigator.isCocoonJS) {
            node.readyState = 4;
            node.id = soundId;
            node.currentTime = pos;
            node.muted = Howler._muted || node.muted;
            node.volume = self._volume * Howler.volume();
            setTimeout(function () { node.play(); }, 0);
          } else {
            self._clearEndTimer(soundId);

            (function () {
              var sound = self,
                playSprite = sprite,
                fn = callback,
                newNode = node;
              var listener = function () {
                sound.play(playSprite, fn);

                // clear the event listener
                newNode.removeEventListener('canplaythrough', listener, false);
              };
              newNode.addEventListener('canplaythrough', listener, false);
            })();

            return self;
          }
        }

        // fire the play event and send the soundId back in the callback
        self.on('play');
        if (typeof callback === 'function') callback(soundId);

        return self;
      });

      return self;
    },

    /**
     * Pause playback and save the current position.
     * @param {String} id (optional) The play instance ID.
     * @return {Howl}
     */
    pause: function (id) {
      var self = this;

      // if the sound hasn't been loaded, add it to the event queue
      if (!self._loaded) {
        self.on('play', function () {
          self.pause(id);
        });

        return self;
      }

      // clear 'onend' timer
      self._clearEndTimer(id);

      var activeNode = (id) ? self._nodeById(id) : self._activeNode();
      if (activeNode) {
        activeNode._pos = self.pos(null, id);

        if (self._webAudio) {
          // make sure the sound has been created
          if (!activeNode.bufferSource || activeNode.paused) {
            return self;
          }

          activeNode.paused = true;
          if (typeof activeNode.bufferSource.stop === 'undefined') {
            activeNode.bufferSource.noteOff(0);
          } else {
            activeNode.bufferSource.stop(0);
          }
        } else {
          activeNode.pause();
        }
      }

      self.on('pause');

      return self;
    },

    /**
     * Stop playback and reset to start.
     * @param  {String} id  (optional) The play instance ID.
     * @return {Howl}
     */
    stop: function (id) {
      var self = this;

      // if the sound hasn't been loaded, add it to the event queue
      if (!self._loaded) {
        self.on('play', function () {
          self.stop(id);
        });

        return self;
      }

      // clear 'onend' timer
      self._clearEndTimer(id);

      var activeNode = (id) ? self._nodeById(id) : self._activeNode();
      if (activeNode) {
        activeNode._pos = 0;

        if (self._webAudio) {
          // make sure the sound has been created
          if (!activeNode.bufferSource || activeNode.paused) {
            return self;
          }

          activeNode.paused = true;

          if (typeof activeNode.bufferSource.stop === 'undefined') {
            activeNode.bufferSource.noteOff(0);
          } else {
            activeNode.bufferSource.stop(0);
          }
        } else if (!isNaN(activeNode.duration)) {
          activeNode.pause();
          activeNode.currentTime = 0;
        }
      }

      return self;
    },

    /**
     * Mute this sound.
     * @param  {String} id (optional) The play instance ID.
     * @return {Howl}
     */
    mute: function (id) {
      var self = this;

      // if the sound hasn't been loaded, add it to the event queue
      if (!self._loaded) {
        self.on('play', function () {
          self.mute(id);
        });

        return self;
      }

      var activeNode = (id) ? self._nodeById(id) : self._activeNode();
      if (activeNode) {
        if (self._webAudio) {
          activeNode.gain.value = 0;
        } else {
          activeNode.muted = true;
        }
      }

      return self;
    },

    /**
     * Unmute this sound.
     * @param  {String} id (optional) The play instance ID.
     * @return {Howl}
     */
    unmute: function (id) {
      var self = this;

      // if the sound hasn't been loaded, add it to the event queue
      if (!self._loaded) {
        self.on('play', function () {
          self.unmute(id);
        });

        return self;
      }

      var activeNode = (id) ? self._nodeById(id) : self._activeNode();
      if (activeNode) {
        if (self._webAudio) {
          activeNode.gain.value = self._volume;
        } else {
          activeNode.muted = false;
        }
      }

      return self;
    },

    /**
     * Get/set volume of this sound.
     * @param  {Float}  vol Volume from 0.0 to 1.0.
     * @param  {String} id  (optional) The play instance ID.
     * @return {Howl/Float}     Returns self or current volume.
     */
    volume: function (vol, id) {
      var self = this;

      // make sure volume is a number
      vol = parseFloat(vol);

      if (vol >= 0 && vol <= 1) {
        self._volume = vol;

        // if the sound hasn't been loaded, add it to the event queue
        if (!self._loaded) {
          self.on('play', function () {
            self.volume(vol, id);
          });

          return self;
        }

        var activeNode = (id) ? self._nodeById(id) : self._activeNode();
        if (activeNode) {
          if (self._webAudio) {
            activeNode.gain.value = vol;
          } else {
            activeNode.volume = vol * Howler.volume();
          }
        }

        return self;
      } else {
        return self._volume;
      }
    },

    /**
     * Get/set whether to loop the sound.
     * @param  {Boolean} loop To loop or not to loop, that is the question.
     * @return {Howl/Boolean}      Returns self or current looping value.
     */
    loop: function (loop) {
      var self = this;

      if (typeof loop === 'boolean') {
        self._loop = loop;

        return self;
      } else {
        return self._loop;
      }
    },

    /**
     * Get/set sound sprite definition.
     * @param  {Object} sprite Example: {spriteName: [offset, duration, loop]}
     *                @param {Integer} offset   Where to begin playback in milliseconds
     *                @param {Integer} duration How long to play in milliseconds
     *                @param {Boolean} loop     (optional) Set true to loop this sprite
     * @return {Howl}        Returns current sprite sheet or self.
     */
    sprite: function (sprite) {
      var self = this;

      if (typeof sprite === 'object') {
        self._sprite = sprite;

        return self;
      } else {
        return self._sprite;
      }
    },

    /**
     * Get/set the position of playback.
     * @param  {Float}  pos The position to move current playback to.
     * @param  {String} id  (optional) The play instance ID.
     * @return {Howl/Float}      Returns self or current playback position.
     */
    pos: function (pos, id) {
      var self = this;

      // if the sound hasn't been loaded, add it to the event queue
      if (!self._loaded) {
        self.on('load', function () {
          self.pos(pos);
        });

        return typeof pos === 'number' ? self : self._pos || 0;
      }

      // make sure we are dealing with a number for pos
      pos = parseFloat(pos);

      var activeNode = (id) ? self._nodeById(id) : self._activeNode();
      if (activeNode) {
        if (pos >= 0) {
          self.pause(id);
          activeNode._pos = pos;
          self.play(activeNode._sprite, id);

          return self;
        } else {
          return self._webAudio ? activeNode._pos + (ctx.currentTime - self._playStart) : activeNode.currentTime;
        }
      } else if (pos >= 0) {
        return self;
      } else {
        // find the first inactive node to return the pos for
        for (var i = 0; i < self._audioNode.length; i++) {
          if (self._audioNode[i].paused && self._audioNode[i].readyState === 4) {
            return (self._webAudio) ? self._audioNode[i]._pos : self._audioNode[i].currentTime;
          }
        }
      }
    },

    /**
     * Get/set the 3D position of the audio source.
     * The most common usage is to set the 'x' position
     * to affect the left/right ear panning. Setting any value higher than
     * 1.0 will begin to decrease the volume of the sound as it moves further away.
     * NOTE: This only works with Web Audio API, HTML5 Audio playback
     * will not be affected.
     * @param  {Float}  x  The x-position of the playback from -1000.0 to 1000.0
     * @param  {Float}  y  The y-position of the playback from -1000.0 to 1000.0
     * @param  {Float}  z  The z-position of the playback from -1000.0 to 1000.0
     * @param  {String} id (optional) The play instance ID.
     * @return {Howl/Array}   Returns self or the current 3D position: [x, y, z]
     */
    pos3d: function (x, y, z, id) {
      var self = this;

      // set a default for the optional 'y' & 'z'
      y = (typeof y === 'undefined' || !y) ? 0 : y;
      z = (typeof z === 'undefined' || !z) ? -0.5 : z;

      // if the sound hasn't been loaded, add it to the event queue
      if (!self._loaded) {
        self.on('play', function () {
          self.pos3d(x, y, z, id);
        });

        return self;
      }

      if (x >= 0 || x < 0) {
        if (self._webAudio) {
          var activeNode = (id) ? self._nodeById(id) : self._activeNode();
          if (activeNode) {
            self._pos3d = [x, y, z];
            activeNode.panner.setPosition(x, y, z);
            activeNode.panner.panningModel = self._model || 'HRTF';
          }
        }
      } else {
        return self._pos3d;
      }

      return self;
    },

    /**
     * Fade a currently playing sound between two volumes.
     * @param  {Number}   from     The volume to fade from (0.0 to 1.0).
     * @param  {Number}   to       The volume to fade to (0.0 to 1.0).
     * @param  {Number}   len      Time in milliseconds to fade.
     * @param  {Function} callback (optional) Fired when the fade is complete.
     * @param  {String}   id       (optional) The play instance ID.
     * @return {Howl}
     */
    fade: function (from, to, len, callback, id) {
      var self = this,
        diff = Math.abs(from - to),
        dir = from > to ? 'down' : 'up',
        steps = diff / 0.01,
        stepTime = len / steps;

      // if the sound hasn't been loaded, add it to the event queue
      if (!self._loaded) {
        self.on('load', function () {
          self.fade(from, to, len, callback, id);
        });

        return self;
      }

      // set the volume to the start position
      self.volume(from, id);

      for (var i = 1; i <= steps; i++) {
        (function () {
          var change = self._volume + (dir === 'up' ? 0.01 : -0.01) * i,
            vol = Math.round(1000 * change) / 1000,
            toVol = to;

          setTimeout(function () {
            self.volume(vol, id);

            if (vol === toVol) {
              if (callback) callback();
            }
          }, stepTime * i);
        })();
      }
    },

    /**
     * [DEPRECATED] Fade in the current sound.
     * @param  {Float}    to      Volume to fade to (0.0 to 1.0).
     * @param  {Number}   len     Time in milliseconds to fade.
     * @param  {Function} callback
     * @return {Howl}
     */
    fadeIn: function (to, len, callback) {
      return this.volume(0).play().fade(0, to, len, callback);
    },

    /**
     * [DEPRECATED] Fade out the current sound and pause when finished.
     * @param  {Float}    to       Volume to fade to (0.0 to 1.0).
     * @param  {Number}   len      Time in milliseconds to fade.
     * @param  {Function} callback
     * @param  {String}   id       (optional) The play instance ID.
     * @return {Howl}
     */
    fadeOut: function (to, len, callback, id) {
      var self = this;

      return self.fade(self._volume, to, len, function () {
        if (callback) callback();
        self.pause(id);

        // fire ended event
        self.on('end');
      }, id);
    },

    /**
     * Get an audio node by ID.
     * @return {Howl} Audio node.
     */
    _nodeById: function (id) {
      var self = this,
        node = self._audioNode[0];

      // find the node with this ID
      for (var i = 0; i < self._audioNode.length; i++) {
        if (self._audioNode[i].id === id) {
          node = self._audioNode[i];
          break;
        }
      }

      return node;
    },

    /**
     * Get the first active audio node.
     * @return {Howl} Audio node.
     */
    _activeNode: function () {
      var self = this,
        node = null;

      // find the first playing node
      for (var i = 0; i < self._audioNode.length; i++) {
        if (!self._audioNode[i].paused) {
          node = self._audioNode[i];
          break;
        }
      }

      // remove excess inactive nodes
      self._drainPool();

      return node;
    },

    /**
     * Get the first inactive audio node.
     * If there is none, create a new one and add it to the pool.
     * @param  {Function} callback Function to call when the audio node is ready.
     */
    _inactiveNode: function (callback) {
      var self = this,
        node = null;

      // find first inactive node to recycle
      for (var i = 0; i < self._audioNode.length; i++) {
        if (self._audioNode[i].paused && self._audioNode[i].readyState === 4) {
          // send the node back for use by the new play instance
          callback(self._audioNode[i]);
          node = true;
          break;
        }
      }

      // remove excess inactive nodes
      self._drainPool();

      if (node) {
        return;
      }

      // create new node if there are no inactives
      var newNode;
      if (self._webAudio) {
        newNode = self._setupAudioNode();
        callback(newNode);
      } else {
        self.load();
        newNode = self._audioNode[self._audioNode.length - 1];

        // listen for the correct load event and fire the callback
        var listenerEvent = navigator.isCocoonJS ? 'canplaythrough' : 'loadedmetadata';
        var listener = function () {
          newNode.removeEventListener(listenerEvent, listener, false);
          callback(newNode);
        };
        newNode.addEventListener(listenerEvent, listener, false);
      }
    },

    /**
     * If there are more than 5 inactive audio nodes in the pool, clear out the rest.
     */
    _drainPool: function () {
      var self = this,
        inactive = 0,
        i;

      // count the number of inactive nodes
      for (i = 0; i < self._audioNode.length; i++) {
        if (self._audioNode[i].paused) {
          inactive++;
        }
      }

      // remove excess inactive nodes
      for (i = self._audioNode.length - 1; i >= 0; i--) {
        if (inactive <= 5) {
          break;
        }

        if (self._audioNode[i].paused) {
          // disconnect the audio source if using Web Audio
          if (self._webAudio) {
            self._audioNode[i].disconnect(0);
          }

          inactive--;
          self._audioNode.splice(i, 1);
        }
      }
    },

    /**
     * Clear 'onend' timeout before it ends.
     * @param  {String} soundId  The play instance ID.
     */
    _clearEndTimer: function (soundId) {
      var self = this,
        index = 0;

      // loop through the timers to find the one associated with this sound
      for (var i = 0; i < self._onendTimer.length; i++) {
        if (self._onendTimer[i].id === soundId) {
          index = i;
          break;
        }
      }

      var timer = self._onendTimer[index];
      if (timer) {
        clearTimeout(timer.timer);
        self._onendTimer.splice(index, 1);
      }
    },

    /**
     * Setup the gain node and panner for a Web Audio instance.
     * @return {Object} The new audio node.
     */
    _setupAudioNode: function () {
      var self = this,
        node = self._audioNode,
        index = self._audioNode.length;

      // create gain node
      node[index] = (typeof ctx.createGain === 'undefined') ? ctx.createGainNode() : ctx.createGain();
      node[index].gain.value = self._volume;
      node[index].paused = true;
      node[index]._pos = 0;
      node[index].readyState = 4;
      node[index].connect(masterGain);

      // create the panner
      node[index].panner = ctx.createPanner();
      node[index].panner.panningModel = self._model || 'equalpower';
      node[index].panner.setPosition(self._pos3d[0], self._pos3d[1], self._pos3d[2]);
      node[index].panner.connect(node[index]);

      return node[index];
    },

    /**
     * Call/set custom events.
     * @param  {String}   event Event type.
     * @param  {Function} fn    Function to call.
     * @return {Howl}
     */
    on: function (event, fn) {
      var self = this,
        events = self['_on' + event];

      if (typeof fn === 'function') {
        events.push(fn);
      } else {
        for (var i = 0; i < events.length; i++) {
          if (fn) {
            events[i].call(self, fn);
          } else {
            events[i].call(self);
          }
        }
      }

      return self;
    },

    /**
     * Remove a custom event.
     * @param  {String}   event Event type.
     * @param  {Function} fn    Listener to remove.
     * @return {Howl}
     */
    off: function (event, fn) {
      var self = this,
        events = self['_on' + event],
        fnString = fn ? fn.toString() : null;

      if (fnString) {
        // loop through functions in the event for comparison
        for (var i = 0; i < events.length; i++) {
          if (fnString === events[i].toString()) {
            events.splice(i, 1);
            break;
          }
        }
      } else {
        self['_on' + event] = [];
      }

      return self;
    },

    /**
     * Unload and destroy the current Howl object.
     * This will immediately stop all play instances attached to this sound.
     */
    unload: function () {
      var self = this;

      // stop playing any active nodes
      var nodes = self._audioNode;
      for (var i = 0; i < self._audioNode.length; i++) {
        // stop the sound if it is currently playing
        if (!nodes[i].paused) {
          self.stop(nodes[i].id);
          self.on('end', nodes[i].id);
        }

        if (!self._webAudio) {
          // remove the source if using HTML5 Audio
          nodes[i].src = '';
        } else {
          // disconnect the output from the master gain
          nodes[i].disconnect(0);
        }
      }

      // make sure all timeouts are cleared
      for (i = 0; i < self._onendTimer.length; i++) {
        clearTimeout(self._onendTimer[i].timer);
      }

      // remove the reference in the global Howler object
      var index = Howler._howls.indexOf(self);
      if (index !== null && index >= 0) {
        Howler._howls.splice(index, 1);
      }

      // delete this sound from the cache
      delete cache[self._src];
      self = null;
    }

  };

  // only define these functions when using WebAudio
  if (usingWebAudio) {

    /**
     * Buffer a sound from URL (or from cache) and decode to audio source (Web Audio API).
     * @param  {Object} obj The Howl object for the sound to load.
     * @param  {String} url The path to the sound file.
     */
    var loadBuffer = function (obj, url) {
      // check if the buffer has already been cached
      if (url in cache) {
        // set the duration from the cache
        obj._duration = cache[url].duration;

        // load the sound into this object
        loadSound(obj);
        return;
      }

      if (/^data:[^;]+;base64,/.test(url)) {
        // Decode base64 data-URIs because some browsers cannot load data-URIs with XMLHttpRequest.
        var data = atob(url.split(',')[1]);
        var dataView = new Uint8Array(data.length);
        for (var i = 0; i < data.length; ++i) {
          dataView[i] = data.charCodeAt(i);
        }

        decodeAudioData(dataView.buffer, obj, url);
      } else {
        // load the buffer from the URL
        var xhr = new XMLHttpRequest();
        xhr.open('GET', url, true);
        xhr.responseType = 'arraybuffer';
        xhr.onload = function () {
          decodeAudioData(xhr.response, obj, url);
        };
        xhr.onerror = function () {
          // if there is an error, switch the sound to HTML Audio
          if (obj._webAudio) {
            obj._buffer = true;
            obj._webAudio = false;
            obj._audioNode = [];
            delete obj._gainNode;
            delete cache[url];
            obj.load();
          }
        };
        try {
          xhr.send();
        } catch (e) {
          xhr.onerror();
        }
      }
    };

    /**
     * Decode audio data from an array buffer.
     * @param  {ArrayBuffer} arraybuffer The audio data.
     * @param  {Object} obj The Howl object for the sound to load.
     * @param  {String} url The path to the sound file.
     */
    var decodeAudioData = function (arraybuffer, obj, url) {
      // decode the buffer into an audio source
      ctx.decodeAudioData(
        arraybuffer,
        function (buffer) {
          if (buffer) {
            cache[url] = buffer;
            loadSound(obj, buffer);
          }
        },
        function (err) {
          obj.on('loaderror');
        }
      );
    };

    /**
     * Finishes loading the Web Audio API sound and fires the loaded event
     * @param  {Object}  obj    The Howl object for the sound to load.
     * @param  {Objecct} buffer The decoded buffer sound source.
     */
    var loadSound = function (obj, buffer) {
      // set the duration
      obj._duration = (buffer) ? buffer.duration : obj._duration;

      // setup a sprite if none is defined
      if (Object.getOwnPropertyNames(obj._sprite).length === 0) {
        obj._sprite = { _default: [0, obj._duration * 1000] };
      }

      // fire the loaded event
      if (!obj._loaded) {
        obj._loaded = true;
        obj.on('load');
      }

      if (obj._autoplay) {
        obj.play();
      }
    };

    /**
     * Load the sound back into the buffer source.
     * @param  {Object} obj   The sound to load.
     * @param  {Array}  loop  Loop boolean, pos, and duration.
     * @param  {String} id    (optional) The play instance ID.
     */
    var refreshBuffer = function (obj, loop, id) {
      // determine which node to connect to
      var node = obj._nodeById(id);

      // setup the buffer source for playback
      node.bufferSource = ctx.createBufferSource();
      node.bufferSource.buffer = cache[obj._src];
      node.bufferSource.connect(node.panner);
      node.bufferSource.loop = loop[0];
      if (loop[0]) {
        node.bufferSource.loopStart = loop[1];
        node.bufferSource.loopEnd = loop[1] + loop[2];
      }
      node.bufferSource.playbackRate.value = obj._rate;
    };

  }

  /**
   * Add support for AMD (Asynchronous Module Definition) libraries such as require.js.
   */
  if (typeof define === 'function' && define.amd) {
    define(function () {
      return {
        Howler: Howler,
        Howl: Howl
      };
    });
  }

  /**
   * Add support for CommonJS libraries such as browserify.
   */
  if (typeof exports !== 'undefined') {
    exports.Howler = Howler;
    exports.Howl = Howl;
  }

  // define globally in case AMD is not available or available but not used

  if (typeof window !== 'undefined') {
    window.Howler = Howler;
    window.Howl = Howl;
  }

})();
},{}]},{},[8]);
