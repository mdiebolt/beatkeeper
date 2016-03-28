d3 = require("d3")

# Size staff dynamically. Sidebar is 300px
staffWidth = window.innerWidth - 300 - (2 * MARGIN)
staffHeight = 160

instrumentLines = [
  [{ x: 0, y: 0 }, { x: staffWidth, y: 0 }]
  [{ x: 0, y: 0 }, { x: staffWidth, y: 0 }]
  [{ x: 0, y: 0 }, { x: staffWidth, y: 0 }]
]

playbackLine = [
  { x: 0, y: 0 }
  { x: 0, y: 160 }
]

beatSubmission = ""

beatNotes = []

divisions = 16
subdivisionIncrements = staffWidth / divisions
verticalLines = [0..divisions].map (n) ->
  x = n * subdivisionIncrements

  unless n == divisions
    beatNotes.push { x: x, y: 40, radius: 15, patternLink: "#hh-thumbnail", class: "high-hat" }
    beatNotes.push { x: x, y: 80, radius: 15, patternLink: "#snare-thumbnail", class: "snare" }
    beatNotes.push { x: x, y: 120, radius: 15, patternLink: "#kick-thumbnail", class: "kick" }

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
  height: staffHeight

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
        class: (d) -> "beatkeeper__beat-note #{d.class}"
        cx: (d) -> d.x
        cy: (d) -> d.y
        r: (d) -> d.radius

  $circle.on "click", (data) ->
    $el = d3.select(@)

    if $el.style("fill") in ["url(\"#hh-thumbnail\")", "url(\"#snare-thumbnail\")", "url(\"#kick-thumbnail\")"]
      $el.style "fill", "#eee"
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

check = ->
  hh = []
  snare = []
  kick = []

  d3.selectAll(".beatkeeper__beat-note.high-hat").each ->
    if d3.select(@).style("fill") == "url(\"#hh-thumbnail\")"
      hh.push "h"
    else
      hh.push "-"

  d3.selectAll(".beatkeeper__beat-note.snare").each ->
    if d3.select(@).style("fill") == "url(\"#snare-thumbnail\")"
      snare.push "s"
    else
      snare.push "-"

  d3.selectAll(".beatkeeper__beat-note.kick").each ->
    if d3.select(@).style("fill") == "url(\"#kick-thumbnail\")"
      kick.push "k"
    else
      kick.push "-"

  hhPattern = hh.join("").slice(0, 8)
  snarePattern = snare.join("").slice(0, 8)
  kickPattern = kick.join("").slice(0, 8)

  pattern = hhPattern + "\n" + snarePattern + "\n" + kickPattern

  if window.activePattern == pattern
    console.log "a match"
  else
    console.log "no match"

module.exports =
  create: ->
    createInstrumentLines()
    createSubdivisionLines()
    createPlaybackLine()
    createBeatNotes()

    d3.select(".beatkeeper__submit").on("click", check)

  update: (data) ->
    updatePlaybackLine(data)

  checkPattern: check
