
var winSize = '';

function winUpdate() {
	var newWinSize = 'xs';
	if ($(this).width() >= 1200) { newWinSize = 'lg'; }
	else if ($(this).width() >= 992) { newWinSize = 'md'; }
	else if ($(this).width() >= 768) { newWinSize = 'sm'; }

	if( newWinSize !== winSize ) {
		winSize = newWinSize;

		if (winSize === "xs") {
			$(".col-left, .col-right").height("");
		}else{
			$(".col-left, .col-right").height(Math.max($(".col-left").height(), $(".col-right").height()));
		}
	}
}

$(document).ready(function(){
	window.onresize = winUpdate;
	winUpdate();
});
