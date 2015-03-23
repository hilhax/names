jQuery(document).ready(function($) {

  //$.ajax("/names/reset")
  
  // Add change event handler to all Filterrific filter inputs.
  $(document).on(
    "click",
    ".letter",
    Filterrific.submitFilterForm
  );

  $('.letter').click(function (e) {
	  	e.preventDefault(); // Prevent link from following its href
	  	//console.log($('#hidden_letter').val());
  		$('#hidden_letter').val(this.innerHTML);  		  		
      $('#filterrific_search_query').val('');
      $('.letter').removeClass( "btn-warning" ).addClass( "btn-primary" )
      $(this).removeClass( "btn-primary" ).addClass( "btn-warning" );
	});

  //console.log($('#hidden_letter').val());

  //Check to see if the window is top if not then display button
  $(window).scroll(function(){
    if ($(this).scrollTop() > 100) {
      $('.scrollToTop').fadeIn();
    } else {
      $('.scrollToTop').fadeOut();
    }
  });
  
  //Click event to scroll to top
  $('.scrollToTop').click(function(){
    $('html, body').animate({scrollTop : 0},800);
    return false;
  });

  //$('#filterrific_search_query').keypress(function(e) {
  //    $('#hidden_letter').val('');
  //});

});

