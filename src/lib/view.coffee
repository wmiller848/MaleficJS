#
#  William C Miller
#  Maleficjs Copyright (c) 2014
#
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

    @node = @AppendHTML(
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
    classes = el.className.split(' ')
    el.className = ''
    for c in classes
      if c isnt 'ss_enabled' and c isnt 'ss_disabled' then el.className += c + ' '
    el.className += 'ss_disabled'

  Enable: (el=@node) ->
    classes = el.className.split(' ')
    el.className = ''
    for c in classes
      if c isnt 'ss_disabled' and c isnt 'ss_enabled' then el.className += c + ' '
    el.className += 'ss_enabled'

  Hide: (el=@node) ->
    classes = el.className.split(' ')
    el.className = ''
    for c in classes
      if c isnt 'ssview-show' and c isnt 'ssview-hidden' then el.className += c + ' '
    el.className += 'ssview-hidden'

  Show: (el=@node) ->
    classes = el.className.split(' ')
    el.className = ''
    for c in classes
      if c isnt 'ssview-hidden' and c isnt 'ssview-show' then el.className += c + ' '
    el.className += 'ssview-show'

  Ready: (cb) ->
    if @_loaded is true then cb()
    else @_cb.push(cb)
