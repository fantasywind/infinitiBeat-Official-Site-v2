canvasDOM = $("canvas")

# Event on Change Window Size
canvasDOM.on 'resizeWindow', (e)->
  $this = $(@)
  $this.attr 'height', window.innerHeight
  $this.attr 'width', window.innerWidth

# Event on Initial Site
canvasDOM.on 'initial', (e)->
  resource = {
    functions: []
    loaded: 0
    objects: {}
  }
  $this = $(@)
  $this.trigger 'resizeWindow'
  $this.data 'resource', resource
  
  # Load Logo Image - Queue
  resource.functions.push ->
    resource.objects.logo = new Image()
    resource.objects.logo.onload = ->
      $this.trigger 'resourceLoaded'
    resource.objects.logo.src = '/images/logo.png'
  
  # Start Loading Resource
  $this.trigger 'loadResource'

# Event on Start Loading Resource
canvasDOM.on 'loadResource', (e)->
  resource = $(@).data 'resource'
  for fn in resource.functions
    fn()

# Event on Resource Loaded
canvasDOM.on 'resourceLoaded', (e)->
  $this = $(@)
  resource = $this.data 'resource'
  resource.loaded += 1
  $this.trigger 'initCanvas' if resource.loaded is resource.functions.length

# Event on Initial Canvas Object
canvasDOM.on 'initCanvas', (e)->
  context = @getContext '2d'
  if !context?
    console.error "Error on Initial Canvas.\nPlease use Chrome / Firefox / Safari / IE 9.0 to browser this site."
    return false
  
  # Resources
  resource = $(@).data 'resource'
  
  # Draw
  context.drawImage resource.objects.logo, window.innerWidth / 2 - resource.objects.logo.width / 2, window.innerHeight / 2 - resource.objects.logo.height / 2
    
# Initial Stie
canvasDOM.trigger 'initial'