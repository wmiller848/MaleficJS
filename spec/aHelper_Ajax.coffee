#
#
# Copyright (c) 2014 - 2016 William C Miller maleficjs Copyright (c)

# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the Software
# is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall
# be included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

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

  # Trigger a response in @MockNetworkLatency ms
  Trigger: (event, data={}) ->
    #console.log("XMLHttpRequest::Trigger Registered")
    setTimeout( =>
      #console.log("XMLHttpRequest::Trigger Firing")
      @xmlReq?.events[event]?(data)
    , @MockNetworkLatency)
