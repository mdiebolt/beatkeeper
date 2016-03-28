BufferLoader = (context, urlList, callback) ->
  @context = context
  @urlList = urlList
  @onload = callback
  @bufferList = []
  @loadCount = 0

loadSuccess = (buffer, loader, index) ->
  return alert("error decoding file data: #{url}") unless buffer

  loader.bufferList[index] = buffer
  loader.loadCount += 1
  loader.onload(loader.bufferList) if loader.loadCount == loader.urlList.length

loadError = (error) ->
  console.error("decodeAudioData error", error)

BufferLoader::loadBuffer = (url, index) ->
  request = new XMLHttpRequest()
  request.open("GET", url, true)
  request.responseType = "arraybuffer"

  loader = @

  request.onload = ->
    loader.context.decodeAudioData request.response
    , (buffer) ->
      loadSuccess(buffer, loader, index)
    , (error) ->
      loadError(error)

  request.onerror = ->
    alert("BufferLoader: XHR error")

  request.send()

BufferLoader::load = ->
  @urlList.forEach (item, i) =>
    @loadBuffer(item, i)

module.exports = BufferLoader
