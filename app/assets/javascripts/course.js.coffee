# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#
$ ->
  if $('body#courses').length > 0
    $('.table').dataTable()
    $('.course_row').on 'click', ->
      url = $(this).data('url')
      window.location = url

    $('#calculate_tutors').on 'click', (e) ->
      e.preventDefault()
      _this = $(this)
      $.ajax
        url: "/courses/#{$(_this).data('id')}/get_no_required_tutors"
        type: "get"
        data: { enrol: $('#course_enrollment_number').val() }
        success: (data) ->
          $('#course_tutors_required').val(data['value'])

