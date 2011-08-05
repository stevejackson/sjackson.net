// remap jQuery to $
(function($){})(window.jQuery);

alert('test2');

/* trigger when page is ready */
$(document).ready(function (){

	alert('moon landing');
	$().ready(function() {
		alert('test');
		$('.navsub').html("test");
		$('.navsub').kwicks({
			max: 205,
			spacing: 5
		});
	}

});


/* optional triggers

$(window).load(function() {
	
});

$(window).resize(function() {
	
});

*/
