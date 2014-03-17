d3 = require('d3')
$ = require('jquery')

# globals

# Axis prep

# My world is [0,1]x[0,1]

# flaps
# starting position
flapFn = (t, h) ->
  (x) ->
    -flapHeight * Math.pow(x - t - flapWidth, 2) / Math.pow(flapWidth, 2) + h + flapHeight
step = ->
  time += stepWidth
  x.domain [
    time - timeLeft
    time + timeRight
  ]
  xAxisGroup.call xAxis.scale(x)
  lastFlap = flaps[flaps.length - 1]
  lastFlapFn = flapFn(lastFlap.t, lastFlap.h)
  
  # make array of flaplinedata
  if flaps.length > 1
    succedingFlaps = d3.zip(flaps.slice(0, flaps.length - 1), flaps.slice(1, flaps.length))
    previousFlapsData = succedingFlaps.map((flaps) ->
      flapLineData = []
      flapLineData.push
        x: flaps[0].t
        y: flaps[0].h

      if flaps[0].t + flapWidth < flaps[1].t
        flapLineData.push
          x: flaps[0].t + flapWidth
          y: flaps[0].h + flapHeight

      flapLineData.push
        x: flaps[1].t
        y: flaps[1].h

      flapLineData
    )
    preFlaps = svg.selectAll("path.previous-flaps").data(previousFlapsData)
    preFlaps.enter().append("path").attr "class", "previous-flaps"
    preFlaps.attr "d", d3.svg.line().interpolate("step").x((d) ->
      x d.x
    ).y((d) ->
      y d.y
    )
  tailData = [lastFlap.t]
  if lastFlap.t + flapWidth > time
    tailData.push time
  else
    tailData.push lastFlap.t + flapWidth
    tailData.push time
  tailGen = d3.svg.line().interpolate("step").x((d) ->
    x d
  ).y((d) ->
    y lastFlapFn(d)
  )
  tail.datum(tailData).attr "d", tailGen
  point.datum(time).attr("cx", (t) ->
    x t
  ).attr "cy", (t) ->
    y lastFlapFn(t)

  setTimeout step, wait
  return
flap = ->
  lastFlap = flaps[flaps.length - 1]
  lastFlapFn = flapFn(lastFlap.t, lastFlap.h)
  currentHeight = lastFlapFn(time)
  flaps.push
    t: time
    h: currentHeight

  return
margin =
  top: 20
  right: 20
  bottom: 30
  left: 40

width = 750 - margin.left - margin.right
height = 500 - margin.top - margin.bottom
svg = d3.select("body").append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")")
time = 0
fps = 30
wait = 1000 / fps
stepWidth = 0.02
startHeight = 0.5
timeLeft = 0.6
timeRight = 0.4

x = d3.scale.linear().range([
  0
  width
]).domain([
  time - timeLeft
  time + timeRight
])
y = d3.scale.linear().range([
  height
  0
]).domain([
  0
  1
])
xAxis = d3.svg.axis().scale(x).orient("bottom")
yAxis = d3.svg.axis().scale(y).orient("left")
xAxisGroup = svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call(xAxis)
svg.append("g").attr("class", "y axis").call yAxis
flapWidth = 0.2
flapHeight = 0.2
flaps = [
  t: 0
  h: startHeight
]
tail = svg.append("path").attr("class", "flappy-line")
point = svg.append("circle").attr("r", "10").attr("cx", ->
  x time
).attr("cy", ->
  y startHeight
)
$(document).on "keydown", ->
  $(document).off "keydown"
  $(document).on "keydown", flap
  step()
  return