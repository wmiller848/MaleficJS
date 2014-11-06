_mock_root = _mock_root or @

class @HelperEncoder
  constructor: ->
    @name = 'HelperEncoder'
    @Bind()

  Bind: ->
    #console.log("Binding #{@name}")
    # Mock String.fromCharCode
    root = _mock_root
    _nativeFromCharCode = root.String.fromCharCode
    root.String.fromCharCode = (arg) ->
      if typeof arg isnt 'number'
        ln = arg.length
        str = ''
        for i in [0..ln]
          if arg[i] isnt undefined
            str += _nativeFromCharCode(arg[i])
        return str
      else
        return _nativeFromCharCode(arg)
    root.String.fromCharCode.apply = (scope, arg) ->
      #console.log("Shimming scope - #{scope}")
      root.String.fromCharCode(arg)

  # TODO:
  #  Unicode testing
  StringToBuffer: (str) ->
    ln = str.length
    buf = new Uint8Array(ln)
    for i in [0..ln]
      buf[i] = str.charCodeAt(i)
    buf
