$(document).ready(function (){

  $('.navsub').kwicks({
    max: 150,
    min: 80, 
    spacing: 15
  });

  $('#boxcontainer').hover(function() {
    $('#box').stop().animate({
      width: "50px",
      opacity: 1.0,
    }, 100);
  },
  function() {
    $('#box').stop().animate({
      width: "100%",
    opacity: 0.4,
    }, 1000);
  });

  $('#box').animate({
    width: "172px",
  }, 1000);

  colorCycle();

  function colorCycle() {
    var hue = 'rgb(' + (Math.floor(Math.random() * 256)) + ',' + (Math.floor(Math.random() * 256)) + ',' + (Math.floor(Math.random() * 256)) + ')';

    $('#box').animate({
    }, 2500);

  }

});
