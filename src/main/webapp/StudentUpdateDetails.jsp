<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page import="java.sql.*"%>
<%@page import="javax.servlet.http.*"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@page import="javax.servlet.ServletException"%>
<%@page import="java.io.IOException"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Central Institute Library</title>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
	<script src="https://use.fontawesome.com/ec453aebd2.js"></script>
	<link href="fontawesome-free-5.9.0-web\css\all.css" rel="stylesheet">
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
  	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
  	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
  	<link href="https://fonts.googleapis.com/css?family=Josefin+Sans&display=swap" rel="stylesheet">
  	<link href="https://fonts.googleapis.com/css2?family=PT+Serif&display=swap" rel="stylesheet">
  	<link rel="stylesheet" type="text/css" href="/css/loaderStyle.css">
</head>
<body>

<%
response.setHeader("Cache-Control","no-cache,no-store,must revalidate");
if(session.getAttribute("studentUsername")==null)
{
	response.sendRedirect("main.jsp");
}
%>

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
  <a class="navbar-brand mr-5" href="#"><i class="fa fa-book" aria-hidden="true"></i> Central Institute Library <i class="fa fa-user" aria-hidden="true"></i></a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
 
  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav mr-auto">
      <li class="nav-item mr-3">
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
          <a class="dropdown-item" href="#">Update Details</a>
          <a class="dropdown-item" href="studentFeedback">Feedback</a>
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

<div class="container mx-auto my-4" style="text-align:center">
	<button id="changeEmailButton" class="btn w-50 font-weight-bold text-white" style="background-color:#1DA3EB">Click to Change Email</button>
</div>

<div id="changeEmailForm" class="updateInfo" style="display:none">
	<form:form action="changeStudentEmail" method="post" class="container mx-auto my-4 bg-light py-2" style="font-weight: bold; border: solid">
	<h1 class="text-center" style="font-family: 'PT Serif', serif;">Change Email</h1>
	<hr class="w-50">
		<div class="text-center mb-2">
			<i class="fa fa-envelope fa-5x" aria-hidden="true"></i>
		</div>
		
		<c:if test="${wrongEmail != null}">
			<script>
				$(document).ready(function(){
					$('#changeEmailForm').show();
				});
			</script>
			<div class="alert alert-danger mt-3">
				Invalid current email entered!
			</div>
		</c:if>
		<c:if test="${changedEmail != null}">
			<script>
				$(document).ready(function(){
					$('#changeEmailForm').show();
				});
			</script>
			<div class="alert alert-success mt-3">
				Your email has been updated successfully!
			</div>
		 </c:if>
		<div class="container row mt-4">
			<div class="form-group col-md-6 col-lg-6">
				<label>Current Email</label>
			    <input type="email" name="presentEmail" class="form-control" placeholder="Enter current email" required value="${presentEmail}">
			</div>
			<div class="form-group col-md-6 col-lg-6">
				<label>New Email</label>
			    <input type="email" name="newEmail" class="form-control" placeholder="Enter new email" required value="${newEmail}">
			</div>
		</div>
	  	<div style="text-align:center" class="mt-1 mb-2">
	  		<button type="submit" class="btn btn-danger">Update</button>
	  	</div>
	</form:form>
</div>

<script>
$(document).ready(function(){
	$('#changeEmailButton').click(function(){
		$('#changeEmailForm').slideToggle("slow");
	});
});
</script>

<div class="container mx-auto my-4" style="text-align:center">
	<button id="changeContactButton" class="btn w-50 font-weight-bold text-white" style="background-color:#1DA3EB">Click to Change Contact</button>
</div>

<div id="changeContactForm" class="updateInfo" style="display:none">
	<form:form action="changeStudentContact" method="post" class="container mx-auto my-4 bg-light py-2" style="font-weight: bold; border: solid">
	<h1 class="text-center" style="font-family: 'PT Serif', serif;">Change Contact</h1>
	<hr class="w-50">
		<div class="text-center mb-2">
			<i class="fa fa-phone-square fa-5x" aria-hidden="true"></i>
		</div>
		
		<c:if test="${wrongContact != null}">
			<script>
				$(document).ready(function(){
					$('#changeContactForm').show();
				});
			</script>
			<div class="alert alert-danger mt-3">
				Invalid current contact entered!
			</div>
		</c:if>
		<c:if test="${changedContact != null}">
			<script>
				$(document).ready(function(){
					$('#changeContactForm').show();
				});
			</script>
			<div class="alert alert-success mt-3">
				Your contact has been updated successfully!
			</div>
		 </c:if>
		<div class="container row mt-4">
			<div class="form-group col-md-6 col-lg-6">
				<label>Current Contact</label>
			    <input type="text" id="contact" name="presentContact" class="form-control" placeholder="Enter current contact" required value="${presentContact}">
			</div>
			<div class="form-group col-md-6 col-lg-6">
				<label>New Contact</label>
			    <input type="text" id="contact" name="newContact" class="form-control" placeholder="Enter new contact" required value="${newContact}">
			</div>
		</div>
	  	<div style="text-align:center" class="mt-1 mb-2">
	  		<button type="submit" class="btn btn-danger">Update</button>
	  	</div>
	</form:form>
</div>

<script>
$(document).ready(function(){
	$('#changeContactButton').click(function(){
		$('#changeContactForm').slideToggle("slow");
	});
});
</script>

<div class="container mx-auto my-4" style="text-align:center">
	<button id="changePasswordButton" class="btn w-50 font-weight-bold text-white" style="background-color:#1DA3EB">Click to Change Password</button>
</div>

<div id="changePasswordForm" class="updateInfo" style="display:none">
	<form:form action="changeStudentPassword" method="post" class="container mx-auto my-4 bg-light py-2" style="font-weight: bold; border: solid">
	<h1 class="text-center" style="font-family: 'PT Serif', serif;">Change Password</h1>
	<hr class="w-50">
		<div class="text-center mb-2">
			<i class="fa fa-unlock-alt fa-5x" aria-hidden="true"></i>
		</div>
		
		<c:if test="${wrongPassword != null}">
			<script>
				$(document).ready(function(){
					$('#changePasswordForm').show();
				});
			</script>
			<div class="alert alert-danger mt-3">
				Invalid current password entered!
			</div>
		</c:if>
		<c:if test="${changedPassword != null}">
			<script>
				$(document).ready(function(){
					$('#changePasswordForm').show();
				});
			</script>
			<div class="alert alert-success mt-3">
				Your password has been updated successfully!
			</div>
		 </c:if>
		<div class="container row mt-4">
			<div class="form-group col-md-6 col-lg-6">
				<label>Current Password</label>
			    <input type="password" name="presentPassword" class="form-control" placeholder="Enter current password" required value="${presentPassword}">
			</div>
			<div class="form-group col-md-6 col-lg-6">
				<label>New Password</label>
			    <input type="password" name="newPassword" class="form-control" placeholder="Enter new password" required value="${newPassword}">
			</div>
		</div>
	  	<div style="text-align:center" class="mt-1 mb-2">
	  		<button type="submit" class="btn btn-danger">Update</button>
	  	</div>
	</form:form>
</div>

<script>
$(document).ready(function(){
	$('#changePasswordButton').click(function(){
		$('#changePasswordForm').slideToggle("slow");
	});
});
</script>

<section id="footer" class="mt-4">
		<div class="container">
			<div class="row text-center text-xs-center text-sm-left text-md-left">
				<div class="col-xs-12 col-sm-4 col-md-4">
					<h5>Home</h5>
					<ul class="list-unstyled quick-links">
						<li><a href="bookList"><i class="fa fa-angle-double-right"></i>Book Collection</a></li>
						<li><a href="#"><i class="fa fa-angle-double-right"></i>Institute Bulletin</a></li>
						<li><a href="StudentEresources.jsp"><i class="fa fa-angle-double-right"></i>E-Resources</a></li>
						<li><a href="" data-toggle="modal" data-target="#contactModal"><i class="fa fa-angle-double-right"></i>Contact</a></li>
						
					</ul>
				</div>
				<div class="col-xs-12 col-sm-4 col-md-4">
					<h5>Quick links</h5>
					<ul class="list-unstyled quick-links">
						<li><a href="logout"><i class="fa fa-angle-double-right"></i>Logout</a></li>
						<li><a href="studentFeedback"><i class="fa fa-angle-double-right"></i>Feedback</a></li>			
					</ul>
				</div>
				<div class="col-xs-12 col-sm-4 col-md-4">
					<h5>About Us</h5>
					<ul class="list-unstyled quick-links">
						<li><a href="StudentKnowLibrary.jsp"><i class="fa fa-angle-double-right"></i>Know Your Library</a></li>
						<li><a href="#"><i class="fa fa-angle-double-right"></i>Library Brochure</a></li>
						<li><a href="#"><i class="fa fa-angle-double-right"></i>Library Staff</a></li>
						<li><a href="#"><i class="fa fa-angle-double-right"></i>FAQs</a></li>
						
					</ul>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-12 col-sm-12 col-md-12 mt-2 mt-sm-5">
					<ul class="list-unstyled list-inline social text-center">
						<li class="list-inline-item"><a href="https://www.facebook.com" target="_blank"><i class="fa fa-facebook"></i></a></li>
						<li class="list-inline-item"><a href="https://twitter.com/login" target="_blank"><i class="fa fa-twitter"></i></a></li>
						<li class="list-inline-item"><a href="https://www.instagram.com/?hl=en" target="_blank"><i class="fa fa-instagram"></i></a></li>
						<li class="list-inline-item"><a href="https://aboutme.google.com/u/0/?referer=gplus" target="_blank"><i class="fa fa-google-plus"></i></a></li>
						<li class="list-inline-item"><a href="https://www.google.com/intl/en-GB/gmail/about/" target="_blank"><i class="fa fa-envelope"></i></a></li>
					</ul>
				</div>
				</hr>
			</div>	
			<div class="row">
				<div class="col-xs-12 col-sm-12 col-md-12 mt-2 mt-sm-2 text-center text-white">
					<p>THIS WEBPAGE IS DEVELOPED BY THE VALAC COMMUNITY.</p>
					<p class="h6">&copy All right Reversed.</p>
				</div>
				</hr>
			</div>	
		</div>
	</section>

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

<script>
var number = document.getElementById('contact');
number.onkeydown = function(e) 
{
	if(!((e.keyCode>95 && e.keyCode<106) || (e.keyCode>47 && e.keyCode<58) || (e.keyCode>36 && e.keyCode<41) || e.keyCode == 8)) 
	    return false;
}
</script>

<script type="text/javascript">
	function Redirect()
	{
		window.location="https://library-portal.herokuapp.com/StudentUpdateDetails.jsp";
	}	
</script>

<style type="text/css">
	section {
    padding: 60px 0;
}

section .section-title {
    text-align: center;
    color: #007b5e;
    margin-bottom: 50px;
    text-transform: uppercase;
}
#footer {
    background: #007b5e !important;
}
#footer h5{
	padding-left: 10px;
    border-left: 3px solid #eeeeee;
    padding-bottom: 6px;
    margin-bottom: 20px;
    color:#ffffff;
}
#footer a {
    color: #ffffff;
    text-decoration: none !important;
    background-color: transparent;
    -webkit-text-decoration-skip: objects;
}
#footer ul.social li{
	padding: 3px 0;
}
#footer ul.social li a i {
    margin-right: 5px;
	font-size:25px;
	-webkit-transition: .5s all ease;
	-moz-transition: .5s all ease;
	transition: .5s all ease;
}
#footer ul.social li:hover a i {
	font-size:30px;
	margin-top:-10px;
}
#footer ul.social li a,
#footer ul.quick-links li a{
	color:#ffffff;
}
#footer ul.social li a:hover{
	color:#eeeeee;
}
#footer ul.quick-links li{
	padding: 3px 0;
	-webkit-transition: .5s all ease;
	-moz-transition: .5s all ease;
	transition: .5s all ease;
}
#footer ul.quick-links li:hover{
	padding: 3px 0;
	margin-left:5px;
	font-weight:700;
}
#footer ul.quick-links li a i{
	margin-right: 5px;
}
#footer ul.quick-links li:hover a i {
    font-weight: 700;
}

@media (max-width:767px){
	#footer h5 {
    padding-left: 0;
    border-left: transparent;
    padding-bottom: 0px;
    margin-bottom: 10px;
}

.carousel-inner img {
      width: 100%;
      height: 100%;
  }
}

@media screen and (max-width: 640px){
  .updateInfo{
  	width:80%;
  	margin:auto;
  }
}

@media screen and (min-width: 641px){
  .updateInfo{
  	width:55%;
  	margin:auto;
  }
}

</style>

</body>
</html>