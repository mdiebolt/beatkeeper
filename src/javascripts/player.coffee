require("load_buffers")
beats = require("beat_data")
staff = require("staff")

bars = 2
tempo = 120
eighthNoteTime = (60 / tempo) / 2
startTime = endTime = null

playSound = (buffer, time) ->
  source = context.createBufferSource()
  source.buffer = buffer
  source.connect(context.destination)
  source.start(time)

updateProgress = ->
  return if context.currentTime > endTime

  requestAnimationFrame ->
    dt = context.currentTime - startTime
    totalBeatTime = endTime - startTime
    staffWidth = window.innerWidth - 300

    x = (dt / totalBeatTime) * staffWidth

    staff.update [
      { x: x, y: 40 }
      { x: x, y: 120 }
    ]

    updateProgress()

playHats = (pattern, beginningOfBar) ->
  pattern.split("").forEach (note, i) ->
    if note == "h"
      beat = i * eighthNoteTime
      playSound(BUFFERS.hihat, beginningOfBar + beat)

playSnare = (pattern, beginningOfBar) ->
  pattern.split("").forEach (note, i) ->
    if note == "s"
      beat = i * eighthNoteTime
      playSound(BUFFERS.snare, beginningOfBar + beat)

playKick = (pattern, beginningOfBar) ->
  pattern.split("").forEach (note, i) ->
    if note == "k"
      beat = i * eighthNoteTime
      playSound(BUFFERS.kick, beginningOfBar + beat)

module.exports =
  play: (pattern) ->
    activeSources = 0
    startTime = context.currentTime
    endTime = startTime + (bars * 8 * eighthNoteTime)

    [0...bars].forEach (bar) ->
      beginningOfBar = startTime + bar * 8 * eighthNoteTime

      [hihatPattern, snarePattern, kickPattern] = pattern.split("\n")

      playHats(hihatPattern, beginningOfBar)
      playSnare(snarePattern, beginningOfBar)
      playKick(kickPattern, beginningOfBar)

    updateProgress()
