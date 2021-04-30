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
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
	<script src="https://use.fontawesome.com/ec453aebd2.js"></script>
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
  	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
  	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
  	<link href="https://fonts.googleapis.com/css?family=Josefin+Sans&display=swap" rel="stylesheet">
  	<script src="/js/SearchBarForm.js"></script>
  	<link rel="stylesheet" type="text/css" href="/css/loaderStyle.css">

<title>Central Institute Library</title>
</head>

<body>
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
      <li class="nav-item active mr-3">
        <a class="nav-link" href="#">Home<span class="sr-only">(current)</span></a>
      </li>
      <li class="nav-item mr-3">
        <a class="nav-link" href="About.jsp">About</a>
      </li>
       <li class="nav-item mr-3">
        <a class="nav-link" href="Services.jsp">Services</a>
      </li>
       <li class="nav-item mr-3">
        <a class="nav-link" href="Eresources.jsp">E-Resources</a>
      </li>
            <li class="nav-item mr-3">
        <a class="nav-link" href="Facts.jsp">Facts and Figures</a>
      </li>
      <li class="nav-item dropdown mr-3">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          Others
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
          <a class="dropdown-item" href="LoginPage.jsp">Admin Log in</a>
          <a class="dropdown-item" href="LoginPage.jsp">Student Log in</a>
          <a class="dropdown-item" href="StudentSignupPage.jsp">Student Sign Up</a>
        </div>
      </li>
    </ul>
    <form class="form-inline my-2 my-lg-0" action="searchForm" method="post">
      <input class="form-control mr-sm-2" type="search" name="searchItem" id="searchBar" placeholder="Search" aria-label="Search">
      <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
    </form>
  </div>
</nav>

<a href="" id="loggedOutLink" style="display:none" data-toggle="modal" data-target="#loggedOutModal">logged Out Link</a>

<div class="bd-example mt-0">
  <div id="carouselExampleCaptions" class="carousel slide" data-ride="carousel" >
    <ol class="carousel-indicators">
      <li data-target="#carouselExampleCaptions" data-slide-to="0" class="active" ></li>
      <li data-target="#carouselExampleCaptions" data-slide-to="1"></li>
      <li data-target="#carouselExampleCaptions" data-slide-to="2"></li>
    </ol>
    <div class="carousel-inner">
      <div class="carousel-item active">
        <img src="https://s1.1zoom.me/big3/793/Library_Book_532388_1920x1080.jpg" alt="..." width="1400" height="500">
        <div class="carousel-caption d-none d-md-block">      
          <p><font size=5>"A library is like an island in the middle of a vast sea of ignorance, particularly if the library is very tall and the surrounding area has been flooded."</font></p>
        </div>
       </div>
      <div class="carousel-item">
        <img src="https://media.shakespeare.org.uk/images/Bookshop_2.2e16d0ba.fill-1920x1080-c75.jpg" alt="..." width="1400" height="500">
       
      </div>
      <div class="carousel-item">
        <img src="https://images.unsplash.com/photo-1529007196863-d07650a3f0ea?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80" alt="..." width="1400" height="500">
        <div class="carousel-caption d-none d-md-block">
         
          <p><font size=5>"The very existence of libraries affords the best evidence that we may yet have hope for the future of man"</font></p>
        </div>
      </div>
    </div>
    <a class="carousel-control-prev" href="#carouselExampleCaptions" role="button" data-slide="prev">
      <span class="carousel-control-prev-icon" aria-hidden="true"></span>
      <span class="sr-only">Previous</span>
    </a>
    <a class="carousel-control-next" href="#carouselExampleCaptions" role="button" data-slide="next">
      <span class="carousel-control-next-icon" aria-hidden="true"></span>
      <span class="sr-only">Next</span>
    </a>
  </div>
</div>

<div class="jumbotron text-center mb-0 mt-2">
  <h1 class="display-4" >CENTRAL INSTITUTE LIBRARY</h1>
  <p class="lead">"Libraries store the energy that fuels the imagination. They open up windows to the world and inspire us to explore and achieve, and contribute to improving our quality of life. Libraries change lives for the better."- Sidney Sheldon
</p>
  <hr>
  <p>Gateway to Discover, Connect and Learn</p>
</div>

<section class="container">
	<h1 class="text-center text-dark">About Us</h1>
	<hr class="mx-auto w-25 text-dark">
	<div class="row mt-4">
		<div class="col-lg-6">
			<img src="http://creativelibraryconcepts.com/wp-content/uploads/2017/06/standard-library-shelf-1024x683.jpg" class="img-fluid" width="800" style="height:55vh">
		</div>
		<div class="col-lg-6 mt-1">
			<h3 class="text-dark" style="font-family: 'Josefin Sans', sans-serif;">Know the Facts</h3>
			<hr>
			<p style="font-family: Courgette, cursive;"><font size=3>The Central Institute Library is housed in a state-of-the-art new building, covering about 65000 sq.ft area and is located close to all academic blocks of the Institute. With attractive palatial interiors and a seating capacity of 750, the library includes, well-lit reading halls, stacks, display areas, e-library zones, audio-visual library and study carrels. There are a couple of air-conditioned reading halls.
			</font></p>
			<button type="button" class="btn btn-primary"><a href="About.jsp" class="text-white">View More...</a></button>
		</div>
	</div>

	<div class="row mt-5">
		<div class="col-lg-6 mt-1">
			<h3 class="text-dark">Collection Of Books</h3>
			<hr>
			<p style="font-family: Courgette, cursive;"><font size=3>The library is fully automated with a collection of over 2,45,000 books, manuscripts, a good collection of rare books with bound volumes of journals since 1920s. Library subscribes to over 209 printed National and International journals. About 39,106 full-text e-journals and as many as 36 databases have been made available on the campus network and can be accessed in the hostel rooms and staff residences.</font></p>
			<button type="button" class="btn btn-primary mt-3" padding=2 ><a href="About.jsp" class="text-white">View More...</a></button>
		</div>
		<div class="col-lg-6 mt-1">
			<img src="https://www.libraryjournal.com/binaries/content/gallery/home-shelfie_kp_smaller.jpg" width=100% class="img-fluid" style="height:55vh">
		</div>
	</div>
</section>

<div class="row container mx-auto">
<div class="card col-lg-3 mx-auto bg-light border border-dark" style="margin-top:1%">
  <img src="https://i0.wp.com/api.gretchenrubin.com/wp-content/uploads/2017/08/gretchen-rubin-books-6.jpg?quality=90&resize=650%2C355" class="card-img-top pt-3" alt="first image" height="220">
  <div class="card-body">
    <h5 class="card-title">Latest Arrivals</h5>
    <a href="About.jsp#latest" class="btn btn-primary" target="_blank">Read more ...</a>
  </div>
</div>

<div class="card col-lg-3 mx-auto bg-light border border-dark" style="margin-top:1%">
  <img src="https://www.foundationeducation.edu.au/sites/default/files/jumbotron/Course_COURSEHOME_79441093_1920x1080_0.jpg" class="card-img-top pt-3" alt="first image" height="220">
  <div class="card-body">
    <h5 class="card-title">E-resources</h5>
    
    <a href="Eresources.jsp" class="btn btn-primary" target="_blank">Read more ...</a>
  </div>
</div>

<div class="card col-lg-3 mx-auto bg-light border border-dark" style="margin-top:1%">
  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVxg5WlmbchiZ3BJ-zTOeWg6vKXoiiyzQlNuPL5uiru_nBZY9jQQ" class="card-img-top pt-3" alt="first image" height="220">
  <div class="card-body">
    <h5 class="card-title">Library Rules</h5>   
    <a href="About.jsp#rules" class="btn btn-primary" target="_blank">Read more ...</a>
  </div>
</div>
</div>

<style>
.card:hover {
  transform: scale(1.1);
  transition: transform .3s;
}
</style>

<section class="mt-0">
	<div class="py-2" style="background-color: #5833FF">
		<div class="text-center text-warning">
		<h1>Get Access To All The Books For Free</h1>
		<h3>Join the Library Portal Now</h1>
	</div>
		<!-- Button trigger modal -->
		<div class="text-center">
		<a href="LoginPage.jsp"><button type="button" class="btn btn-success mx-4 bg-warning text-dark">
		  <b>Sign In</b>
		</button>
		</a>
		<a href="StudentSignupPage.jsp">
		<button type="button" class="btn btn-success mx-4 bg-warning text-dark">
		  <b>Sign Up</b>
		</button>
		</a>
		</div>
	</div>
</section>

<section id="footer">
		<div class="container">
			<div class="row text-center text-xs-center text-sm-left text-md-left">
				<div class="col-xs-12 col-sm-4 col-md-4">
					<h5>Home</h5>
					<ul class="list-unstyled quick-links">
						<li><a href="About.jsp"><i class="fa fa-angle-double-right"></i>Book Collection</a></li>
						<li><a href="#"><i class="fa fa-angle-double-right"></i>Institute Bulletin</a></li>
						<li><a href="Eresources.jsp"><i class="fa fa-angle-double-right"></i>E-Resources</a></li>
						<li><a href="" data-toggle="modal" data-target="#contactModal"><i class="fa fa-angle-double-right"></i>Contact</a></li>
						
					</ul>
				</div>
				<div class="col-xs-12 col-sm-4 col-md-4">
					<h5>Quick links</h5>
					<ul class="list-unstyled quick-links">
						<li><a href="LoginPage.jsp"><i class="fa fa-angle-double-right"></i>Admin Login</a></li>
						<li><a href="LoginPage.jsp"><i class="fa fa-angle-double-right"></i>Student Login</a></li>
						<li><a href="StudentSignupPage.jsp"><i class="fa fa-angle-double-right"></i>Student Sign Up</a></li>			
					
					</ul>
				</div>
				<div class="col-xs-12 col-sm-4 col-md-4">
					<h5>About Us</h5>
					<ul class="list-unstyled quick-links">
						<li><a href="KnowLibrary.jsp"><i class="fa fa-angle-double-right"></i>Know Your Library</a></li>
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

				<!-- User loggedOut Modal -->
<div class="modal fade" id="loggedOutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content" style="background-color:#AEF99B">
    <div class="modal-header">
      <h5 class="modal-title"><i class="fa fa-check-circle fa-2x" aria-hidden="true"></i></h5>
      <button type="button" onclick="Redirect()" style="position:absolute; right:10px" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
      </button>
    </div>
      <div class="modal-body text-dark mt-0 pt-0 font-weight-bold">
        You have been successfully logged out.
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

<c:if test="${logoutDone != null}">
	<script>
		document.getElementById('loggedOutLink').click();
	</script>
</c:if>

<script type="text/javascript">
	function Redirect()
	{
		window.location="https://library-portal.herokuapp.com/";
	}
</script>

<!-- <script>document.getElementById('loginButton').click();</script>  -->

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

.ui-menu .ui-menu-item-wrapper:hover, .ui-menu .ui-menu-item-wrapper.ui-state-active {
    color: #303030;
    background-color: #A5C4FF;
    border: #fff 1px solid;
    border-radius: 5px;
}

.ui-menu {
    border-radius: 5px;
}

.ui-widget {
	font-family: Courgette, cursive;
	}

</style>


</body>
</html>