BufferLoader = require("buffer_loader")

BUFFERS = {}

# Fix up prefixing
window.AudioContext ||= window.webkitAudioContext
# WebAudio API context
context = new AudioContext()

# An object to track the buffers to load {name: path}
BUFFERS_TO_LOAD =
  kick: "src/sounds/kick.wav"
  snare: "src/sounds/snare.wav"
  hihat: "src/sounds/hihat.wav"

# Loads all sound samples into the buffers object.
loadBuffers = ->
  names = []
  paths = []
  for name, path of BUFFERS_TO_LOAD
    names.push(name)
    paths.push(path)

  bufferLoader = new BufferLoader context, paths, (bufferList) ->
    bufferList.forEach (buffer, i) ->
      name = names[i]
      BUFFERS[name] = buffer

  bufferLoader.load()

loadBuffers()

module.exports = {
  BUFFERS
  context
}
