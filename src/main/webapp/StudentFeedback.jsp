<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
	<script src="https://use.fontawesome.com/ec453aebd2.js"></script>
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
  	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
  	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
  	<link href="https://fonts.googleapis.com/css?family=Josefin+Sans&display=swap" rel="stylesheet">
  	<link rel="stylesheet" type="text/css" href="/css/loaderStyle.css">
  	
<title>Central Institute Library</title>
</head>
<body style="overflow-x:hidden">

<script>
    $(window).on("load",function(){
      $(".loader-wrapper").fadeOut("slow");
    });
</script>
<div class="loader-wrapper">
	<span class="loader">
		<span class="loader-inner"></span>
	</span>
</div>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark" style="margin-top:1px">
  <a class="navbar-brand" href="#"><i class="fa fa-book" aria-hidden="true"></i> Central Institute Library <i class="fa fa-user" aria-hidden="true"></i></a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
 
  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav mr-auto">
      <li class="nav-item ml-5 mr-3">
        <a class="nav-link" href="studentPage">Home <span class="sr-only">(current)</span></a>
      </li>
      <li class="nav-item mr-3">
        <a class="nav-link" href="StudentAbout.jsp">About</a>
      </li>
       <li class="nav-item mr-3">
        <a class="nav-link" href="StudentEresources.jsp">E-Resources</a>
      </li>
      <li class="nav-item dropdown mr-3">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          Book Details
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
          <a class="dropdown-item" href="bookList">Book List</a>
          <a class="dropdown-item" href="studentIssueHistory">Issue History</a>
        </div>
      </li>
      <li class="nav-item active dropdown mr-3">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          Others
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
          <a class="dropdown-item" href="StudentUpdateDetails.jsp">Update Details</a>
          <a class="dropdown-item" href="#">Feedback</a>
        </div>
      </li>
      <li class="nav-item mr-3 mt-1">
        <form action="logout">
        <button class="btn btn-outline-danger my-2 my-sm-0" type="submit">Logout</button>
        </form>
      </li>
    </ul>
    <h6 class="text-white text-center mr-5 my-auto">Welcome <%=session.getAttribute("studentUsername") %>!</h6>
  </div>
</nav>

<a id="feedbackSubmittedButton" style="display:none" data-toggle="modal" data-target="#feedbackSubmittedModal">Feedback Submitted Button</a>

<form:form action="storeStudentFeedback" id="feedbackForm" method="post" class="container mx-auto my-4 bg-light py-2" style="font-weight: bold">
<h1 class="text-center">Feedback Form</h1>
<hr class="w-50">
	<div class="form-group mt-4">
		<label>Username</label>
		<input type="hidden" name="username" class="form-control" value="${username}">
	    <input type="text" class="form-control" disabled value="${username}">
	</div>
	<div class="form-group mt-4">
		<label>Name</label>
	    <input type="text" name="name" class="form-control" disabled value="${name}">
	</div>
  	<div class="form-group mt-4">
	  	<label>Message</label>
	  	<textarea name="message" class="form-control"></textarea>
  	</div>
  <button type="submit" class="btn btn-danger">Submit</button>
</form:form>

				<!-- Feedback submitted Modal -->
<div class="modal fade" id="feedbackSubmittedModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content" style="background-color:#AEF99B">
    <div class="modal-header">
      <h5 class="modal-title"><i class="fa fa-check-circle fa-2x" aria-hidden="true"></i></h5>
      <button type="button" onclick="Redirect()" style="position:absolute; right:10px" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
      </button>
    </div>
      <div class="modal-body text-dark mt-0 pt-0 font-weight-bold">
        We have received your feedback.<br> Thank You!
      </div>
    </div>
  </div>
</div>

						<!-- Contact Modal -->
<div class="modal fade" id="contactModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Contacts</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <span class="font-weight-bold">Call Us At:</span> +91 9862457328
        <br>
        <span class="font-weight-bold">Mail Us At:</span> CentralInstituteLibrary@gmail.com
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<c:if test="${feedbackSubmitted != null}">
	<script>
		document.getElementById("feedbackSubmittedButton").click();
	</script>
</c:if>

<script type="text/javascript">
	function Redirect()
	{
		window.location="https://library-portal.herokuapp.com/studentFeedback";
	}
</script>

<section class="row mt-2">
<footer class="container-fluid" style="position:fixed; left:0; bottom:0; width:100%;">
  <div class="bg-dark text-white">
  <span class="col-md-4" style="float: left">&copy copyright by Central Institute Library 2020</span>
  <span class="col-md-6 text-center" style="margin-left: 100px">
    <a href="https://www.facebook.com"><i class="fa fa-facebook fa-2x mx-2"></i></a>
    <a href="https://twitter.com/login"><i class="fa fa-twitter fa-2x mx-2"></i></a>
    <a href="https://www.instagram.com/?hl=en"><i class="fa fa-instagram fa-2x mx-2"></i></a>
    <a href="https://aboutme.google.com/u/0/?referer=gplus""><i class="fa fa-google-plus fa-2x mx-2"></i></a>
    <a href="https://www.google.com/intl/en-GB/gmail/about/"><i class="fa fa-envelope fa-2x mx-2"></i></a>
  </span>
  <span class="col-md-2" style="float: right"><a href="#" style="color: white; margin-left: 110px">Back to top</a></span>
</div>
</footer>
</section>

<style>
@media screen and (max-width: 640px){
  #feedbackForm{
  	width:80%;
  	margin:auto;
  }
}

@media screen and (min-width: 641px){
  #feedbackForm{
  	width:40%;
  	margin:auto;
  }
}
</style>

</body>
</html>