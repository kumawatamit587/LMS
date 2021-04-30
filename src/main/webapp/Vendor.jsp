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

	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
	<script src="https://use.fontawesome.com/ec453aebd2.js"></script>
	<link href="fontawesome-free-5.9.0-web\css\all.css" rel="stylesheet">
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
  	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
  	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
  	<link href="https://fonts.googleapis.com/css?family=Josefin+Sans&display=swap" rel="stylesheet">
  	<link rel="stylesheet" type="text/css" href="/css/loaderStyle.css">
</head>
<body>

<%
response.setHeader("Cache-Control","no-cache,no-store,must revalidate");
if(session.getAttribute("adminUsername")==null)
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

<nav class="navbar navbar-expand-lg navbar-dark bg-dark mt-1">
  <a class="navbar-brand" href="#"><i class="fa fa-book" aria-hidden="true"></i> Central Institute Library <i class="fa fa-user" aria-hidden="true"></i></a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
 
  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav mr-auto">
      <li class="nav-item ml-5 mr-3">
        <a class="nav-link" href="AdminPage.jsp">Home <span class="sr-only">(current)</span></a>
      </li>
      <li class="nav-item mr-3">
        <a class="nav-link" href="AdminAbout.jsp">About</a>
      </li>
       <li class="nav-item mr-3">
        <a class="nav-link" href="AdminEresources.jsp">E-Resources</a>
      </li>
      <li class="nav-item active dropdown mr-3">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          Details
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
          <a class="dropdown-item" href="bookList"><i class="fa fa-list" aria-hidden="true"></i> Book List</a>    
          <a class="dropdown-item" href="userDetails"><i class="fa fa-user" aria-hidden="true"></i> User Details</a>  
          <a class="dropdown-item" href="individualBookDetails"><i class="fa fa-book" aria-hidden="true"></i> Book Details </a> 
          <a class="dropdown-item" href="bookIssueHistory/1"><i class="fa fa-history" aria-hidden="true"></i> Book Issue History </a> 
          <a class="dropdown-item" href="#"><i class="fa fa-male" aria-hidden="true"></i> Vendor Details </a>
          <a class="dropdown-item" href="sendReminderMail"><i class="fa fa-envelope" aria-hidden="true"></i> Send Reminder Mail </a>    
        </div>
      </li>
      <li class="nav-item dropdown mr-3">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          Manage Books
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">       
          <a class="dropdown-item" href="issueBook"><i class="fa fa-check-square-o" aria-hidden="true"></i> Issue Book</a>
          <a class="dropdown-item" href="returnBook"><i class="fa fa-backward" aria-hidden="true"></i> Return Book</a>
          <a class="dropdown-item" href="viewAddBook"><i class="fa fa-plus-square" aria-hidden="true"></i> Add Books</a>
          <a class="dropdown-item" href="deleteBook"><i class="fa fa-trash" aria-hidden="true"></i> Delete Books</a>
        </div>
      </li>
      <li class="nav-item mr-3 mt-1">
        <form action="logout">
        <button class="btn btn-outline-danger my-2 my-sm-0" type="submit">Logout</button>
        </form>
      </li>
    </ul>
    <form class="form-inline my-2 my-lg-0">
      <input class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search">
      <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
    </form>
  </div>
</nav>

<a href="" id="viewBookListLink" style="visibility:hidden" data-toggle="modal" data-target="#viewBookListModal">View Book Modal</a>

<div class="container mx-auto my-4" style="text-align:center">
<button id="viewVendorsButton" class="btn btn-success w-50">Click to View Vendor Details</button>
</div>

<div id="viewVendorsTable" class="table-responsive" style="display:none">
	<c:if test="${emptyVendorDetails == null}">
		<table class="table table-striped container text-center mx-auto" >
		  <thead class="thead-dark">
		    <tr>
		      <th scope="col">Vendor ID</th>
		      <th scope="col">Name</th>
		      <th scope="col">Email</th>
		      <th scope="col">Contact</th>
		      <th scope="col">View Books</th>
		    </tr>
		  </thead>
		  <tbody>
		  <c:forEach items="${vendorDetails}" var="vendor">
		  	<c:url var="viewVendorBookList" value="/viewVendorBookList">
		  		<c:param name="vendorId" value="${vendor.vendorid}"></c:param>
		  	</c:url>
		    <tr>
		      <td>${vendor.vendorid}</td>
		      <td>${vendor.firstname} ${vendor.lastname}</td>
		      <td>${vendor.email}</td>
		      <td>${vendor.contact}</td>
		      <td><a href="${viewVendorBookList}"><button class="btn btn-primary btn-sm">View Books</button></a></td> 
		    </tr>
		    </c:forEach>
		  </tbody>
		</table>
	</c:if>

	<c:if test="${emptyVendorDetails != null}">
		<h3 class="mt-4" style="text-align:center;">No Vendor Found</h3>
	</c:if>
</div>

<script>
$(document).ready(function(){
	$('#viewVendorsButton').click(function(){
		$('#viewVendorsTable').slideToggle("slow");
	})
})
</script>

<div class="container mx-auto my-4" style="text-align:center">
<button id="newVendorButton" class="btn btn-success w-50">Click to Add New Vendor</button>
</div>

<div id="newVendorForm" class="container mx-auto my-4 bg-light py-2" style="display:none; font-weight: bold; border: solid">
<form:form action="addNewVendor" method="post" modalAttribute="theVendor" >
<h1 class="text-center">Add Vendor</h1>
<hr class="w-50">
	<div class="text-center mb-2">
		<i class="fa fa-book fa-5x" aria-hidden="true"></i>
	</div>
  	
	<c:if test="${newVendorError != null}">
		<div class="alert alert-danger">
			The Vendor details you entered already exists!
		</div>
	</c:if>
	<c:if test="${newVendorAdded != null}">
		<script>
			document.getElementById('newVendorButton').click();
		</script>
		<div class="alert alert-success">
			New Vendor has been added successfully!
		</div>
	 </c:if>

	<div class="container row mt-4">
		<div class="form-group col-md-6 col-lg-6">
			<label>First Name</label>
		    <input type="text" name="firstname" class="form-control" placeholder="Enter first name" required value="${firstname}">
		</div>
		<div class="form-group col-md-6 col-lg-6">
			<label>Last Name</label>
		    <input type="text" name="lastname" class="form-control" placeholder="Enter last name" required value="${lastname}">
		</div>
	</div>
	<div class="container row">
	  	<div class="form-group col-md-6 col-lg-6">
		    <label>Email</label>
		    <input type="email" name="email" class="form-control" placeholder="Enter email" required value="${email}">
	  	</div>
	  	<div class="form-group col-md-6 col-lg-6">
		    <label>Contact</label>
		    <input type="text" name="contact" id="contactNumber" class="form-control" placeholder="Enter contact" required value="${contact}">
	  	</div>
  	</div>
  	<div style="text-align:center" class="mt-1 mb-2">
  		<button type="submit" class="btn btn-danger">Add Vendor</button>
  	</div>
</form:form>
</div>

<script>
$(document).ready(function(){
	$('#newVendorButton').click(function(){
		$('#newVendorForm').toggle("slow");
	})
})
</script>

<section id="footer" class="mt-4">
		<div class="container">
			<div class="row text-center text-xs-center text-sm-left text-md-left">
				<div class="col-xs-12 col-sm-4 col-md-4">
					<h5>Home</h5>
					<ul class="list-unstyled quick-links">
						<li><a href="bookList"><i class="fa fa-angle-double-right"></i>Book Collection</a></li>
						<li><a href="#"><i class="fa fa-angle-double-right"></i>Institute Bulletin</a></li>
						<li><a href="AdminEresources.jsp"><i class="fa fa-angle-double-right"></i>E-Resources</a></li>
						<li><a href="" data-toggle="modal" data-target="#contactModal"><i class="fa fa-angle-double-right"></i>Contact</a></li>
						
					</ul>
				</div>
				<div class="col-xs-12 col-sm-4 col-md-4">
					<h5>Quick links</h5>
					<ul class="list-unstyled quick-links">
						<li><a href="logout"><i class="fa fa-angle-double-right"></i>Logout</a></li>
						<li><a href="AdminSignupPage.jsp"><i class="fa fa-angle-double-right"></i>Add New Admin</a></li>	
						<a href="" id="vendorExistsButton" style="visibility:hidden" data-toggle="modal" data-target="#vendorExistsModal">Vendor already exists</a>
						<a href="" id="newVendorAddedButton" style="visibility:hidden" data-toggle="modal" data-target="#newVendorAddedModal">New vendor Added</a>
					</ul>
				</div>
				<div class="col-xs-12 col-sm-4 col-md-4">
					<h5>About Us</h5>
					<ul class="list-unstyled quick-links">
						<li><a href="AdminKnowLibrary.jsp"><i class="fa fa-angle-double-right"></i>Know Your Library</a></li>
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
					<p>THIS WEBPAGE IS DEVELOPED BY THE VALAC COMMUNITY</p>
					<p class="h6">&copy All Rights Reversed</p>
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

				<!-- BookList Modal -->
<div class="modal fade" id="viewBookListModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Book List</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
      	<c:if test="${emptyBookList == null}">
	        <table class="table table-striped container text-center mt-4">
			  <thead class="thead-dark">
			    <tr>
			      <th scope="col">Book ID</th>
			      <th scope="col">Book Barcode</th>
			      <th scope="col">Status</th>
			    </tr>
			  </thead>
			  <tbody>
			  <c:forEach items="${bookList}" var="book">	    
			    <tr>
			      <td>${book.bookDetails.bookid}</td>
			      <td>${book.barcode}</td>
			      <c:if test="${(book.status)=='Available'}">
				      <td><span class="badge badge-pill badge-success mt-1">${book.status}</span></td>
			      </c:if>
			      <c:if test="${book.status!='Available'}">
				      <td><span class="badge badge-pill badge-danger mt-1">${book.status}</span></td>
			      </c:if>
			    </tr>
			    </c:forEach>
			  </tbody>		  
			</table>
		</c:if>
		
		<c:if test="${emptyBookList != null}">
			<h5 class="mt-4" style="text-align:center">No book has been provided by this vendor</h5>
		</c:if>
		
      </div>
      <div class="modal-footer">
        	<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

				<!-- Added vendor already exists Modal -->
<div class="modal fade" id="vendorExistsModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content" style="background-color:#FF9494">
    <div class="modal-header">
      <h5 class="modal-title">Error <i class="fa fa-exclamation-triangle" aria-hidden="true"></i></h5>
      <button type="button" style="position:absolute; right:10px" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
      </button>
    </div>
      <div class="modal-body text-dark mt-1 font-weight-bold">
        The Vendor details you entered already exists!
      </div>
    </div>
  </div>
</div>

				<!-- New Vendor added Modal -->
<div class="modal fade" id="newVendorAddedModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content" style="background-color:#AEF99B">
    <div class="modal-header">
      <h5 class="modal-title"><i class="fa fa-check-circle fa-2x" aria-hidden="true"></i></h5>
      <button type="button" onclick="Redirect()" style="position:absolute; right:10px" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
      </button>
    </div>
      <div class="modal-body text-dark mt-0 pt-0 font-weight-bold">
        New Vendor has been added successfully!
      </div>
    </div>
  </div>
</div>

<c:if test="${openBookList != null }">
	<script>
		$(document).ready(function(){
			$('#viewVendorsTable').toggle();
		});
		document.getElementById("viewBookListLink").click();
	</script>
</c:if>

<c:if test="${newVendorError!=null}">
	<script>
		document.getElementById('vendorExistsButton').click();
	</script>
</c:if>

<c:if test="${newVendorAdded!=null}">
	<script>
		document.getElementById('newVendorAddedButton').click();
	</script>
</c:if>

<script type="text/javascript">
	function Redirect()
	{
		window.location="https://library-portal.herokuapp.com/viewVendor";
	}	
</script>

<script>
var number = document.getElementById('contactNumber');
number.onkeydown = function(e) 
{
	if(!((e.keyCode > 95 && e.keyCode < 106) || (e.keyCode > 47 && e.keyCode < 58) || e.keyCode == 8 || (e.keyCode > 36 && e.keyCode < 41))) 
	    return false;
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
  #newVendorForm{
  	width:90%;
  	margin:auto;
  }
}

@media screen and (min-width: 641px){
  #newVendorForm{
  	width:50%;
  	margin:auto;
  }
}

</style>

</body>
</html>