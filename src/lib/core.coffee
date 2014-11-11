#
#  William C Miller
#  Maleficjs Copyright (c) 2014
#
window.Malefic = {} if not window.Malefic

class window.Malefic.Core
  #
  #
  StatusContinue                     : 100
  StatusSwitchingProtocols           : 101

  StatusOK                           : 200
  StatusCreated                      : 201
  StatusAccepted                     : 202
  StatusNonAuthoritativeInfo         : 203
  StatusNoContent                    : 204
  StatusResetContent                 : 205
  StatusPartialContent               : 206

  StatusMultipleChoices              : 300
  StatusMovedPermanently             : 301
  StatusFound                        : 302
  StatusSeeOther                     : 303
  StatusNotModified                  : 304
  StatusUseProxy                     : 305
  StatusTemporaryRedirect            : 307

  StatusBadRequest                   : 400
  StatusUnauthorized                 : 401
  StatusPaymentRequired              : 402
  StatusForbidden                    : 403
  StatusNotFound                     : 404
  StatusMethodNotAllowed             : 405
  StatusNotAcceptable                : 406
  StatusProxyAuthRequired            : 407
  StatusRequestTimeout               : 408
  StatusConflict                     : 409
  StatusGone                         : 410
  StatusLengthRequired               : 411
  StatusPreconditionFailed           : 412
  StatusRequestEntityTooLarge        : 413
  StatusRequestURITooLong            : 414
  StatusUnsupportedMediaType         : 415
  StatusRequestedRangeNotSatisfiable : 416
  StatusExpectationFailed            : 417
  StatusTeapot                       : 418

  StatusInternalServerError          : 500
  StatusNotImplemented               : 501
  StatusBadGateway                   : 502
  StatusServiceUnavailable           : 503
  StatusGatewayTimeout               : 504
  StatusHTTPVersionNotSupported      : 505

  #
  #
  constructor: (@name='Core', @silent=false) ->
    @version = "v.0.0.1"
    @Log("Starting " + @name)
    @body = document.body
    @_cache = {}
    @host = @Domain()

  #
  #
  Log: ->
    return if @silent is true
    return if window.ss_log is false
    prefix = @version + " | "
    for msg in arguments
      if typeof msg is "string"
        console.log(prefix + msg)
      else
        console.log(prefix, msg)
  #
  #
  Watch: ->
    @Log("watching")

  #
  #
  Domain: (url=window.location.host) ->
    TLDs = ["ac", "ad", "ae", "aero", "af", "ag", "ai", "al", "am", "an", "ao", "aq", "ar", "arpa", "as", "asia", "at", "au", "aw", "ax", "az", "ba", "bb", "bd", "be", "bf", "bg", "bh", "bi", "biz", "bj", "bm", "bn", "bo", "br", "bs", "bt", "bv", "bw", "by", "bz", "ca", "cat", "cc", "cd", "cf", "cg", "ch", "ci", "ck", "cl", "cm", "cn", "co", "com", "coop", "cr", "cu", "cv", "cx", "cy", "cz", "de", "dj", "dk", "dm", "do", "dz", "ec", "edu", "ee", "eg", "er", "es", "et", "eu", "fi", "fj", "fk", "fm", "fo", "fr", "ga", "gb", "gd", "ge", "gf", "gg", "gh", "gi", "gl", "gm", "gn", "gov", "gp", "gq", "gr", "gs", "gt", "gu", "gw", "gy", "hk", "hm", "hn", "hr", "ht", "hu", "id", "ie", "il", "im", "in", "info", "int", "io", "iq", "ir", "is", "it", "je", "jm", "jo", "jobs", "jp", "ke", "kg", "kh", "ki", "km", "kn", "kp", "kr", "kw", "ky", "kz", "la", "lb", "lc", "li", "lk", "lr", "ls", "lt", "lu", "lv", "ly", "ma", "mc", "md", "me", "mg", "mh", "mil", "mk", "ml", "mm", "mn", "mo", "mobi", "mp", "mq", "mr", "ms", "mt", "mu", "museum", "mv", "mw", "mx", "my", "mz", "na", "name", "nc", "ne", "net", "nf", "ng", "ni", "nl", "no", "np", "nr", "nu", "nz", "om", "org", "pa", "pe", "pf", "pg", "ph", "pk", "pl", "pm", "pn", "pr", "pro", "ps", "pt", "pw", "py", "qa", "re", "ro", "rs", "ru", "rw", "sa", "sb", "sc", "sd", "se", "sg", "sh", "si", "sj", "sk", "sl", "sm", "sn", "so", "sr", "st", "su", "sv", "sy", "sz", "tc", "td", "tel", "tf", "tg", "th", "tj", "tk", "tl", "tm", "tn", "to", "tp", "tr", "travel", "tt", "tv", "tw", "tz", "ua", "ug", "uk", "us", "uy", "uz", "va", "vc", "ve", "vg", "vi", "vn", "vu", "wf", "ws", "xn--0zwm56d", "xn--11b5bs3a9aj6g", "xn--3e0b707e", "xn--45brj9c", "xn--80akhbyknj4f", "xn--90a3ac", "xn--9t4b11yi5a", "xn--clchc0ea0b2g2a9gcd", "xn--deba0ad", "xn--fiqs8s", "xn--fiqz9s", "xn--fpcrj9c3d", "xn--fzc2c9e2c", "xn--g6w251d", "xn--gecrj9c", "xn--h2brj9c", "xn--hgbk6aj7f53bba", "xn--hlcj6aya9esc7a", "xn--j6w193g", "xn--jxalpdlp", "xn--kgbechtv", "xn--kprw13d", "xn--kpry57d", "xn--lgbbat1ad8j", "xn--mgbaam7a8h", "xn--mgbayh7gpa", "xn--mgbbh1a71e", "xn--mgbc0a9azcg", "xn--mgberp4a5d4ar", "xn--o3cw4h", "xn--ogbpf8fl", "xn--p1ai", "xn--pgbs0dh", "xn--s9brj9c", "xn--wgbh1c", "xn--wgbl6a", "xn--xkc2al3hye2a", "xn--xkc2dl3a5ee0h", "xn--yfro4i67o", "xn--ygbi2ammx", "xn--zckzah", "xxx", "ye", "yt", "za", "zm", "zw"].join()

    parts = url.split('.')
    ln = parts.length
    i = ln
    minLength = parts[ln-1].length
    # Last Element of Array
    tld = parts[-1..].pop()

    while(part = parts[--i])
      if TLDs.indexOf(part) < 0 or part.length < minLength or i < ln-2 or i is 0
        return "#{part}.#{tld}"

  #
  #
  _ajax: (options) ->
    #@Log('Ajax Call', options)

    method = options.method or 'GET'
    url = options.url or ''

    ajax = new XMLHttpRequest()
    async = true
    ajax.open(method, url, async)
    # Force binary response
    ajax.responseType = 'arraybuffer'
    ajax.withCredentials = options.withCredentials or false

    progress = (e) =>
      #@Log(e)
      status = e.loaded/e.total or 0.0
      status *= 100
      options.progress?("#{status}%")
    load = (e) =>
      #@Log(e)
      @Log('Loaded', e)
      data = new Uint8Array(e.target.response)
      headers = {}
      _h = ajax.getAllResponseHeaders()
      h = _h.split('\n')
      h.forEach((val, index, array) ->
        header = val.split(':')
        t = header[0].toLowerCase()
        v = header[1..].join(':').replace(' ', '')
        if t isnt '' and v isnt ''
          headers[t] = v
      )
      options.success?(data, headers)
    error = (e) =>
      #@Log(e)
      options.fail?(e.target)
    abort = (e) =>
      #@Log(e)
      options.fail?(e.target)

    ajax.addEventListener('progress', progress, false)
    ajax.addEventListener('load', load, false)
    ajax.addEventListener('error', error, false)
    ajax.addEventListener('abort', abort, false)

    for key of options.headers
      @Log("Setting #{options.headers[key]} for #{key}")
      ajax.setRequestHeader(key, options.headers[key])

    ajax.send(options.data)

  #
  #
  Ajax: (url, method='GET', rdata, rheaders) ->
    method.toUpperCase()
    @Log("Doing #{method} on #{url}")
    @Log(rdata) if rdata
    promise =
      id: 'method:{#url}'

    @_ajax(
      url: url
      method: method
      withCredentials: false
      headers: rheaders
      data: rdata
      progress: (status) =>
        #@Log('progress')
        #@Log(status)
        promise.status?(status)
      success: (data, headers) =>
        #@Log('Success')
        result =
          'toArray': ->
            data
          'toString': ->
            dataStr = ''
            bufSize = 2048
            for dbyte, i in data by bufSize
              n = 'number'
              if typeof data[i] is n and typeof data[i+bufSize] is n
                chunk = data.subarray(i,i+bufSize)
                try
                  dataStr += String.fromCharCode.apply(null, chunk)
                catch err
                  ln = chunk.length
                  for i in [0..ln]
                    if chunk[i] isnt undefined
                      dataStr += String.fromCharCode(chunk[i])
              else
                chunk = data.subarray(i, data.length)
                try
                  dataStr += String.fromCharCode.apply(null, chunk)
                catch err
                  ln = chunk.length
                  for i in [0..ln]
                    if chunk[i] isnt undefined
                      dataStr += String.fromCharCode(chunk[i])
            dataStr
          'toBase64': ->
            btoa(@toString())
          'toJSON': ->
            try
              JSON.parse(@toString())
            catch
              json =
                data: @toString()
          'toXML': ->
            parser = new DOMParser()
            parser.parseFromString(@toString(), 'text/xml')
          'headers': ->
            headers
        promise.then?(null, result)
      fail: (err) =>
        #@Log('Fail')
        promise.then?(err, null)
    )
    promise

  #
  #
  Query: (selector, first=true, scope) ->
    root = scope or document
    query = root.querySelectorAll?(selector)

    results =
      '_qvals': {}
      '_qkeys': []
      'length': 0
      'pop': ->
        _key = @_qkeys.pop()
        _q = @_qvals[_key]
        @_qvals[_key] = null
        return _q

    for el in query
      results._qvals = []
      results._qkeys.push(selector)
      if not el.on
        el.on = (event, func) ->
          if typeof event isnt 'string'
            for evt in event
              el.addEventListener(evt, func, false)
          else
            el.addEventListener(event, func, false)
      results._qvals[selector] = el
      results.length++
    if first then return results.pop()
    else return results

  #
  #
  #
  #
  Append: (options) ->
    #@Log(options)
    child = document.createElement(options.type)
    attributes = options.attributes
    for val of attributes
      #@Log(val, attributes[val])
      child.setAttribute(val, attributes[val])
    if not child.on
      child.on = (event, func) ->
        if typeof event isnt 'string'
          for evt in event
            child.addEventListener(evt, func, false)
        else
          child.addEventListener(event, func, false)
    #@Log(child)
    child.innerHTML = options.html
    if not options.parent
      @body.appendChild(child)
    else
      options.parent.appendChild(child)
    child

  #
  #
  Cache: (key, value, persist, options) ->
    if typeof value is 'undefined'
      v = @_cache[key]
      if typeof v is 'undefined'
        try
          stash = JSON.parse(window.sessionStorage[key]) if window.sessionStorage[key]
          stash = JSON.parse(window.localStorage[key]) if not stash and window.localStorage[key]
          if stash and stash.expires
            v = stash.value
        catch err
          @Log(err)
      if typeof v is 'undefined'
        map = {}
        for c in document.cookie.split('; ')
          kv = c.split('=')
          k = kv[1]
          k = unescape(k)
          map[kv[0]] = k
          try
            @Log(k)
            _n = JSON.parse(k)
            map[kv[0]] = _n
          catch err
            @Log(err)
        v = map[key]
      @_cache[key] = v
      return v
    else
      if options?.noInMemory isnt false
        @_cache[key] = value

      if persist is true
        domain = options?.domain or window.location.hostname
        time = options?.time
        if time
          date = new Date()
          expires = new Date()
          if not time.days
            time.days = 0    
          expires.setTime(date.getTime() + time.days)

          if not time.hours
            time.hours = 0
          else
            time.hours *= 3600000
          expires.setTime(expires.getTime() + time.hours)

          if not time.minutes
            time.minutes = 0
          else
            time.minutes *= 60000
          expires.setTime(expires.getTime() + time.minutes)

          if not time.seconds
            time.seconds = 0
          else
            time.seconds *= 1000
          expires.setTime(expires.getTime() + time.seconds)

          expires = expires.toGMTString()
        else
          expires = 'never'

        if options?.noLocalstorage isnt false
          stash =
            value: value
            expires: expires
            domain: domain
          stash = JSON.stringify(stash)
          window.localStorage[key] = stash
          window.sessionStorage[key] = stash
        if options?.noCookies isnt false
          value = JSON.stringify(value) if typeof value isnt 'string'
          document.cookie = "#{escape(key)}=#{escape(value)}; expires=#{expires}; domain=#{domain}; secure=true;"
