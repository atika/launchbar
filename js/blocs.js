// Loading page complete
$(window).load(function()
{
	checkHero(); // Check hero height is correct
	animateWhenVisible();  // Activate animation when visible	
});

// Page ready
$(document).ready(function()
{
	$('.hero').css('height', $(window).height()+'px'); // Set initial hero height
	$('#scroll-hero').click(function()
	{
		$('html,body').animate({scrollTop: $("#hero-bloc").height()}, 'slow');
	});
	
	setUpLightBox(); // Add lightbox Support
});

// Window resize 
/*
$(window).resize(function()
{		
	$('.hero').css('height',getHeroHeight()+'px'); // Refresh hero height  	
}); 
 */

// Get Hero Height
function getHeroHeight()
{
	var H = $(window).height(); // Window height
	
	if(H < heroBodyH) // If window height is less than content height
	{
		H = heroBodyH+100;
	}
	return H
}

// Check hero height
function checkHero()
{
	if($('#hero-bloc').length)
	{
		P = parseInt($('.hero-nav').css('padding-top'))*2
		window.heroBodyH = $('.hero-nav').outerHeight()+P+$('.vc-content').outerHeight()+50; // Set hero body height
		$('.hero').css('height', getHeroHeight() + 'px'); // Set hero to fill page height
	}
}

// Scroll to target
function scrollToTarget(D)
{
	if(D == 1) // Top of page
	{
		D = 0;
	}
	else if(D == 2) // Bottom of page
	{
		D = $(document).height();
	}
	else // Specific Bloc
	{
		D = $(D).offset().top;
		if($('.sticky-nav').length) // Sticky Nav in use
		{
			D = D-100;
		}
	}

	$('html,body').animate({scrollTop:D}, 'slow');
}

// Initial tooltips
$(function()
{
  $('[data-toggle="tooltip"]').tooltip()
})


// Animate when visible
function animateWhenVisible()
{
	hideAll(); // Hide all animation elements
	inViewCheck(); // Initail check on page load
	
	$(window).scroll(function()
	{		
		inViewCheck(); // Check object visability on page scroll
		scrollToTopView(); // ScrollToTop button visability toggle
		stickyNavToggle(); // Sticky nav toggle
	});		
};

// Hide all animation elements
function stickyNavToggle()
{
	var V = 0; // offset Value
	var C = "sticky"; // Classes
	
	if($('.sticky-nav').parent().is('#hero-bloc')) // If nav is in hero animate in
	{
		V = $('.sticky-nav').height();
		C = "sticky animated fadeInDown";
	}
	
	if($(window).scrollTop() > V)
	{  
		$('.sticky-nav').addClass(C);
		
		if(C == "sticky")
		{
			$('.page-container').css('padding-top',$('.sticky-nav').height());
		}
	}
	else
	{
		$('.sticky-nav').removeClass(C);
		$('.page-container').removeAttr('style');
	}	
}

// Hide all animation elements
function hideAll()
{
	$('.animated').each(function(i)
	{	
		if(!$(this).closest('.hero').length) // Dont hide hero object
		{
			$(this).removeClass('animated').addClass('hideMe');
		}
	});
}

// Check if object is inView
function inViewCheck()
{	
	$($(".hideMe").get().reverse()).each(function(i)
	{	
		var target = jQuery(this);
		var a = target.offset().top + target.height();
		var b = $(window).scrollTop() + $(window).height();
		
		if(target.height() > $(window).height()) // If object height is greater than window height
		{
			a = target.offset().top;
		}
		
		if (a < b) 
		{	
			var objectClass = target.attr('class').replace('hideMe' , 'animated');
			target.css('visibility','hidden').removeAttr('class');
			setTimeout(function(){target.attr('class',objectClass).css('visibility','visible');},0.01);				
		}
	});
};

// ScrollToTop button toggle
function scrollToTopView()
{
	if($(window).scrollTop() > $(window).height()/3)
	{	
		if(!$('.scrollToTop').hasClass('showScrollTop'))
		{
			$('.scrollToTop').addClass('showScrollTop');
		}	
	}
	else
	{
		$('.scrollToTop').removeClass('showScrollTop');
	}
};

// Light box support
function setUpLightBox()
{
	window.targetLightbox;
	
	$(document).on('click', '[data-lightbox]', function(e) // Create Lightbox Modal
	{
		e.preventDefault();
		targetLightbox = $(this);
		var captionData ='<p class="lightbox-caption">'+$(this).attr('data-caption')+'</p>';
		if(!$(this).attr('data-caption')) // No caption caption data
		{
			captionData = '';
		}
		
		var customModal = $('<div id="lightbox-modal" class="modal fade"><div class="modal-dialog"><div class="modal-content '+$(this).attr('data-frame')+'"><button type="button" class="close close-lightbox" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button><div class="modal-body"><a href="#" class="prev-lightbox" aria-label="prev"></a><a href="#" class="next-lightbox" aria-label="next"></a><img id="lightbox-image" class="img-responsive" src="'+$(this).attr('data-lightbox')+'">'+captionData+'</div></div></div></div>');
		$('body').append(customModal);
		$('#lightbox-modal').modal('show');
		
		// Handle navigation buttons (next - prev)
		if($('a[data-lightbox]').index(targetLightbox) == 0)
		{
			$('.prev-lightbox').hide();
		}
		if($('a[data-lightbox]').index(targetLightbox) == $('a[data-lightbox]').length-1)
		{
			$('.next-lightbox').hide();
		}
	}
	).on('hidden.bs.modal', '#lightbox-modal', function () // Handle destroy modal 
	{
		$('#lightbox-modal').remove();
	})
	
	$(document).on('click', '.next-lightbox, .prev-lightbox', function(e) 
	{
		var idx = $('a[data-lightbox]').index(targetLightbox);
		var next = $('a[data-lightbox]').eq(idx+1) // Next
		
		if($(this).hasClass('prev-lightbox'))
		{
			next = $('a[data-lightbox]').eq(idx-1) // Prev
		}
		$('#lightbox-image').attr('src',next.attr('data-lightbox'));
		$('.lightbox-caption').html(next.attr('data-caption'));
		targetLightbox = next;	
		
		// Handle navigation buttons (next - prev)
		$('.next-lightbox, .prev-lightbox').hide();	
		
		if($('a[data-lightbox]').index(next) != $('a[data-lightbox]').length-1)
		{
			$('.next-lightbox').show();
		}
		if($('a[data-lightbox]').index(next) > 0)
		{
			$('.prev-lightbox').show();
		}
	});
}