# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $(document).trigger('page:videos')
  return

$(document).on 'page:videos', ->

  $('#new_user').submit (evt) ->
    unless $('#agree-use-term')[0].checked
      alert 'Você precisa concordar com o termo de uso.'
      $('#agree-use-term').focus()
      evt.preventDefault()
      return false

  return