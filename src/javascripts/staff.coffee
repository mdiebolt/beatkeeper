d3 = require("d3")

prop = (attr) ->
  (d) ->
    d[attr]

# Size staff dynamically. Sidebar is 300px
staffWidth = window.innerWidth - 300
staffHeight = 120

strokeWidth = 2
lineData = [
  { x: 0, y: 0 }, { x: staffWidth, y: 0 }
]

playbackLine = [
  { x: 0, y: 40 }
  { x: 0, y: staffHeight }
]

divisions = 16
subdivisionIncrements = staffWidth / divisions
verticalLines = [0..divisions].map (n) ->
  x = n * subdivisionIncrements

  [
    { x: x, y: 40 }
    { x: x, y: staffHeight }
  ]

line = d3.svg.line()
  .x(prop("x"))
  .y(prop("y"))

$svg = d3.select(".beatkeeper__notation").attr
  width: staffWidth
  height: staffHeight

$lineContainers = d3.selectAll(".beatkeeper__instrument")

createInstrumentLines = ->
  $lineContainers.append("path")
    .attr("d", line(lineData))
    .attr("stroke", "blue")
    .attr("stroke-width", strokeWidth)
    .attr("fill", "none")

createSubdivisionLines = ->
  d3.select(".beatkeeper__subdivisions").selectAll("path")
    .data(verticalLines)
    .enter()
    .append("path")
      .attr("d", line)
      .attr("stroke", "blue")
      .attr("stroke-width", strokeWidth)
      .attr("fill", "none")

createPlaybackLine = ->
  d3.select(".beatkeeper__playback").selectAll("path")
    .data(playbackLine)
    .enter()
    .append("path")
      .attr("d", line(playbackLine))
      .attr("stroke", "red")
      .attr("stroke-width", strokeWidth)
      .attr("fill", "none")

updatePlaybackLine = (data) ->
  playbackLine = data
  $playback = d3.select(".beatkeeper__playback")
  $playback.data(playbackLine)
  $playback.selectAll("path").attr("d", line(playbackLine))

module.exports =
  create: ->
    createInstrumentLines()
    createSubdivisionLines()
    createPlaybackLine()

  update: (data) ->
    updatePlaybackLine(data)
