$.fn.inViewport = (wibble) ->
  viewportTop = $(window).scrollTop()
  viewportBottom = viewportTop + $(window).height()
  top = this.offset().top
  bottom = this.height() + top
  wibble = 200 unless wibble?
  
  return false unless this
  return false if bottom < (viewportTop + wibble) and top < (viewportTop + wibble)
  return false if bottom > (viewportBottom - wibble) and top > (viewportBottom - wibble)
  return true