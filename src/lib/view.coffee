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
  #
  #
  constructor: (@opt) ->
    super('Malefic:View')

    # Bind options
    for key, opt of @opt
      @[key] = opt
    @Data['Model'] = @Model if @Model
    if not @id
      @id = @Random(8)

    @Broker = window.Malefic._broker if not @Broker
    @Context = 'body' if not @Context
    @_loaded = false
    @_cb = []
    @html = null
    @hbs = null
    @node = null
    @_elements = @Elements if @Elements
    @Elements = {}
    @Actions = @Actions?()

    @_Load() if @Template

  _Load: ->
    req = @Ajax(@Template)
    req.Then = (err, res) =>
      if err
        return @Log(err)

      @html = res.toString()

      @_Hook()

      # @_Clear()
      @_Render()
      # @_Bind()

      @_loaded = true
      @Loaded?()
      for cb in @_cb
        cb()

  _Hook: ->
    for event, func of @Events
      event.sid = @Broker.On(event, @Actions[func])

  _Unhook: ->
    for event, func of @Events
      @Broker.Off(event, event.sid)

  _Clear: ->
    @Log('Widget Clear')
    @container.removeChild(@node) if @container and @node

  _Render: ->
    @Log('Widget Render')
    @container = @Query(@Context)
    @hbs = Handlebars.compile(@html)
    if @Helpers
      for id, helper of @Helpers
        Handlebars.registerHelper(id, helper)
    @Render()
    # @node = @Append(
    #   parent: @container
    #   type: 'div'
    #   attributes:
    #     'data-id': @Template + '-' + @id
    #   html: @hbs(@Data['Model'])
    # )

  Render: ->
    # @Remove(@container, @container.children)
    # @_Render()
    node_root = @container
    html_str = @hbs(@Data['Model'])
    html_sig = @_signHTML(node_root, html_str)

  _replace_sig: (root, node) ->
    node.outerHTML = root.outerHTML

  _burn_sig: (root, node) ->
    node.className = root.className
    node.innerHTML = root.innerHTML
    node.style.cssText = root.style.cssText

  _match_sig: (root, node) ->
    # console.log('Root or Node has no children')
    if root.innerHTML isnt node.innerHTML
      @_burn_sig(root, node)
      return -1
    else
      return 0

  _match_meta: (root, node) ->
    if root.src isnt node.src
      @_replace_sig(root, node)
      return -1
    if root.tagName isnt node.tagName
      @_replace_sig(root, node)
      return -1
    if root.className isnt node.className
      @_burn_sig(root, node)
      # @_replace_sig(root, node)
      return -1
    if root.style.cssText isnt node.style.cssText
      @_burn_sig(root, node)
      # @_replace_sig(root, node)
      return -1
    return 0

  # Recursive search for rendering
  # depth is current level
  # root is the ideal state
  # node is the current dom state
  _sign: (depth, root, node) ->
    # console.log(depth, root, node)
    if root and node
      if depth isnt 0
        return -1 if @_match_meta(root, node) is -1
      if root.children and node.children
        if root.children.length is node.children.length
          len = root.children.length
          if len > 0
            failed = 0
            for i in [0..len]
              status = @_sign(depth + 1, root.children[i], node.children[i])
              failed = -1 if status is -1
            return failed
          else
            return @_match_sig(root, node)
        else
          if root.children.length > node.children.length
            len = root.children.length
            if len > 0
              failed = 0
              for i in [0..len]
                if i < node.children.length
                  status = @_sign(depth + 1, root.children[i], node.children[i])
                  failed = -1 if status is -1
                else
                  node.appendChild(root.children[i].cloneNode(true)) if root.children[i]
                  failed = -1
              return failed
            else
              return @_match_sig(root, node)
          else
            # TODO :: handle subtraction
            return @_match_sig(root, node)
      else
        # console.log('Root or Node has no children property')
        return -1
    else
      # console.log('Root or Node not defined')
      return 0

  _signHTML: (node, html) ->
    parser = new DOMParser()
    htmlSig = parser.parseFromString(html, 'text/html')
    root = htmlSig.body
    status = @_sign(0, root, node)
    @_Bind() if status is -1


  _Bind: ->
    for id, el of @_elements
      @Elements[id] = @Query(el, false, @node)
    @OnBind?()

  Disable: (el=@node) ->
    el.disabled = true
    el.dataset.disabled = true

  Enable: (el=@node) ->
    el.disabled = false
    el.dataset.disabled = false

  Hide: (el=@node) ->
    el.style.display = 'none'

  Show: (el=@node) ->
    el.style.display = 'inherit'

  Toggle: (el=@node) ->
    if el.style.display is 'none'
      if el is @node
        @Render()
      @Show(el)
    else
      @Hide(el)

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
    if not document.fullscreenElement and not document.mozFullScreenElement and not document.webkitFullscreenElement and not document.msFullscreenElement
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
  ##
  ##
  RenderLoop: (callback, fps_cap=60) ->
    start = new Date().getTime()

    # lastTimeStamp = startTime
    # lastFpsTimeStamp = startTime
    # framesPerSecond = 0

    interval = 1000 / fps_cap

    lastFpsTimeStamp = start
    framesPerSecond = 0
    frameCount = 0

    tick = ->
      window.requestAnimationFrame(tick)

      now = new Date().getTime()
      frameCount++
      if now - lastFpsTimeStamp >= 1000
        framesPerSecond = frameCount
        frameCount = 0
        lastFpsTimeStamp = now

      delta = now - start

      if delta > interval
        start = now - (delta % interval)
        callback?(
          startTime: start
          timeStamp: now
          elapsed: now - start
          realFramesPerSecond: framesPerSecond
          framesPerSecond: fps_cap
        )

    tick()

  Ready: (cb) ->
    if @_loaded is true then cb()
    else @_cb.push(cb)
