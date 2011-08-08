
/* trigger when page is ready */
$(document).ready(function (){

	colorCycle();

	function colorCycle() {
		var hue = 'rgb(' + (Math.floor(Math.random() * 256)) + ',' + (Math.floor(Math.random() * 256)) + ',' + (Math.floor(Math.random() * 256)) + ')';

		$('#box').animate({
			width: "100%", 
			backgroundColor: "blue",
		}, 1000);
	}

	$('.navsub').kwicks({
		max: 150,
		min: 80, 
		spacing: 5
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
});
