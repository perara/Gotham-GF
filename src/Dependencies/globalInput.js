/*https://github.com/anvaka/ngraph/blob/master/examples/pixi.js/03%20-%20Zoom%20And%20Pan/globalInput.js*/
module.exports = function (graphics, updateCallback) {
    var addWheelListener = require('./addWheelListener');
    var graphGraphics = graphics;

    var domContainer = window.GothamGame.renderer.pixi.view


    addWheelListener(domContainer, function (e) {
        zoom(e.clientX, e.clientY, e.deltaY < 0);
    });

    addDragNDrop();

    var getGraphCoordinates = (function () {
        var ctx = {
            global: { x: 0, y: 0} // store it inside closure to avoid GC pressure
        };

        return function (x, y) {
            ctx.global.x = x; ctx.global.y = y;
            return PIXI.InteractionData.prototype.getLocalPosition.call(ctx, graphGraphics);
        }
    }());

    function zoom(x, y, isZoomIn) {
        direction = isZoomIn ? 1 : -1;
        var factor = (1 + direction * 0.1);

        updateCallback(factor)

        var mapMiddle = {
            x: graphics._size.width / 2,
            y: graphics._size.height / 2
        }
        var mouseData = graphics._lastMousePosition

        /*var diffMovement = {
         x: mouseData.x - mapMiddle.x,
         y: mouseData.y - mapMiddle.y
         }*/

        console.log(mouseData)

        graphics.scale.x *= factor;
        graphics.scale.y *= factor;


        // Zoom each of the children
        for (i = 0; i < graphGraphics.children.length; i++){
            var graphicsObj = graphGraphics.children[i];

            //graphicsObj.scale.x *= factor;
            //graphicsObj.scale.y *= factor;

            // Technically code below is not required, but helps to zoom on mouse
            // cursor, instead center of graphGraphics coordinates
            /*var beforeTransform = getGraphCoordinates(x, y);
             graphicsObj.updateTransform();
             var afterTransform = getGraphCoordinates(x, y);

             graphicsObj.position.x += ((afterTransform.x - beforeTransform.x) * graphicsObj.scale.x) - (diffMovement.x*direction) // - (40*direction)
             graphicsObj.position.y += ((afterTransform.y - beforeTransform.y) * graphicsObj.scale.y) - (diffMovement.y*direction)// - (40*direction)*/

            graphicsObj.updateTransform();
        }

    }

    function addDragNDrop() {
        var stage = graphics.stage;
        console.log(graphics)
        stage.interactive = true;

        var isDragging = false,
            prevX, prevY;

        stage.mousedown = function (moveData) {
            var pos = moveData.global;
            prevX = pos.x; prevY = pos.y;
            isDragging = true;
        };

        stage.mousemove = function (moveData) {
            if (!isDragging) {
                return;
            }
            var pos = moveData.global;
            var dx = pos.x - prevX;
            var dy = pos.y - prevY;


            graphics.position.x += dx;
            graphics.position.y += dy;

            prevX = pos.x; prevY = pos.y;
        };

        stage.mouseup = function (moveDate) {
            isDragging = false;
        };
    }
}