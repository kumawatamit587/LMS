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
  <a class="navbar-brand  mr-5" href="#"><i class="fa fa-book" aria-hidden="true"></i> Central Institute Library <i class="fa fa-user" aria-hidden="true"></i></a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
 
  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav mr-auto">
      <li class="nav-item mr-3">
        <a class="nav-link" href="AdminPage.jsp">Home <span class="sr-only">(current)</span></a>
      </li>
      <li class="nav-item mr-3">
        <a class="nav-link" href="AdminAbout.jsp">About</a>
      </li>
       <li class="nav-item mr-3">
        <a class="nav-link" href="AdminEresources.jsp">E-Resources</a>
      </li>
      <li class="nav-item dropdown mr-3">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          Details
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
          <a class="dropdown-item" href="bookList"><i class="fa fa-list" aria-hidden="true"></i> Book List</a>    
          <a class="dropdown-item" href="userDetails"><i class="fa fa-user" aria-hidden="true"></i> User Details</a>  
          <a class="dropdown-item" href="individualBookDetails"><i class="fa fa-book" aria-hidden="true"></i> Book Details </a> 
          <a class="dropdown-item" href="bookIssueHistory/1"><i class="fa fa-history" aria-hidden="true"></i> Book Issue History </a> 
          <a class="dropdown-item" href="viewVendor"><i class="fa fa-male" aria-hidden="true"></i> Vendor Details </a>
          <a class="dropdown-item" href="sendReminderMail"><i class="fa fa-envelope" aria-hidden="true"></i> Send Reminder Mail </a>    
        </div>
      </li>
      <li class="nav-item active dropdown mr-3">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          Manage Books
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">       
          <a class="dropdown-item" href="issueBook"><i class="fa fa-check-square-o" aria-hidden="true"></i> Issue Book</a>
          <a class="dropdown-item" href="returnBook"><i class="fa fa-backward" aria-hidden="true"></i> Return Book</a>
          <a class="dropdown-item" href="#"><i class="fa fa-plus-square" aria-hidden="true"></i> Add Books</a>
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

<div class="container mx-auto my-4" style="text-align:center">
	<button id="newBookButton" class="btn btn-success w-50">Click to Add New Book</button>
</div>

<div id="newBookForm" style="display:none">
	<c:if test="${emptyVendorDetails == null }">
		<form:form action="addNewBook" method="post" modalAttribute="theBookDetails" class="container mx-auto my-4 bg-light py-2" style="font-weight: bold; border: solid">
		<h1 class="text-center">Add Books</h1>
		<hr class="w-50">
			<div class="text-center mb-2">
				<i class="fa fa-book fa-5x" aria-hidden="true"></i>
			</div>
			
			<c:if test="${newBookError != null}">
				<div class="alert alert-danger">
					The Book details you entered already exists!
				</div>
			</c:if>
			<c:if test="${newBookAdded != null}">
				<script>
					document.getElementById('newBookButton').click();
				</script>
				<div class="alert alert-success">
					New Book has been added successfully!
				</div>
			 </c:if>
			<div class="container row mt-4">
				<div class="form-group col-md-6 col-lg-6">
					<label>Book Name</label>
				    <input type="text" name="bookname" class="form-control" placeholder="Enter book name" required value="${bookname}">
				</div>
				<div class="form-group col-md-6 col-lg-6">
					<label>Author</label>
				    <input type="text" name="author" class="form-control" aria-describedby="nameHelp" placeholder="Enter author's name" required value="${author}">
				</div>
			</div>
			<div class="container row">
			  	<div class="form-group col-md-6 col-lg-6">
				    <label>Pages</label>
				    <input type="number" name="pages" class="form-control" placeholder="Enter no. of pages" required value="${pages}">
			  	</div>
			  	<div class="form-group col-md-6 col-lg-6">
				    <label>Publisher</label>
				    <input type="text" name="publisher" class="form-control" placeholder="Enter publisher" required value="${publisher}">
			  	</div>
		  	</div>
		  	<div class="container row">
				<div class="form-group col-md-6 col-lg-6">
				   <label>Genre</label>
				   <input type="text" name="genre" class="form-control" placeholder="Enter book genre" required value="${genre}">
				</div>
				<div class="form-group col-md-6 col-lg-6">
				   <label>Copies</label>
				   <input type="number" name="totalcopies" class="form-control" placeholder="Enter no. of copies" required value="${totalcopies}">
				</div>
		  	</div>
		  	<div class="container row">
				<div class="form-group col-md-6 col-lg-6">
				   <label>Vendor ID</label>
				   <select name="vendorid" class="form-control py-1 px-2" value="${vendorid}">
					   <c:forEach items="${vendorDetails}" var="vendor">
					   		<option>${vendor.vendorid}</option>
					   </c:forEach>
				   </select>
				</div>
			</div>
		  	<div style="text-align:center" class="mt-1 mb-2">
		  		<button type="submit" class="btn btn-danger">Add Book</button>
		  	</div>
		</form:form>
	</c:if>

	<c:if test="${emptyVendorDetails != null }">
		<h3 class="mt-4" style="text-align:center;">First add a Book Vendor</h3>
	</c:if>
</div>

<script>
$(document).ready(function(){
	$('#newBookButton').click(function(){
		$('#newBookForm').slideToggle("slow");
	})
})
</script>

<div class="container mx-auto my-4" style="text-align:center">
<button id="addCopiesButton" class="btn btn-success w-50">Click to Add Copies of Existing Books</button>
</div>

<div id="addCopiesTable" class="table-responsive" style="display:none">
	<c:if test="${emptyBookDetails ==null}">
		<table class="table table-striped container text-center mx-auto" >
		  <thead class="thead-dark">
		    <tr>
		      <th scope="col">Book ID</th>
		      <th scope="col">Book Name</th>
		      <th scope="col">Author</th>
		      <th scope="col">Pages</th>
		      <th scope="col">Publisher</th>
		      <th scope="col">Genre</th>
		      <th scope="col">Total copies</th>
		      <th scope="col">No. of new copies</th>
		      <th scope="col">Vendor ID</th>
		      <th scope="col">Add Copies</th>
		    </tr>
		  </thead>
		  <tbody>
		  <c:forEach items="${bookdetails}" var="book">
		    <tr>
		      <td>${book.bookid}</td>
		      <td>${book.bookname}</td>
		      <td>${book.author}</td>
		      <td>${book.pages}</td>
		      <td>${book.publisher}</td>
		      <td>${book.genre}</td>
		      <td>${book.totalcopies}</td>
		      <form:form action="addCopies" method="get">
		      <input type="hidden" name="bookId" value="${book.bookid}">
		      <input type="hidden" name="totalCopies" value="${book.totalcopies}">
		      <input type="hidden" name="copies" value="${book.copies}">
		      <td><input type="number" min="1" id="newCopies" name="newCopies" class="form-control px-2 mx-auto" style="width:60px; text-align:center;" autocomplete="off" required></td>
		      <td>
			      <select name="vendorid" class="form-control px-2">
						   <c:forEach items="${vendorDetails}" var="vendor">
						   		<option>${vendor.vendorid}</option>
						   </c:forEach>
				  </select>
			  </td>
		      <td><button class="btn btn-primary btn-sm" type="submit">Add</button></td>
		      </form:form> 
		    </tr>
		    </c:forEach>
		  </tbody>
		</table>
	</c:if>

	<c:if test="${emptyBookDetails != null}">
		<h3 class="mt-4" style="text-align:center;">No book available</h3>
	</c:if>
</div>

<script>
$(document).ready(function(){
	$('#addCopiesButton').click(function(){
		$('#addCopiesTable').slideToggle("slow");
	})
})
</script>

<script>
var number = document.getElementById('newCopies');
number.onkeydown = function(e) 
{
	if(!((e.keyCode > 96 && e.keyCode < 106) || (e.keyCode > 48 && e.keyCode < 58) || e.keyCode == 8)) 
	    return false;
}
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
						<a href="" id="bookExistsButton" style="visibility:hidden" data-toggle="modal" data-target="#bookExistsModal">Invalid Data</a>
						<a href="" id="newBookAddedButton" style="visibility:hidden" data-toggle="modal" data-target="#newBookAddedModal">New Book Added</a>
						<a href="" id="bookCopiesAddedButton" style="visibility:hidden" data-toggle="modal" data-target="#bookCopiesAddedModal">Book Copies Added</a>
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

				<!-- Added book already exists Modal -->
<div class="modal fade" id="bookExistsModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content" style="background-color:#FF9494">
    <div class="modal-header">
      <h5 class="modal-title">Error <i class="fa fa-exclamation-triangle" aria-hidden="true"></i></h5>
      <button type="button" style="position:absolute; right:10px" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
      </button>
    </div>
      <div class="modal-body text-dark mt-1 font-weight-bold">
        The Book details you entered already exists!
      </div>
    </div>
  </div>
</div>

				<!-- New Book added Modal -->
<div class="modal fade" id="newBookAddedModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content" style="background-color:#AEF99B">
    <div class="modal-header">
      <h5 class="modal-title"><i class="fa fa-check-circle fa-2x" aria-hidden="true"></i></h5>
      <button type="button" onclick="Redirect()" style="position:absolute; right:10px" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
      </button>
    </div>
      <div class="modal-body text-dark mt-0 pt-0 font-weight-bold">
        New Book has been added successfully!
      </div>
    </div>
  </div>
</div>

				<!-- Book Copies Added Modal -->
<div class="modal fade" id="bookCopiesAddedModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content" style="background-color:#AEF99B">
    <div class="modal-header">
      <h5 class="modal-title"><i class="fa fa-check-circle fa-2x" aria-hidden="true"></i></h5>
      <button type="button" onclick="Redirect()" style="position:absolute; right:10px" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
      </button>
    </div>
      <div class="modal-body text-dark mt-0 pt-0 font-weight-bold">
        Books Added Successfully!
      </div>
    </div>
  </div>
</div>

<c:if test="${newBookError!=null}">
	<script>
		document.getElementById('bookExistsButton').click();
	</script>
</c:if>

<c:if test="${newBookAdded!=null}">
	<script>
		document.getElementById('newBookAddedButton').click();
	</script>
</c:if>

<c:if test="${bookCopiesAdded!=null}">
	<script>
		document.getElementById('bookCopiesAddedButton').click();
	</script>
</c:if>

<script type="text/javascript">
	function Redirect()
	{
		window.location="https://library-portal.herokuapp.com/viewAddBook";
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
  #newBookForm{
  	width:90%;
  	margin:auto;
  }
}

@media screen and (min-width: 641px){
  #newBookForm{
  	width:50%;
  	margin:auto;
  }
}

</style>

</body>
</html>