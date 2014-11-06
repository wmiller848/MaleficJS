_mock_root = _mock_root or @

class @HelperAjax
  constructor: ->
    @name = 'HelperAjax'
    @MockNetworkLatency = 2
    @Bind()

  Bind: ->
    #console.log("Binding #{@name}")
    # Mock XMLHttpRequest
    root = _mock_root
    root.XMLHttpRequest = =>
      #console.log('XMLHttpRequest')
      @xmlReq =
        name: "Mock_#{@name}"
        events: {}
        open: (method, url, async) ->
          #console.log("XMLHttpRequest::Open - Opening #{method} #{url}, Async - #{async}")
        addEventListener: (event, handle, capture) ->
          #console.log("XMLHttpRequest::AddEventListener - #{event}, Capture - #{capture}")
          @events[event] = handle
        send: (data) ->
          #console.log("XMLHttpRequest::Send - Sending #{data}")
        setRequestHeader: (key, value) ->
          #console.log("XMLHttpRequest::SetRequestHeader - #{key}:#{value}")
        getAllResponseHeaders: ->
          #console.log('XMLHttpRequest::GetAllResponseHeaders')
          headers = 'content-type: application/json\nserver: nginx-mock'

      #
      # Fire any handlers attached
      @_hander?()

      @xmlReq

  Listen: (handle) ->
    @_hander = handle

  Trigger: (event, data={}) ->
    #console.log("XMLHttpRequest::Trigger Registered")
    setTimeout( =>
      #console.log("XMLHttpRequest::Trigger Firing")
      @xmlReq?.events[event]?(data)
    , @MockNetworkLatency)
