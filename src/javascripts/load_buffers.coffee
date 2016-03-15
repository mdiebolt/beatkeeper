BufferLoader = require("buffer_loader")

# Keep track of all loaded buffers.
window.BUFFERS = {}
# Page-wide audio context.
window.context = null

# An object to track the buffers to load {name: path}
BUFFERS_TO_LOAD =
  kick: "src/sounds/kick.wav"
  snare: "src/sounds/snare.wav"
  hihat: "src/sounds/hihat.wav"

# Loads all sound samples into the buffers object.
loadBuffers = ->
  # Array-ify
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

document.addEventListener "DOMContentLoaded", ->
  try
    # Fix up prefixing
    window.AudioContext = window.AudioContext || window.webkitAudioContext
    window.context = new AudioContext()
  catch e
    alert("Web Audio API is not supported in this browser");

  loadBuffers()
