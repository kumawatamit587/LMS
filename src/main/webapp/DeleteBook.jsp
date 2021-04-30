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
          <a class="dropdown-item" href="viewAddBook"><i class="fa fa-plus-square" aria-hidden="true"></i> Add Books</a>
          <a class="dropdown-item" href="#"><i class="fa fa-trash" aria-hidden="true"></i> Delete Books</a>
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


<div class="jumbotron text-center mb-0 mt-2" >
  <h1 class="display-4" >Delete Books</h1>
  <p class="lead">"Libraries store the energy that fuels the imagination. They open up windows to the world and inspire us to explore and achieve, and contribute to improving our quality of life. Libraries change lives for the better."- Sidney Sheldon
</p>
  <hr>
  <p>Gateway to Discover, Connect and Learn</p>
</div>

<a href="" id="viewBookListLink" style="visibility:hidden" data-toggle="modal" data-target="#viewBookListModal">View Book Modal</a>
<a href="" id="deleteBookConfirmLink" style="visibility:hidden" data-toggle="modal" data-target="#deleteBookConfirmModal">Delete Book Confirm Modal</a>
<a href="" id="deleteBookDoneLink" style="visibility:hidden" data-toggle="modal" data-target="#deleteBookDoneModal">Delete Book Done Modal</a>
<a href="" id="deleteAllBooksConfirmLink" style="visibility:hidden" data-toggle="modal" data-target="#deleteAllBooksConfirmModal">Delete All Books Confirm Modal</a>
<a href="" id="deleteAllBooksDoneLink" style="visibility:hidden" data-toggle="modal" data-target="#deleteAllBooksDoneModal">Delete All Books Done Modal</a>

<c:if test="${emptyBookDetails == null}">
<table class="table table-striped container text-center mt-4">
  <thead class="thead-dark">
    <tr>
      <th scope="col">Book ID</th>
      <th scope="col">Book Name</th>
      <th scope="col">Author</th>
      <th scope="col">Pages</th>
      <th scope="col">Publisher</th>
      <th scope="col">Genre</th>
      <th scope="col">Copies available</th>
      <th scope="col">Delete</th>
    </tr>
  </thead>
  <tbody>
  <c:forEach items="${bookdetails}" var="book">
	   	<c:url var="deleteBookList" value="/deleteBookList">
			<c:param name="bookId" value="${book.bookid}" />
		</c:url>
		<!--  <c:if test="${book.copies>0}">    
	    	</c:if>  --> 
	    <tr>
	      <td>${book.bookid}</td>
	      <td>${book.bookname}</td>
	      <td>${book.author}</td>
	      <td>${book.pages}</td>
	      <td>${book.publisher}</td>
	      <td>${book.genre}</td>
	      <td>${book.copies}</td>
	      <td><a href="${deleteBookList}"><button class="btn btn-danger btn-sm">Delete</button></a></td>
	    </tr>
    </c:forEach>
  </tbody>
</table>
</c:if>

<c:if test="${emptyBookDetails != null}">
	<h3 class="mt-4" style="text-align:center;">No Book available to delete.</h3>
</c:if>

<section id="footer" class="mt-5 bg-dark">
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

				<!-- BookList Modal -->
<div class="modal fade" id="viewBookListModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Book List</h5>
        <button type="button" onclick="Redirect()" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
      
        <table class="table table-striped container text-center mt-4">
		  <thead class="thead-dark">
		    <tr>
		      <th scope="col">Book Barcode</th>
		      <th scope="col">Status</th>
		      <th scope="col">Delete</th>
		    </tr>
		  </thead>
		  <tbody>
		  <c:forEach items="${bookList}" var="book">
		  	<c:url var="deleteBookConfirmModal" value="/deleteBookConfirmModal">
		  		<c:param name="bookId" value="${bookid}"></c:param>
		    	<c:param name="barcode" value="${book.barcode}"></c:param>
		    </c:url>		    
		    <tr>
		      <td>${book.barcode}</td>
		      <c:if test="${(book.status)=='Available'}">
			      <td><span class="badge badge-pill badge-success mt-1">${book.status}</span></td>
			      <td><a href="${deleteBookConfirmModal}"><span class="badge badge-pill badge-primary mt-1">Delete</span></a></td>
		      </c:if>
		      <c:if test="${book.status!='Available'}">
			      <td><span class="badge badge-pill badge-danger mt-1">${book.status}</span></td>
			      <td><a href="" style="pointer-events: none;"><span class="badge badge-pill mt-1 text-white" style="background-color:#8ED1F5">Delete</span></a></td>
		      </c:if>
		    </tr>
		    </c:forEach>
		  </tbody>		  
		</table>
		
      </div>
      <div class="modal-footer">
      	<form:form action="deleteAllBooksConfirmModal" method="post">
      		<input name="bookId" type="number" style="visibility:hidden" value="${bookid}">
      		<button type="submit" style="position:absolute; left:240px" class="btn btn-primary">Delete all the books</button>
        	<button type="button" onclick="Redirect()" class="btn btn-danger" data-dismiss="modal">Close</button>
        </form:form>
      </div>
    </div>
  </div>
</div>


				<!-- Delete Book Confirm Modal -->
<div class="modal fade" id="deleteBookConfirmModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Book Delete Confirmation</h5>
        <button type="button" onclick="Redirect()" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      
      <div class="modal-body text-center" style="font-weight: bold">
		<p>Are you sure want to delete the book?<p>
		<form:form action="deleteBookConfirm" method="post">
			<input name="bookId" type="number" style="visibility:hidden" value="${bookId}">
			<input name="barcode" type="number" style="visibility:hidden" value="${barcode}">
			<button type="submit" class="btn btn-success" style="width:70px; position:absolute; left:170px">Yes</button>
			<button type="button" onclick="Redirect()" class="btn btn-danger" data-dismiss="modal" style="width:70px; position:absolute; right:180px">No</button>
		</form:form>
      </div>
    </div>
  </div>
</div>

				<!-- Book Deleted Modal -->
<div class="modal fade" id="deleteBookDoneModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content" style="background-color:#AEF99B">
    <div class="modal-header">
      <h5 class="modal-title"><i class="fa fa-check-circle fa-2x" aria-hidden="true"></i></h5>
      <button type="button" onclick="Redirect()" style="position:absolute; right:10px" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
      </button>
    </div>
      <div class="modal-body text-dark mt-0 pt-0 font-weight-bold">
        Book has been deleted successfully!
      </div>
    </div>
  </div>
</div>

				<!-- Delete All Books Confirm Modal -->
<div class="modal fade" id="deleteAllBooksConfirmModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Book Delete Confirmation</h5>
        <button type="button" onclick="Redirect()" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      
      <div class="modal-body text-center" style="font-weight: bold">
		<p>Are you sure want to delete all the available book?<p>
		<form:form action="deleteAllBooksConfirm" method="post">
			<input name="bookId" type="number" style="visibility:hidden" value="${bookId}">
			<button type="submit" class="btn btn-success" style="width:70px; position:absolute; left:170px">Yes</button>
			<button type="button" onclick="Redirect()" class="btn btn-danger" data-dismiss="modal" style="width:70px; position:absolute; right:180px">No</button>
		</form:form>
      </div>
    </div>
  </div>
</div>
    
				<!-- All Books Deleted Modal -->
<div class="modal fade" id="deleteAllBooksDoneModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content" style="background-color:#AEF99B">
    <div class="modal-header">
      <h5 class="modal-title"><i class="fa fa-check-circle fa-2x" aria-hidden="true"></i></h5>
      <button type="button" onclick="Redirect()" style="position:absolute; right:10px" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
      </button>
    </div>
      <div class="modal-body text-dark mt-0 pt-0 font-weight-bold">
        All the available books have been deleted successfully!
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

<c:if test="${bookid != null }">
	<script>
		document.getElementById("viewBookListLink").click();
	</script>
</c:if>

<c:if test="${deleteBookConfirmation != null }">
	<script>
		document.getElementById("deleteBookConfirmLink").click();
	</script>
</c:if>

<c:if test="${deleteBookDone != null }">
	<script>
		document.getElementById("deleteBookDoneLink").click();
	</script>
</c:if>

<c:if test="${deleteAllBooksConfirmation != null }">
	<script>
		document.getElementById("deleteAllBooksConfirmLink").click();
	</script>
</c:if>

<c:if test="${deleteAllBooksDone != null }">
	<script>
		document.getElementById("deleteAllBooksDoneLink").click();
	</script>
</c:if>

<script type="text/javascript">
	function Redirect()
	{
		window.location="https://library-portal.herokuapp.com/deleteBook";
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

</style>

</body>
</html>