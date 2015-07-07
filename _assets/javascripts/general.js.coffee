
$ ->
  $('#see_more').on('click', ->
    $('html, body').animate({
        scrollTop: $('#features_row_1').offset().top
      },
      1000
    )
  )

  $('#contact_me').on('click', ->
    $('html, body').animate({
        scrollTop: $('section#contact_header').offset().top
      },
      1000
    )
  )
