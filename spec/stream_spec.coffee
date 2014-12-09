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

root = @

describe('Stream', ->

  it('should be defined', ->
    expect(window.Malefic.Stream).toBeDefined()
  )

  #
  #
  describe('#Trigger', ->

    beforeEach( (done) ->
      @handleOne = (data) -> data
      @handleTwo = (data) -> data
      spyOn(@, 'handleOne').and.callThrough()

      @stream = new window.Malefic.Stream()
      done()
    )

    it('shouldnt trigger events', (done) ->
      @id = @stream.On('test', @handleOne)

      @stream.Off('test', @id)
      expect(@handleOne).not.toHaveBeenCalled()
      @stream.Trigger('test', '1')
      done()
    )

    it('should trigger events', (done) ->
      @id = @stream.On('test', @handleOne)

      @stream.Trigger('test', '1')
      expect(@handleOne).toHaveBeenCalled()
      done()
    )
  )
)
