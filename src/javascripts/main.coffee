prop = (attr) ->
  (d) -> d[attr]

staffWidth = 800
staffHeight= 120

lineData = [
  { x: 0, y: 0}, { x: staffWidth, y: 0}
]

verticalLine = [
  { x: 0, y: 40 }, { x: 0, y: staffHeight }
]

d3 = require("d3")
line = d3.svg.line()
  .x(prop("x"))
  .y(prop("y"))
  .interpolate("linear")

$svg = d3.select(".beatkeeper__notation")
$lineContainers = d3.selectAll(".beatkeeper__instrument-line")

$lineContainers.append("path")
  .attr("d", line(lineData))
  .attr("stroke", "blue")
  .attr("stroke-width", 2)
  .attr("fill", "none")

divisions = 8
subdivisionIncrements = staffWidth / divisions
[0..divisions].forEach (n) ->
  $svg.append("path")
    .attr("stroke", "blue")
    .attr("stroke-width", 2)
    .attr("fill", "none")
    .attr "d", (d) ->
      data = [{
        x: verticalLine[0].x + (subdivisionIncrements * n)
        y: verticalLine[0].y
      }, {
        x: verticalLine[1].x + (subdivisionIncrements * n)
        y: verticalLine[1].y
      }]

      line(data)
