d3 = require("d3")

# Size staff dynamically. Sidebar is 300px
staffWidth = window.innerWidth - 300 - (2 * MARGIN)
staffHeight = 120

instrumentLines = [
  [{ x: 0, y: 0 }, { x: staffWidth, y: 0 }]
  [{ x: 0, y: 0 }, { x: staffWidth, y: 0 }]
  [{ x: 0, y: 0 }, { x: staffWidth, y: 0 }]
]

playbackLine = [
  { x: 0, y: 40 }
  { x: 0, y: 120 }
]

beatNotes = []

divisions = 16
subdivisionIncrements = staffWidth / divisions
verticalLines = [0..divisions].map (n) ->
  x = n * subdivisionIncrements

  unless n == divisions
    beatNotes.push { x: x, y: 40, radius: 15, patternLink: "#hh-thumbnail" }
    beatNotes.push { x: x, y: 80, radius: 15, patternLink: "#snare-thumbnail" }
    beatNotes.push { x: x, y: 120, radius: 15, patternLink: "#kick-thumbnail" }

  [
    { x: x, y: 40 }
    { x: x, y: 120 }
  ]

line = d3.svg.line()
  .x((d) -> d.x)
  .y((d) -> d.y)

$marginContainer = d3.select(".beatkeeper__notation-container").attr
  transform: "translate(#{MARGIN},0)"

$svg = d3.select(".beatkeeper__notation").attr
  width: staffWidth + (2 * MARGIN)
  height: staffHeight + MARGIN

$lineContainers = d3.selectAll(".beatkeeper__instrument")

createInstrumentLines = ->
  $lineContainers
    .append("path")
      .data(instrumentLines)
      .attr("d", line)

createSubdivisionLines = ->
  d3.select(".beatkeeper__subdivisions").selectAll("path")
    .data(verticalLines)
    .enter()
    .append("path")
        .attr("d", line)

createBeatNotes = ->
  $circle = d3.select(".beatkeeper__notes").selectAll("circle")
    .data(beatNotes)
    .enter()
    .append("circle")
      .attr
        class: "beatkeeper__beat-note"
        cx: (d) -> d.x
        cy: (d) -> d.y
        r: (d) -> d.radius

  $circle.on "click", (data) ->
    $el = d3.select(@)

    if $el.style("fill") == "url(\"#hh-thumbnail\")"
      $el.style "fill", "rgba(100, 100, 100, 0.5)"
    else
      $el.style "fill", (d) ->
        "url(#{d.patternLink})"

createPlaybackLine = ->
  d3.select(".beatkeeper__playback").selectAll("path")
    .data(playbackLine)
    .enter()
    .append("path")
      .attr("d", line(playbackLine))

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
    createBeatNotes()

  update: (data) ->
    updatePlaybackLine(data)
