rand = (min, max) -> min + (Math.random() * (max - min))

class Star
  constructor: (@w, @h) -> @reset()
  reset: ->
    @x = rand 0, @w
    @y = rand 0, @h
    @alpha = rand(0, 100) * 0.01
    @size = rand 3, 8
    @color = 'white'
    @speed = rand 4, 12
  draw: (ctx) ->
    @y -= @speed
    @reset() if @y < 0
    {x, y, size, color, alpha} = @
    ctx.save()
    ctx.globalAlpha = alpha
    ctx.fillStyle = color
    ctx.fillRect x, y, size, size
    ctx.restore()

class StarfieldDemo
  constructor: ->
    @createCanvas()
    @createStarfield()
    @startDemo()

  createCanvas: ->
    @canvas = canvas = document.createElement 'canvas'
    @width = canvas.width = window.innerWidth
    @height = canvas.height = window.innerHeight
    canvas.style.position = 'absolute'
    canvas.style.top = '0px'
    canvas.style.left = '0px'
    @ctx = ctx = canvas.getContext '2d'
    @backgroundColor = '#204060'
    @scale = x: 1, y: 1
    document.body.appendChild canvas
    onResize = ->
      canvas.width = window.innerWidth
      canvas.height = window.innerHeight
      scaleX = canvas.width / @width
      scaleY = canvas.height / @height
      @scale = x: scaleX, y: scaleY
    onResize = onResize.bind @
    window.addEventListener 'resize', onResize, false

  createStarfield: ->
    {width, height} = @
    NUM_STARS = 250
    @stars = (new Star(width, height*2) for n in [0...NUM_STARS])

  startDemo: ->
    document.title = 'barebones-coffee StarfieldDemo'
    draw = @draw.bind @
    mainLoop = ->
      window.requestAnimationFrame mainLoop
      draw()
    mainLoop()

  draw: ->
    {ctx, canvas, scale, stars, backgroundColor} = @
    {width, height} = canvas
    ctx.fillStyle = backgroundColor
    ctx.fillRect 0, 0, width, height
    ctx.save()
    ctx.scale scale.x, scale.y
    star.draw ctx for star in stars
    ctx.fillStyle = 'white'
    ctx.textAlign = 'center'
    ctx.textBaseline = 'middle'
    ctx.font = 'bold 96px sans-serif'
    message = 'barebones-coffee StarfieldDemo'
    ctx.fillText message, width * 0.5 | 0, height * 0.5 | 0
    ctx.restore()

module.exports = StarfieldDemo: StarfieldDemo

