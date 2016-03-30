d3 = require("d3")

instrumentLines = [
  [{ x: 0, y: 0 }, { x: STAFF_WIDTH, y: 0 }]
  [{ x: 0, y: 0 }, { x: STAFF_WIDTH, y: 0 }]
  [{ x: 0, y: 0 }, { x: STAFF_WIDTH, y: 0 }]
]

playbackLine = [
  { x: 0, y: 0 }
  { x: 0, y: INSTRUMENT_LINE_HEIGHT * 4 }
]

beatNotes = []

subdivision = 8
subdivisionIncrements = STAFF_WIDTH / subdivision
verticalLines = [0..subdivision].map (n) ->
  x = n * subdivisionIncrements

  unless n == subdivision
    beatNotes.push { x: x, y: INSTRUMENT_LINE_HEIGHT, round: 2, size: 30, patternLink: "#hh-thumbnail", class: "hh" }
    beatNotes.push { x: x, y: INSTRUMENT_LINE_HEIGHT * 2, round: 2, size: 30, patternLink: "#snare-thumbnail", class: "snare" }
    beatNotes.push { x: x, y: INSTRUMENT_LINE_HEIGHT * 3, round: 2, size: 30, patternLink: "#kick-thumbnail", class: "kick" }

  [{ x: x, y: INSTRUMENT_LINE_HEIGHT }, { x: x, y: INSTRUMENT_LINE_HEIGHT * 3 }]

line = d3.svg.line()
  .x((d) -> d.x)
  .y((d) -> d.y)

$marginContainer = d3.select(".beatkeeper__notation-container").attr
  transform: "translate(#{MARGIN},0)"

$svg = d3.select(".beatkeeper__notation").attr
  width: MAIN_WIDTH
  height: STAFF_HEIGHT

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
  $rect = d3.select(".beatkeeper__notes").selectAll("rect")
    .data(beatNotes)
    .enter()
    .append("rect")
      .attr
        class: (d) -> "beatkeeper__beat-note #{d.class}"
        x: (d) -> d.x - (d.size / 2)
        y: (d) -> d.y - (d.size / 2)
        width: (d) -> d.size
        height: (d) -> d.size
        rx: (d) -> d.round
        ry: (d) -> d.round

  $rect.on "click", (data) ->
    $el = d3.select(@)

    if $el.style("fill") in ["url(\"#hh-thumbnail\")", "url(\"#snare-thumbnail\")", "url(\"#kick-thumbnail\")"]
      $el.style "fill", "#eee"
    else
      $el.style "fill", (d) ->
        "url(#{d.patternLink})"

createPlaybackLine = ->
  d3.select(".beatkeeper__playback")
    .append("path")
      .attr("d", line(playbackLine))

updatePlaybackLine = (data) ->
  d3.select(".beatkeeper__playback").selectAll("path")
      .attr("d", line(data))

instrumentPattern = (instrument) ->
  arr = []
  activeFill = "url(\"##{instrument}-thumbnail\")"

  d3.selectAll(".beatkeeper__beat-note.#{instrument}").each ->
    if d3.select(@).style("fill") == activeFill
      arr.push "*"
    else
      arr.push "-"

  arr.join("")

check = ->
  pattern = """
    #{instrumentPattern("hh")}
    #{instrumentPattern("snare")}
    #{instrumentPattern("kick")}
  """

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

  update: updatePlaybackLine
  checkPattern: check
