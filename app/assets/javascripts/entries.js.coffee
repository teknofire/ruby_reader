# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).on 'click', '.entries .content a', (evt) ->
  evt.preventDefault()
  window.open($(this).attr('href'))
  
  
$(document).on 'click', 'a[data-track-history="true"]', (evt) ->
  evt.preventDefault();
  return false if $(this).data('disabled')
  
  href = $(this).attr('href')
  History.pushState({ tracked: true, href: href }, 'RubyReader', href)  
  
statechange = (evt) ->
  # evt.preventDefault()
  state = History.getState()
  
  if state.data and state.data.tracked
    $.ajax({ url: state.data.href, dataType: 'script' })


$(document).ready ->
  History.Adapter.bind(window, 'statechange', statechange)