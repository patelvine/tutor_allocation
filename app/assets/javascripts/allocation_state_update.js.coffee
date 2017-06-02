clear = (id) ->
  return () ->
    $("#alloc-update-status-" + id).css "display", "none"

showStatus = (text, id, overallocated) ->
  if overallocated
    $("#allocation-row-" + id).addClass "overallocated"
  else
    $("#allocation-row-" + id).removeClass "overallocated"
  $("#alloc-update-status-" + id).css "display", "inline"
  $("#alloc-update-status-" + id).text text
  setTimeout clear(id), 3000

jQuery ($) ->
  $(".allocation-link-state").change ->
    _this = this
    id = $(_this).data("id")
    state = $(this).val()
    $.ajax
      url: "/allocation_link/" + id + "/update_state"
      type: "put"
      data:
        allocation_link:
          state: state
      success: (data) ->
        showStatus "✓", id, data.overallocated
        return
      error: (data) ->
        showStatus "✗", id, data.overallocated
        return
    return
  return