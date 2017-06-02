# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

$ ->
  if $('body#tutor_applications').length > 0
    if $('body.index').length > 0
      $('.table').dataTable()
      $('.table_row_hover').on 'click', ->
        url = $(this).data('url')
        window.location = url

    $('#allocate_submit').on 'click', (e) ->
      checked = $('.allocate_menu input:checked')
      url = "#{$(this).attr('href')}?"
      for i in checked
        url = "#{url}ids%5B%5D=#{$(i).val()}&"
      console.log url
      $(this).attr('href', url)


    $('.dropdown-menu, .dropdown-menu input, .dropdown-menu label').on 'click', (e) ->
      e.stopPropagation()

    $('#update_pay_form').on "ajax:success", (e, data, status) ->
      text = if data.scholarship then "#{data.pay_rate} (Scholarship)" else data.pay_rate
      $('#pay_rate').hide().text(text).fadeIn()
      $('#pay_rate_status').text("✓").show().delay(3000).fadeOut()

    $('#update_pay_form').on "ajax:error", (e, data, status) ->
      $('#pay_rate_status').text("✗").show().delay(3000).fadeOut()

    $('.filter_button').on 'click', (e) ->
      e.preventDefault()
      if($(this).hasClass('active'))
        $(this).removeClass('active')
        $('#filters').val($('#filters').val().concat(" " + $(this).text()))
      else
        $(this).addClass('active')
        filters = $('#filters').val()
        _this = $(this)
        $('#filters').val((filters.replace $(_this).text(), "").trim())

    $.each($('.filter_button'), (index, button) ->
      if $('#filters').val().lastIndexOf($(button).text()) is -1
        $(button).addClass('active')
    )

$ ->
  $('.prev-exp-radio').change ->
    if $('#prev-exp-radio-yes')[0].checked
      $('.prev_exp_input').removeClass 'hidden'  
    else
      $('.prev_exp_input').addClass 'hidden'
      $('.prev_exp_input').val ""

