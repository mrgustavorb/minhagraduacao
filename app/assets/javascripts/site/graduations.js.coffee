# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  # Combobox Methods
  $('#combo_method').change ->
    val = @value
    graduation = $(@).attr('data-graduation')

    $('#combo_uf').empty().append $('<option>').text('--').attr 'value', '0'
    $('#combo_city').empty().append $('<option>').text('--').attr 'value', '0'

    $('.ies-graduation-area').html ''
    $('.progress').css 'display', 'block'

    if val != ''
      if val == '1'
        $.ajax
          type: 'GET'
          url: "/institutions/ufs/#{graduation}"  
          success: (rt) ->
            select = $('#combo_uf')
            select.empty()
            option = $('<option>').text('Estado:').attr 'value', '0'
            select.append option

            $('#combo_city').empty().append $('<option>').text('Selecione um estado').attr 'value', '0'

            $(rt).each (i,r) ->
              option = $('<option>').text(r.name).attr 'value', r.id
              select.append option  
      $.ajax
        type: 'GET'
        url: "/institutions/where_to_study/#{val}/#{graduation}"        

  # Combobox Ufs
  $('#combo_uf').change ->
    val = @value
    url_friendly = $(@).attr('data-graduation')

    $('.ies-graduation-area').html ''
    $('.progress').css 'display', 'block'

    if val != ''
      $.ajax
        type: 'GET'
        url: "/institutions/where_to_study_in_a_state/#{val}/#{url_friendly}"        
      $.ajax
        type: 'GET'
        url: "/cities/find_by_uf/#{val}/#{url_friendly}"  
        success: (rt) ->
          select = $('#combo_city')
          select.empty()
          option = $('<option>').text('Selecione uma cidade:').attr 'value', '0'
          select.append option
          $(rt).each (i,r) ->
            option = $('<option>').text(r[1]).attr 'value', r[0]
            select.append option  

  # Combobox Cities
  $('#combo_city').change ->
    val = @value
    url_friendly = $(@).attr('data-graduation')
    $('.ies-graduation-area').html ''
    $('.progress').css 'display', 'block'
    $.ajax
      type: 'GET'
      url: "/institutions/where_to_study_in_a_city/#{val}/#{url_friendly}"

  # When mobile hide filters graduation in choosing the opinion that the User wishes to see 
  if $('.in-mobile-choice-opinion').length > 0 && isMobile()
    $('.col-filters').addClass('hidden')

  return