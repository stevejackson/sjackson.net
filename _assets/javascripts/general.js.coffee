
$ ->
  $('#see_more').on('click', ->
    $('html, body').animate({
        scrollTop: $('#features_row_1').offset().top
      },
      1000
    )
  )
