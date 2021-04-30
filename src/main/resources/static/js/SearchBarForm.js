$(function(){
	var searchOptions = ["Home", "About", "Services", "E-Resources", "Facts and Figures",
						"Admin Login", "Student Login", "Student Signup", "Know Your Library"];
	
	$("#searchBar").autocomplete({
		source: searchOptions,
		autoFocus:true,
		delay: 0,
		response: function(event, ui) {
	        if (!ui.content.length) {
	            var noResult = { value:"",label:"No results found" };
	            ui.content.push(noResult);
	        }
	    }
	});
});
