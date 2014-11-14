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

class window.Malefic.View extends window.Malefic.Core
  constructor: ->
    super('Malefic:View')
    @Context = 'body' if not @Context
    @_loaded = false
    @_cb = []
    @html = null
    @hbs = null
    @node = null
    @Actions = @Actions()
    @_Load()

  _Load: ->
    req = @Ajax(@Template)
    req.then = (err, res) =>
      if err
        return @Log(err)

      @html = res.toString()
      @_Hook()
      @_Render()
      @_Bind()

      @Loaded?()
      for cb in @_cb
        cb()
      @_loaded = true

  _Hook: (ctx=@Context) ->
    @container = @Query(ctx)

  _Clear: ->
    @Log('Widget Clear')
    node = @Query("[data-id=\"#{@Template}\"]", @container)
    @context.removeChild(node)

  _Render: ->
    @Log('Widget Render')
    @hbs = Handlebars.compile(@html)
    if @Helpers
      for id, helper of @Helpers
        Handlebars.registerHelper(id, =>
          helper(@)
        )

    @node = @Append(
      parent: @container
      type: 'div'
      attributes:
        'data-id': @Template
      html: @hbs(@Data)
    )

  _Bind: ->
    for id, el of @Elements
      @Elements[id] = @Query(el)
    @OnBind?()

  Disable: (el=@node) ->
    el.disabled = true

  Enable: (el=@node) ->
    el.disabled = false

  Hide: (el=@node) ->
    el.style.display = 'none'

  Show: (el=@node) ->
    el.style.display = 'inherit'

  ToggleClass: (el=@node, cssClass) ->
    classes = el.className.split(' ')
    hasClass = false
    el.className = ''
    for c in classes
      if c isnt cssClass then el.className += c + ' '
      else if c is cssClass then hasClass = true
    if not hasClass
      el.className += cssClass

  ToggleFullScreen: ->
    if !document.fullscreenElement && !document.mozFullScreenElement && !document.webkitFullscreenElement && !document.msFullscreenElement
      if document.documentElement.requestFullscreen
        document.documentElement.requestFullscreen?()
      else if document.documentElement.msRequestFullscreen
        document.documentElement.msRequestFullscreen?()
      else if document.documentElement.mozRequestFullScreen
        document.documentElement.mozRequestFullScreen?()
      else if document.documentElement.webkitRequestFullscreen
        document.documentElement.webkitRequestFullscreen?(Element.ALLOW_KEYBOARD_INPUT)
    else
      if document.exitFullscreen
        document.exitFullscreen?()
      else if document.msExitFullscreen
        document.msExitFullscreen?()
      else if document.mozCancelFullScreen
        document.mozCancelFullScreen?()
      else if document.webkitExitFullscreen
        document.webkitExitFullscreen?()

  RenderLoop: (callback) ->
    startTime = window.webkitAnimationStartTime ||
      window.mozAnimationStartTime ||
      new Date().getTime()
             
    startTime = 0
    lastTimeStamp = startTime
    lastFpsTimeStamp = startTime
    framesPerSecond = 0
    frameCount = 0

    nextFrame = (time) ->
      window.requestAnimationFrame(nextFrame)
      if lastTimeStamp - lastFpsTimeStamp >= 1000
        framesPerSecond = frameCount
        frameCount = 0
        lastFpsTimeStamp = lastTimeStamp

      frameCount++
      lastTimeStamp = time

      callback?(
        startTime: startTime
        timeStamp: time
        elapsed: time-startTime
        frameTime: time-lastTimeStamp
        framesPerSecond: framesPerSecond
      )
    window.requestAnimationFrame(nextFrame)

  Ready: (cb) ->
    if @_loaded is true then cb()
    else @_cb.push(cb)
