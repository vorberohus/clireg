$(document).ready(function(){
	window.setInterval(function(){
		var el = $('#sec-left'), tl = parseInt(el.text());
		if(tl == 0)
			window.location = $('#rurl').text();
		else
			el.text(tl-1);
	},1000);
});
