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

<nav class="navbar navbar-expand-lg navbar-dark bg-dark" style="margin-top:1px">
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
          <a class="dropdown-item" href="#"><i class="fa fa-check-square-o" aria-hidden="true"></i> Issue Book</a>
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


<div class="jumbotron text-center mb-0 mt-2">
  <h1 class="display-4" >Issue Book</h1>
  <p class="lead">"Libraries store the energy that fuels the imagination. They open up windows to the world and inspire us to explore and achieve, and contribute to improving our quality of life. Libraries change lives for the better."- Sidney Sheldon
</p>
  <hr>
  <p>Gateway to Discover, Connect and Learn</p>
</div>

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
      <th scope="col">Issue</th>
    </tr>
  </thead>
  <tbody>
  <c:forEach items="${bookdetails}" var="book">
	   	<c:url var="issueBookList" value="/issueBookList">
			<c:param name="bookId" value="${book.bookid}" />
		</c:url>
		<!-- <c:if test="${book.copies>0}">
	    	</c:if>   --> 
	    <tr>
	      <td>${book.bookid}</td>
	      <td>${book.bookname}</td>
	      <td>${book.author}</td>
	      <td>${book.pages}</td>
	      <td>${book.publisher}</td>
	      <td>${book.genre}</td>
	      <td>${book.copies}</td>
	      <td><a href="${issueBookList}"><button class="btn btn-success btn-sm">Issue</button></a></td>
	    </tr>
    </c:forEach>
  </tbody>
</table>
</c:if>

<c:if test="${emptyBookDetails != null}">
	<h3 class="mt-5" style="text-align:center;">No Book available for issue.</h3>
</c:if>

<section id="footer" class="mt-5">
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
						<a href="" id="viewBookListLink" style="visibility:hidden" data-toggle="modal" data-target="#viewBookListModal">View BookList</a>
						<a href="" id="issueBookUsernameLink" style="visibility:hidden" data-toggle="modal" data-target="#issueBookUsernameModal">Enter Username</a>
						<a href="" id="invalidUsernameLink" style="visibility:hidden" data-toggle="modal" data-target="#invalidUsernameModal">#invalidUsernameModal</a>
						<a href="" id="bookHolderLink" style="visibility:hidden" data-toggle="modal" data-target="#bookHolderModal">#bookHolderModal</a>
						<a href="" id="bookIssuedLink" style="visibility:hidden" data-toggle="modal" data-target="#bookIssuedModal">#bookIssuedModal</a>
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
		      <th scope="col">Issue</th>
		    </tr>
		  </thead>
		  <tbody>
		  <c:forEach items="${bookList}" var="book">
		  	<c:url var="issueBookUsername" value="/issueBookUsername">
		  		<c:param name="bookId" value="${bookid}"></c:param>
		    	<c:param name="barcode" value="${book.barcode}"></c:param>
		    </c:url>		    
		    <tr>
		      <td>${book.barcode}</td>
		      <c:if test="${(book.status)=='Available'}">
		      <td><span class="badge badge-pill badge-success mt-1">${book.status}</span></td>
		      <td><a href="${issueBookUsername}"><span class="badge badge-pill badge-primary mt-1">Issue</span></a></td>
		      </c:if>
		      <c:if test="${book.status!='Available'}">
		      <td><span class="badge badge-pill badge-danger mt-1">${book.status}</span></td>
		      <td><a href="" style="pointer-events: none;"><span class="badge badge-pill mt-1 text-white" style="background-color:#8ED1F5">Issue</span></a></td>
		      </c:if>
		    </tr>
		    </c:forEach>
		  </tbody>		  
		</table>
		
      </div>
      <div class="modal-footer">
        <button type="button" onclick="Redirect()" class="btn btn-danger" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

				<!-- Issue Book Username Modal -->
<div class="modal fade" id="issueBookUsernameModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
		  <div class="modal-dialog" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <h5 class="modal-title" id="exampleModalLabel">Issuer's Details</h5>
		        <button type="button" onclick="Redirect()" class="close" data-dismiss="modal" aria-label="Close">
		          <span aria-hidden="true">&times;</span>
		        </button>
		      </div>
		      <form:form id="formIssue" action="issueBookConfirm" method="post">
			      <div class="modal-body" style="font-weight: bold">
			        <div class="form-group">
					    <label>Book ID</label>
					    <input type="text" class="form-control" disabled value="${bookId}">
					    <input type="hidden" name="bookid" class="form-control" value="${bookId}">
					  </div>
					  <div class="form-group">
					    <label>Barcode</label>
					    <input type="text" class="form-control" disabled value="${barcode}">
					    <input type="hidden" name="barcode" class="form-control" value="${barcode}">
					  </div>
			        <div class="form-group">
					    <label>Username</label>
					 <input type="text" name="username" class="form-control" id="issuername" aria-describedby="nameHelp" placeholder="Enter username">
					  </div>
			      </div>
			      <div class="modal-footer">
			      	<span id="load" style="visibility:hidden"><i class="fa fa-spinner fa-pulse fa-2x fa-fw"></i></span>
			      	<!-- <button type="reset" id="reset" class="btn btn-success">Reset</button> -->
			      	<button type="submit" id="issue" class="btn btn-success">Issue</button>
			        <button type="button" onclick="Redirect()" class="btn btn-danger" data-dismiss="modal">Close</button>
			      </div>
		  	</form:form>
		    </div>
		  </div>
		</div>
		
		
		

				<!-- Invalid Username Modal -->
<div class="modal fade" id="invalidUsernameModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content" style="background-color:#FF9494">
    <div class="modal-header">
      <h5 class="modal-title">Invalid Username <i class="fa fa-exclamation-triangle" aria-hidden="true"></i></h5>
      <button type="button" onclick="Redirect()" style="position:absolute; right:10px" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
      </button>
    </div>
      <div class="modal-body text-dark mt-1 font-weight-bold">
        The username you entered does not exist!
      </div>
    </div>
  </div>
</div>

				<!-- Book Holder Modal -->
<div class="modal fade" id="bookHolderModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content" style="background-color:#FF9494">
    <div class="modal-header">
      <h5 class="modal-title">Error <i class="fa fa-exclamation-triangle" aria-hidden="true"></i></h5>
      <button type="button" onclick="Redirect()" style="position:absolute; right:10px" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
      </button>
    </div>
      <div class="modal-body text-dark mt-1 font-weight-bold">
        This user has already issued a book. Cannot issue more than one book at a time.
      </div>
    </div>
  </div>
</div>

				<!-- Book Issued Modal -->
<div class="modal fade" id="bookIssuedModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content" style="background-color:#AEF99B">
    <div class="modal-header">
      <h5 class="modal-title"><i class="fa fa-check-circle fa-2x" aria-hidden="true"></i></h5>
      <button type="button" onclick="Redirect()" style="position:absolute; right:10px" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
      </button>
    </div>
      <div class="modal-body text-dark mt-0 pt-0 font-weight-bold">
        Book has been issued successfully! ${result}
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
		document.getElementById('viewBookListLink').click();
	</script>
</c:if>

<c:if test="${barcode != null }">
	<script>
		document.getElementById('issueBookUsernameLink').click();
	</script>
</c:if>

<c:if test="${invalidUsername != null }">
	<script>
		document.getElementById('invalidUsernameLink').click();
	</script>
</c:if>

<c:if test="${bookHolder != null }">
	<script>
		document.getElementById('bookHolderLink').click();
	</script>
</c:if>

<c:if test="${bookIssued != null }">
	<script>
		document.getElementById('bookIssuedLink').click();
	</script>
</c:if>

<script type="text/javascript">
	function Redirect()
	{
		window.location="https://library-portal.herokuapp.com/issueBook";
	}
</script>

<script>
	$(document).ready(function(){
		$("#formIssue").submit(function(){
			$("#load").css({"visibility":"visible"});
		});
	});
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