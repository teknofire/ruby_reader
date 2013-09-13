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
  
# $(document).ajaxStart =>
#   unless spinner?
#     refresh = $('#refresh')
#     $('#refresh').removeClass('btn-danger').html('<i class="icon-refresh icon-spin"></i>')
# 
# spinner = null
# $(document).ajaxComplete =>
#   clearTimeout(spinner) if spinner?
#   spinner = setTimeout -> 
#     if $('#refresh i.icon-refresh')
#       $('#refresh i.icon-refresh').removeClass('icon-spin');
#     spinner = null
#   , 1000
  

statechange = (evt) ->
  # evt.preventDefault()
  state = History.getState()
  
  if state.data and state.data.tracked
    $.ajax({ url: state.data.href, dataType: 'script' })

monitorSelector = '.entry'
$(window).scroll ->
  morebtn = $('#more-results-btn')
  
  if morebtn.inViewport(0)
    if !morebtn.data('viewable')
      morebtn.data('viewable', true)
      # morebtn.button('loading')
      # setTimeout => 
      #   morebtn.button('reset')
      # , 1000
      morebtn.click()
      
  else
    if morebtn.data('viewable')
      morebtn.data('viewable', false)
    
    
  for item in $(monitorSelector)
    if $(item).inViewport(400)
      if !$(item).data('viewable')
        $(item).data('viewable', true)
        $(item).trigger('scrolledIntoView')
    else
      if $(item).data('viewable')
        $(item).data('viewable', false)
        $(item).trigger('scrolledOutofView')
    
$(document).ready ->
  History.Adapter.bind(window, 'statechange', statechange)
  height = $('#sidebar').height()
  $('#content').css('min-height', height)
  $('.entry:first').addClass('active')

# $(document).on('scrolledOutofView', '.entry', (evt) ->
#   if $(this).hasClass('active')
#     next = $(this).next()
#     prev = $(this).prev()
#     if $(next).inViewport()
#       $(next).addClass('active')
#       $(this).removeClass('active')
#     else if $(prev).inViewport()
#       $(prev).addClass('active')
#       $(this).removeClass('active')
# )

$(document).on('scrolledIntoView', '.entry', (evt) ->
  prev = $('.entry.active')
  prev.removeClass('active')
  $(this).addClass('active')
  read_url = $(prev).find('.unread').data('readUrl')
  
  if read_url?
    $.ajax({ url: read_url, method: 'PATCH' })
    $(prev).find('.unread').remove()
)

$(window).focus ->
  $('#refresh').html('<i class="icon-spinner icon-spin"></i>')
  published = $('.entry:first').data('published')
  $.ajax({ url: '/', data: { count: true }, dataType: 'script'})