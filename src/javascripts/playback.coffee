RhythmSample = {}

RhythmSample.play = ->
  playSound = (buffer, time) ->
    source = context.createBufferSource()
    source.buffer = buffer

    source.connect(context.destination)

    source.start = source.noteOn unless source.start
    source.start(time)

  kick = BUFFERS.kick
  snare = BUFFERS.snare
  hihat = BUFFERS.hihat

  # We'll start playing the rhythm 100 milliseconds from "now"
  startTime = context.currentTime + 0.100
  tempo = 80
  eighthNoteTime = (60 / tempo) / 2

  # Play 2 bars of the following
  [0...2].forEach (bar) ->
    time = startTime + bar * 8 * eighthNoteTime
    # Play the bass (kick) drum on beats 1, 5
    playSound(kick, time)
    playSound(kick, time + 4 * eighthNoteTime)

    # Play the snare drum on beats 3, 7
    playSound(snare, time + 2 * eighthNoteTime)
    playSound(snare, time + 6 * eighthNoteTime)

    # Play the hi-hat every eighth note.
    [0...8].forEach (i) ->
      playSound(hihat, time + i * eighthNoteTime)

module.exports = RhythmSample
