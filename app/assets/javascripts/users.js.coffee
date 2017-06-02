$ ->
  if $('body#users').length > 0
    if $('body.show').length > 0
      $('.table').dataTable()
      $('.table_row_hover').on 'click', ->
        url = $(this).data('url')
        window.location = url