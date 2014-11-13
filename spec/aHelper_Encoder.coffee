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
