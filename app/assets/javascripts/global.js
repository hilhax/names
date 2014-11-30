jQuery(document).ready(function($) {
  // Add change event handler to all Filterrific filter inputs.
  $(document).on(
    "click",
    ".letter",
    Filterrific.submitFilterForm
  );

  $('.letter').click(function (e) {
	  	e.preventDefault(); // Prevent link from following its href
	  	console.log($('#hidden_letter').val());
  		$('#hidden_letter').val(this.innerHTML);  		  		
	});
});

