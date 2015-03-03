randomNum = (min, max)  ->
   Math.floor(Math.random() * (max - min) + min)
randomFloat = (min, max)  ->
   Math.random() * (max - min) + min

distance2D = (x1, y1, x2, y2) ->
  x = x1 - x2
  y = y1 - y2
  Math.sqrt((x * x) + (y * y))

class World
  constructor: ->
    @updateCanvasSize()

    @stage = new createjs.Stage('effect_canvas')
    @stage.alpha = 0.9

    @connectors = []
    for i in [1..120]
      connector = new Connector(@stage)
      @connectors.push connector

    @txt = new createjs.Text("", "16px Arial", "black");
    @txt.x = @txt.y = 50
    @txt.lineWidth = 550
    @txt.lineHeight = 20
    @txt.textAlign = "left"
    @txt.textBaseline = "top"
    @stage.addChild(@txt)

    @distanceOfLineDrawing = 100

  sortByZ: (a, b) ->
    a.zIndex - b.zIndex

  updateCanvasSize: ->
    canvas = $('#effect_canvas')[0]
    canvas.width = $('#effect_canvas').width()
    canvas.height = $('#effect_canvas').height()

  render: ->
    @updateCanvasSize()
    @stage.sortChildren(@sortByZ)
    @stage.update()
    if false
      @txt.text = "FPS: " + createjs.Ticker.getMeasuredFPS()
      # @txt.text += "\nConnector 0: [" + @connectors[0].shape.x + ", " + @connectors[0].shape.y + "]"
      # @txt.text += "\nConnector 1: [" + @connectors[1].shape.x + ", " + @connectors[1].shape.y + "]"
      lineCount = 0
      lineCount += connector.lines.length for connector in @connectors
      @txt.text += "\nLine count: " + lineCount
      # if lineCount > 0
      #   @txt.text += "\nLine 0-0: [" + @connectors[0].lines[0].connector1.shape.x + ", " + @connectors[0].lines[0].connector1.shape.y + "]"
      #   @txt.text += "\nLine 0-1: [" + @connectors[0].lines[0].connector2.shape.x + ", " + @connectors[0].lines[0].connector2.shape.y + "]"

    for connector, i in @connectors
      connector.update(@distanceOfLineDrawing)
      connector.render()

      nearOne = false
      for otherConnector, j in @connectors
        unless i == j # don't compare a connector to itself
          if distance2D(connector.shape.x, connector.shape.y, otherConnector.shape.x, otherConnector.shape.y) < @distanceOfLineDrawing
            connector.makeLineTo(@stage, otherConnector)
            nearOne = true

class Line
  constructor: (stage, connector1, connector2) ->
    @stage = stage
    @shape = new createjs.Shape()
    @shape.zIndex = 0
    @connector1 = connector1
    @connector2 = connector2
    @redrawShape()
    @stage.addChild(@shape)

  clear: ->
    @shape.graphics.clear()
    @stage.removeChild(@shape)

  redrawShape: ->

  render: ->
    @shape.graphics.clear()
    @shape.graphics.setStrokeStyle(1)
    @shape.graphics.beginStroke('rgba(211, 111, 111, 0.2')
    @shape.graphics.moveTo(@connector1.shape.x, @connector1.shape.y)
    @shape.graphics.lineTo(@connector2.shape.x, @connector2.shape.y)
    @shape.graphics.endStroke()

class Connector
  constructor: (stage) ->
    @stage = stage
    @shape = new createjs.Shape()
    @regenerateConnector()

  makeLineTo: (stage, otherConnector) ->
    # only make this line if it doesn't exist already for this connection
    exists = false
    for line in @lines
      if line.connector2 == otherConnector
        exists = true

    if not exists
      line = new Line(stage, this, otherConnector)
      @lines.push(line)

  update: (distanceOfLineDrawing) ->
    @shape.x = @shape.x + @velocityX
    @shape.y = @shape.y + @velocityY

    @checkNearOther()
    @checkOutsideBoundaries()
    @checkLostConnections(distanceOfLineDrawing)

  checkOutsideBoundaries: ->
    padding = 25 # how far offscreen before deletion?
    if (@shape.x < 0 - padding) or
    (@shape.x > @stage.canvas.width + padding) or
    (@shape.y < 0 - padding) or
    (@shape.y > @stage.canvas.height + padding)
      @regenerateConnector()

  regenerateConnector: ->
    @shape.zIndex = 1
    @shape.x = randomNum(0, @stage.canvas.width)
    @shape.y = randomNum(0, @stage.canvas.height)

    layer = randomNum(1, 3)

    # if "layer" is 1, then it's far in background, and also moves relatively slow
    @shape.radius = layer
    @speed = layer * 1.5

    # @shape.radius = randomNum(2, 2)
    # @speed = randomFloat(1.5, 3)
    @directionAngle = randomNum(0, 360)
    @velocityX = @speed * Math.cos(@directionAngle)
    @velocityY = @speed * Math.sin(@directionAngle)

    @stage.addChild(@shape)
    @redrawShape()

    if @lines?
      for line in @lines
        line.clear()

    @lines = []

  checkNearOther: ->
    # color connector based on if it has any connections
    if @lines? and @lines.length > 0 # has connections
      @color = 'rgba(211, 111, 111, 1)'
    else # not connected
      @color = 'rgba(0, 0, 0, 1)'
    @redrawShape()

  checkLostConnections: (distanceOfLineDrawing) ->
    # check for lost connections to other connectors
    linesToDelete = []
    for line, index in @lines
      if not line.connector2?
        # other connector disappeared; maybe went off edge of screen
        linesToDelete.push(index)
      else if line? and distance2D(line.connector1.shape.x, line.connector1.shape.y, line.connector2.shape.x, line.connector2.shape.y) > distanceOfLineDrawing
        # lost connection, need to delete this line
        linesToDelete.push(index)

    counter = 0
    while counter < @lines.length
      if counter in linesToDelete
        @lines[counter].clear()
        @lines.splice(counter, 1)
      else
        counter += 1

  redrawShape: ->
    @shape.graphics.clear()
    @shape.graphics.beginFill(@color)
    @shape.graphics.drawCircle(0, 0, @shape.radius)

  render: ->
    for line in @lines
      line.render()

$ ->
  world = new World()

  logicLoop = (event) ->
    if(!event.paused)
      world.render()

  createjs.Ticker.setFPS(23);
  createjs.Ticker.addEventListener("tick", logicLoop)
