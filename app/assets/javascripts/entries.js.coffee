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
  
$(document).ajaxStart ->
  $('#refresh i.icon-refresh').addClass('icon-spin')

spinner = null
$(document).ajaxComplete ->
  clearTimeout(spinner) if spinner?
  spiner = setTimeout -> 
    $('#refresh i.icon-refresh').removeClass('icon-spin')
  , 1000
  
statechange = (evt) ->
  # evt.preventDefault()
  state = History.getState()
  
  if state.data and state.data.tracked
    $.ajax({ url: state.data.href, dataType: 'script' })


$(document).ready ->
  History.Adapter.bind(window, 'statechange', statechange)