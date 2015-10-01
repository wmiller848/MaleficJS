# Malefic JS #

* Includes Underscore 1.7.0
* Includes Handlebars 2.0.0

## About ##
MaleficJS is a utility belt for building modular web applications.
It features a promise based API for http request, and is binary safe.
Designed to work easily with both video data or JSON utf8 data. MaleficJS can be
used to create widget based applications that can utilize a message based api.
MaleficJS is designed to work seamlessly with web sockets and modern HTML5 features.

## Usage ##
\* All examples are in coffee script

### Malefic.Core ###

#### Random ####
Get a random string of a specified size

@Params
* size - required

```
  core_www = new Malefic.Core()
  random_string = core_www.Random(size)
  # ab717ofn1ajkbacib1b1o
```

#### Log ####
Malefic console log

@Params
* message - required

```
  core_www = new Malefic.Core()
  core_www.Log('Something to log')
```

#### FuncName ####
Get the function name by function reference

@Params
* function - required

```
  core_www = new Malefic.Core()
  core_www.Log('Something to log')
```

#### Watch ####
Create an observer on a given object

@Params
* object - required

```
  obj =
    'key': 'value'
  core_www = new Malefic.Core()
  observer = core_www.Watch(obj)
  observer.On('update', (info) ->
    console.log(info)
  )
  observer.On('add', (info) ->
    console.log(info)
  )
  observer.On('remove', (info) ->
    console.log(info)
  )

  obj['new_key'] = 'new_value'
```

#### Domain ####
Get the root domain

@Params
* url - optional, default=window.location.host

```
  core_www = new Malefic.Core()
  domain = core_www.Domain()
  # www.google.com -> google.com
  # sub.domain.google.com -> google.com
```

#### Ajax ####
Make a async http request

@Params
* url - required
* method - optional, default='GET'
* data - optional, default=null
* headers - optional, default=null

```
  core_www = new Malefic.Core()
  request = core_www.Ajax(url, method, data, headers)
  request.Then = (err, response) ->
    console.log(err, response)

    # Get Uint8Array
    uint8_array = response.toArray()

    # Get utf8 string
    utf_string = response.toString()

    # Attempt to get parsed XML
    xml = response.toXML()

    # Attempt to get parsed JSON
    json = response.toJSON()
```

#### Query / Q ####
Find an element or elements in the DOM

@Params
* selector - required
* first - optional, default=false
* element - optional, default=document

```
  core_www = new Malefic.Core()
  el = core_www.Query('#some_id', first, element)
```

#### Append / A ####
Append an element to the DOM

@Params
* options - required

```
  core_www = new Malefic.Core()
  opt =
    'type': 'div',
    'parent' document.body
  el = core_www.Append(opt)
  # or
  el = core_www.A(opt)
```

#### Remove / R ####
Append an element to the DOM

@Params
* parent - required
* node or nodes - required

```
  core_www = new Malefic.Core()
  el = core_www.Remove(parent, node)
  # or
  el = core_www.R(parent, node)
```

#### Cache / C ####
Get or set a key value pair

@Params
* key - required
* value - optional
* persist - optional
* options - optional

```
  core_www = new Malefic.Core()

  # In memory only
  core_www.Cache('some_key', 'some_val')
  val = core_www.Cache('some_key')
  # or
  core_www.C('some_key', 'some_val')
  val = core_www.C('some_key')

  # Persistent
  core_www.Cache('some_key', 'some_val', true)
  # reload page
  val = core_www.Cache('some_key')

  # Persistent with options
  opt =
    domain: window.location.hostname,
    time:
      days: 0,
      hours: 1,
      minutes: 30,
      seconds: 15
    noLocalstorage: false,
    noCookies: false
  core_www.Cache('some_key', 'some_val', true, opt)
  # reload page
  val = core_www.Cache('some_key')
```

### Malefic.View ###

### Malefic.Stream ###

### Malefic.Model ###
