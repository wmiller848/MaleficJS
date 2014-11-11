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

  Ready: (cb) ->
    if @_loaded is true then cb()
    else @_cb.push(cb)
