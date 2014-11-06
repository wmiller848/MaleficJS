#
#
root = @

# Indicate the test is ready to start
window.done = true

describe('Core', ->

  #
  #
  describe('#Domain', ->
    beforeEach( (done) ->
      silent = true
      @core = new window.Malefic.Core('CoreSpecTest', silent)
      done()
    )

    it('should return host from domain', (done) ->
      expect(@core.Domain('mapchat.io')).toBe('mapchat.io')
      done()
    )

    it('should return host from sub-domain', (done) ->
      expect(@core.Domain('www.mapchat.io')).toBe('mapchat.io')
      done()
    )

    it('should return host from BIG sub-domain', (done) ->
      expect(@core.Domain('big.subdomain.mapchat.io')).toBe('mapchat.io')
      done()
    )
  )

  #
  #
  describe('#Watch', ->
    beforeEach( (done) ->
      silent = true
      @core = new window.Malefic.Core('CoreSpecTest', silent)
      done()
    )

    xit('should watch object', (done) ->
      done()
    )
  )

  #
  #
  describe('#Ajax', ->

    beforeEach( (done) ->
      @helpers =
        Ajax: new root.HelperAjax()
        Encoder: new root.HelperEncoder()
      silent = true
      @core = new window.Malefic.Core('CoreSpecTest', silent)
      done()
    )

    describe('Request', ->

      it('should use a promise', (done) ->
        req = @core.Ajax('file://api.mapchat.io/healthcheck')
        expect(typeof req).toBe('object')
        done()
      )

      it('should handle progress', (done) ->
        e =
          loaded: 100
          total: 100
        @helpers.Ajax.Trigger('progress', e)
        req = @core.Ajax('file://api.mapchat.io/healthcheck')
        req.status = (status) =>
          expect(status).toBe('100%')
          done()
      )

      it('should handle load', (done) ->
        json = '{"status":"ok"}'
        buffer = @helpers.Encoder.StringToBuffer(json)
        e =
          'target':
            'response': buffer
        @helpers.Ajax.Trigger('load', e)
        req = @core.Ajax('file://api.mapchat.io/healthcheck')
        req.then = (err, res) =>
          expect(err).toBe(null)
          expect(res).toBeDefined()
          done()
      )

      it('should handle errors', (done) ->
        errMsg = 'error': 'real bad error'
        e =
          'target': errMsg
        @helpers.Ajax.Trigger('error', e)
        req = @core.Ajax('file://api.mapchat.io/healthcheck')
        req.then = (err, res) =>
          expect(err).toBeDefined()
          expect(err).toBe(errMsg)
          expect(res).toBe(null)
          done()
      )

      it('should handle abort', (done) ->
        errMsg = 'error': 'real bad error'
        e =
          'target': errMsg
        @helpers.Ajax.Trigger('abort', e)
        req = @core.Ajax('file://api.mapchat.io/healthcheck')
        req.then = (err, res) =>
          expect(err).toBeDefined()
          expect(err).toBe(errMsg)
          expect(res).toBe(null)
          done()
      )
    )

    describe('Response', ->

      beforeEach( (done) ->
        #
        # JSON Test Response
        @json = '{"status":"ok"}'
        @bufferJSON = @helpers.Encoder.StringToBuffer(@json)
        @eJSON =
          'target':
            'response': @bufferJSON

        #
        # XML Test Response
        @xml = '<?xml version="1.0" encoding="UTF-8"?><data><keyA>ValueA</keyA><keyB>ValueB</keyB></data>'
        @bufferXML = @helpers.Encoder.StringToBuffer(@xml)
        @eXML =
          'target':
            'response': @bufferXML
        done()
      )

      it('should support toArray', (done) ->
        @helpers.Ajax.Trigger('load', @eJSON)
        req = @core.Ajax('file://api.mapchat.io/healthcheck')
        req.then = (err, res) =>
          expect(err).toBe(null)
          expect(res).toBeDefined()
          expect(res.toArray()).toEqual(@bufferJSON)
          done()
      )

      it('should support toString', (done) ->
        @helpers.Ajax.Trigger('load', @eJSON)
        req = @core.Ajax('file://api.mapchat.io/healthcheck')
        req.then = (err, res) =>
          expect(err).toBe(null)
          expect(res).toBeDefined()
          expect(res.toString()).toBe(@json)
          done()
      )

      it('should support toBase64', (done) ->
        @helpers.Ajax.Trigger('load', @eJSON)
        req = @core.Ajax('file://api.mapchat.io/healthcheck')
        req.then = (err, res) =>
          expect(err).toBe(null)
          expect(res).toBeDefined()
          expect(res.toBase64()).toEqual(btoa(@json))
          done()
      )

      it('should support toJSON', (done) ->
        @helpers.Ajax.Trigger('load', @eJSON)
        req = @core.Ajax('file://api.mapchat.io/healthcheck')
        req.then = (err, res) =>
          expect(err).toBe(null)
          expect(res).toBeDefined()
          expect(res.toJSON()).toEqual(JSON.parse(@json))
          done()
      )

      xit('should support toXML', (done) ->
        @helpers.Ajax.Trigger('load', @eXML)
        req = @core.Ajax('file://api.mapchat.io/healthcheck')
        req.then = (err, res) =>
          expect(err).toBe(null)
          expect(res).toBeDefined()
          parser = new DOMParser()
          xml = parser.parseFromString(@xml, 'text/xml')
          expect(res.toXML()).toEqual(xml)
          done()
      )

      it('should support headers', (done) ->
        @helpers.Ajax.Trigger('load', @eJSON)
        req = @core.Ajax('file://api.mapchat.io/healthcheck')
        req.then = (err, res) =>
          expect(err).toBe(null)
          expect(res).toBeDefined()
          headers = res.headers()
          expect(headers['server']).toBe('nginx-mock')
          done()
      )
    )
  )

  #
  #
  describe('#Query', ->
    beforeEach( (done) ->
      silent = true
      @core = new window.Malefic.Core('CoreSpecTest', silent)
      done()
    )

    xit('should return null for unmatched selector', (done) ->
      done()
    )
  )

  #
  #
  describe('#AppendHTML', ->
    beforeEach( (done) ->
      silent = true
      @core = window.Malefic.Core('CoreSpecTest', silent)
      done()
    )

    xit('should append html in the document body', (done) ->
      done()
    )
  )

  #
  #
  describe('#Cache', ->
    beforeEach( (done) ->
      silent = true
      @core = new window.Malefic.Core('CoreSpecTest', silent)
      done()
    )

    it('should return undefined for unknown key', (done) ->
      key = 'key'
      val = @core.Cache(key)
      expect(val).not.toBeDefined()
      done()
    )

    it('should return value for known key', (done) ->
      key = 'key'
      v = 'value'
      @core.Cache(key, v)
      val = @core.Cache(key)
      expect(val).toBe(v)
      done()
    )

    it('should return value for cached value via localstorage', (done) ->
      key = 'key'
      v = 'value'
      @core.Cache(key, v, true,
        noInMemory: true
        noCookies: true
      )
      val = @core.Cache(key)
      expect(val).toBe(v)
      done()
    )

    it('should return value for cached value via cookie', (done) ->
      key = 'key'
      v = 'value'
      @core.Cache(key, v, true,
        noInMemory: true
        noLocalstorage: true
      )
      val = @core.Cache(key)
      expect(val).toBe(v)
      done()
    )
  )
)
