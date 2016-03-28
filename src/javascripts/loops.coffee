d3 = require("d3")
beats = require("beat_data")
player = require("player")

$loops = d3.select(".beatkeeper__loops").selectAll("div").data(beats)

window.activePattern = beats[0].pattern

playPattern = (data) ->
  window.activePattern = data.pattern
  player.play(data.pattern)
  d3.selectAll(".beatkeeper__loop").classed("active", false)
  d3.select(@parentNode).classed("active", true)

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
      .classed "active", (_, i) -> i == 0 # select the first loop by default

  createPlaybackButtons($loop)
  createLoopPreviews($loop)

module.exports =
  create: createLoops
