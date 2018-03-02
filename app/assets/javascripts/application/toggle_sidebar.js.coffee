$(document).on 'turbolinks:load', ->
  $('.toggle-track-details').on 'click', (event) ->
    event.preventDefault()

    $('#track-show-container').toggleClass('sidebar-in')