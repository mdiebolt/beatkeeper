require("load_buffers")
beats = require("beat_data")
staff = require("staff")

eighthNoteTime = (60 / TEMPO) / 2
startTime = endTime = null

activeSources = []

playSound = (buffer, time) ->
  source = context.createBufferSource()
  source.buffer = buffer
  source.connect(context.destination)
  source.start(time)
  source.onended = ->
    index = activeSources.indexOf(source)
    activeSources.splice(index, 1)

  activeSources.push(source)

updateProgress = ->
  return if context.currentTime > endTime

  requestAnimationFrame ->
    dt = context.currentTime - startTime
    totalBeatTime = endTime - startTime

    x = (dt / totalBeatTime) * STAFF_WIDTH
    x = Math.min(x, STAFF_WIDTH)

    staff.update [
      { x: x, y: 0 }
      { x: x, y: INSTRUMENT_LINE_HEIGHT * 4 }
    ]

    updateProgress()

playBufferAt = (time, buffer, pattern) ->
  pattern.split("").forEach (note, i) ->
    unless note == "-"
      beat = i * eighthNoteTime
      playSound(buffer, time + beat)

stopSource = (source) ->
  source.stop()

stop = ->
  activeSources.forEach(stopSource)

playBar = (pattern, time) ->
  [hihatPattern, snarePattern, kickPattern] = pattern.split("\n")

  playBufferAt(time, BUFFERS.hihat, hihatPattern)
  playBufferAt(time, BUFFERS.snare, snarePattern)
  playBufferAt(time, BUFFERS.kick, kickPattern)

play = (pattern) ->
  stop()
  startTime = context.currentTime
  endTime = startTime + (8 * eighthNoteTime)

  playBar(pattern, startTime)
  updateProgress()

module.exports = {
  play
  stop
}
