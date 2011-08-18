$(document).ready(function (){

  // the hover over effect on navbar
  $('.navsub').kwicks({
    max: 150,
    min: 80, 
    spacing: 15,
  });

  // define the hover in/out property on the sjj box
  $('#boxcontainer').hover(function() {
    $('#box').stop().animate({
      width: "95%",
    }, 1000);
  },
  function() {
    $('#box').stop().animate({
      width: "50px",
    }, 1000);
  });

  // when the site loads, animate sjj box to the left
  $('#box').animate({
    width: "50px",
  }, 1000);

  // hover over effect for social icons
  $('.iconcontainer').hover(function() {
    $(this).animate({
      opacity: 1.0,
    }, 500);
  },
  function() {
    $(this).animate({
      opacity: 0.5,
    }, 500);
  });

  // bring the social icons down
  $('.iconcontainer').each(function(index) {
    $(this).animate({
      opacity: 0.5,
      top: 0,
    }, 2000);
  });

  // load tweets
  getTwitters('tweet', { 
    id: '_sjackson', 
    count: 5, 
    enableLinks: true, 
    ignoreReplies: true, 
    clearContents: false,
    template: '<p>%text%<br/> &nbsp;&nbsp;&mdash; <a href="http://twitter.com/%user_screen_name%/statuses/%id_str%/">%time%</a></p>',
  });
});
