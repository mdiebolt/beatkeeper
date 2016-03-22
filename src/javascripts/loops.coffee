d3 = require("d3")
beats = require("beat_data")
player = require("player")

$loops = d3.select(".beatkeeper__loops").selectAll("div").data(beats)

createLoops = ->
  $loop = $loops.enter().append("div").attr("class", "beatkeeper__loop")
  $loop.append("div").attr("class", "beatkeeper__loop-number").text (d, i) -> "#{i + 1}."
  $loop.append("div").attr("class", "beatkeeper__loop-preview")
  $loop.append("div").attr("class", "beatkeeper__loop-name").text (d) -> d.name
  $loop.append("button").attr("class", "beatkeeper__loop-listen").on "click", (data) ->
    player.play(data.pattern)

module.exports =
  create: ->
    createLoops()
