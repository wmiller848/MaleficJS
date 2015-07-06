# Copyright (c) 2014 - 2016 William C Miller

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

window.Malefic = {} if not window.Malefic

class window.Malefic.Stream extends window.Malefic.Core
  constructor: ->
    super('Malefic:Stream')
    @_events = {}
    @_log = []

  Trigger: (event, data) ->
    #console.log(event, data)
    @_log.push(
      event: "Trigger"
      params: [
        event,
        data
      ]
    )
    if @_events[event] and @_events[event].length > 0
      for list in @_events[event]
        list?.func?(data)

  On: (event, func) ->
    #console.log(event, func)
    @_events[event] = [] if not @_events[event]
    listener =
      id: @Random(16)
      func: func
    @_events[event].push(listener)

    @_log.push(
      event: "On"
      params: [
        event,
        @FuncName(func)
      ]
      id: listener.id
    )

    listener.id

  Off: (event, listenerID) ->
    #console.log(event)
    @_log.push(
      event: "Off"
      params: [
        event,
        listenerID
      ]
      id: listenerID
    )
    return @_events[event] = null if listenerID is null

    for i, list of @_events[event]
      if list.id is listenerID
        delete @_events[event][i]
        delete @_events[event] if not @_events[event].length is 0
        return

  ClearLogs: ->
    @_log = null
    @_log = []
