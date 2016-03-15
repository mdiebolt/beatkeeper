d3 = require("d3")
beats = require("beat_data")
require("load_buffers")
window.player = require("playback")

prop = (attr) ->
  (d) ->
    d[attr]

staffWidth = 800
staffHeight= 120

lineData = [
  { x: 0, y: 0}, { x: staffWidth, y: 0}
]

divisions = 8
subdivisionIncrements = staffWidth / divisions
verticalLines = [0..divisions].map (n) ->
  x = n * subdivisionIncrements
  [{ x: x, y: 40 }, { x: x, y: staffHeight }]

line = d3.svg.line()
  .x(prop("x"))
  .y(prop("y"))
  .interpolate("linear")

$svg = d3.select(".beatkeeper__notation")
$lineContainers = d3.selectAll(".beatkeeper__instrument")

# Draw instrument lines
$lineContainers.append("path")
  .attr("d", line(lineData))
  .attr("stroke", "blue")
  .attr("stroke-width", 2)
  .attr("fill", "none")

# Draw subdivision lines
d3.select(".beatkeeper__subdivisions").selectAll("path")
  .data(verticalLines)
  .enter()
  .append("path")
    .attr("d", line)
    .attr("stroke", "blue")
    .attr("stroke-width", 2)
    .attr("fill", "none")

# Draw loop navigation
$loops = d3.select(".beatkeeper__loops").selectAll("div")
  .data(beats)

$loop = $loops.enter().append("div").attr("class", "beatkeeper__loop")
$loop.append("div").attr("class", "beatkeeper__loop-number").text (d, i) -> "#{i + 1}."
$loop.append("div").attr("class", "beatkeeper__loop-preview")
$loop.append("div").attr("class", "beatkeeper__loop-name").text (d) -> d.name
$loop.append("div").attr("class", "beatkeeper__loop-listen")
