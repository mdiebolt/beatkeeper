d3 = require("d3")
beats = require("beat_data")
player = require("player")

$loops = d3.select(".beatkeeper__loops").selectAll("div").data(beats)

playPattern = (data) ->
  player.play(data.pattern)

createPlaybackButtons = ($parent) ->
  $parent
    .append("button")
      .attr("class", "beatkeeper__loop-listen")
      .on("click", playPattern)
      .attr "data-number", (d, index) ->
        index + 1

createLoopPreviews = ($parent) ->
  $parent
    .append("div")
      .attr
        class: "beatkeeper__loop-preview"
        "data-name": (d) ->
          d.name

createLoops = ->
  $loop = $loops.enter()
    .append("div")
      .attr("class", "beatkeeper__loop")

  createPlaybackButtons($loop)
  createLoopPreviews($loop)

module.exports =
  create: createLoops
