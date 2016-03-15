BufferLoader = (context, urlList, callback) ->
  @context = context
  @urlList = urlList
  @onload = callback
  @bufferList = new Array()
  @loadCount = 0

BufferLoader.prototype.loadBuffer = (url, index) ->
  # Load buffer asynchronously
  request = new XMLHttpRequest()
  request.open("GET", url, true)
  request.responseType = "arraybuffer"

  loader = @

  request.onload = ->
    # Asynchronously decode the audio file data in request.response
    loader.context.decodeAudioData(
      request.response,
      (buffer) ->
        unless buffer
          alert("error decoding file data: #{url}")
          return

        loader.bufferList[index] = buffer
        if ++loader.loadCount == loader.urlList.length
          loader.onload(loader.bufferList)
      ,
      (error) ->
        console.error("decodeAudioData error", error)
    )

  request.onerror = ->
    alert("BufferLoader: XHR error")

  request.send()

BufferLoader.prototype.load = ->
  @urlList.forEach (item, i) =>
    @loadBuffer(item, i)

module.exports = BufferLoader
