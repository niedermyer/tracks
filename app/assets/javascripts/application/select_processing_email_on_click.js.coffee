$(document).on 'turbolinks:load', ->

  $('span.processing-email-output').click ->
    $this = $(this)
    text = $this.text()
    $input = $('<input type=text class="form-control disabled processing-email-output" readonly autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false">')
    $input.prop 'value', text
    $input.insertAfter $this
    $input.focus()
    $input.select()
    $this.hide()
    $input.focusout ->
      $this.show()
      $input.remove()
