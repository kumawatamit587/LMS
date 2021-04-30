package com.portal.LMS.controller;



import java.math.BigInteger;
import java.sql.Date;
import java.util.List;

import javax.annotation.PreDestroy;
import javax.persistence.EntityManager;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.hibernate.Session;
import org.hibernate.query.NativeQuery;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.portal.LMS.entity.AdminDetails;
import com.portal.LMS.entity.BookDetails;
import com.portal.LMS.entity.BookList;
import com.portal.LMS.entity.Feedback;
import com.portal.LMS.entity.IssueBookHistory;
import com.portal.LMS.entity.IssueBookHistory2;
import com.portal.LMS.entity.StudentDetails;
import com.portal.LMS.entity.VendorDetails;

@Controller
public class MyController {
	
	@Autowired
	private EntityManager entityManager;
	
	@Autowired
	HttpServletRequest request;
	
	@Autowired
	HttpServletResponse response;

	@RequestMapping(value={"/","/main"})
	@Transactional
	public String main()
	{
		calculateTotalDays();
		return "main";
	}
	
	@PostMapping("/adminLogin")
	@Transactional
	public String adminLogin(@ModelAttribute("theAdmin") AdminDetails theAdmin, Model theModel) throws Exception 
	{
		Session currentSession = entityManager.unwrap(Session.class);
		AdminDetails obj = currentSession.get(AdminDetails.class, theAdmin.getUsername());
			
		if(obj!=null)
		{
			EncryptPassword ep=new EncryptPassword();
			if((ep.encrypt(theAdmin.getPassword())).compareTo(obj.getPassword())==0)
			{
				HttpSession session=request.getSession();
				session.setAttribute("adminUsername",obj.getUsername());
				return "redirect:/adminPage";
			}
		}
		
		theModel.addAttribute("adminLoginError", "Invalid Credentials!");
		return "LoginPage";
	}
	
	@RequestMapping("/adminPage")
	public String adminPage()
	{
		return "AdminPage";
	}
	
	@PostMapping("/studentLogin")
	@Transactional
	public String studentLogin(@ModelAttribute("theStudent") StudentDetails theStudent, Model theModel) throws Exception 
	{
//		System.out.println(request.getRequestURI());
//		System.out.println(request.getRequestURL().toString());
		
		Session currentSession = entityManager.unwrap(Session.class);
		StudentDetails obj=currentSession.get(StudentDetails.class, theStudent.getUsername());
				
		if(obj!=null)
		{
			EncryptPassword ep=new EncryptPassword();
			if((ep.encrypt(theStudent.getPassword())).compareTo(obj.getPassword())==0)
			{
				HttpSession session=request.getSession();
				session.setAttribute("studentUsername",obj.getUsername());
				return "redirect:/studentPage";
			}
		}
		
		theModel.addAttribute("studentLoginError", "Invalid Credentials!");
		return "LoginPage";
	}
	
	@RequestMapping("/studentPage")
	public String studentPage()
	{
		return "StudentPage";
	}
	
	@PostMapping("/adminSignup")
	@Transactional
	public String adminSignup(@ModelAttribute("newAdmin") AdminDetails theAdmin, Model theModel) throws Exception 
	{
		String password=theAdmin.getPassword();
		
		EncryptPassword ep=new EncryptPassword();
		theAdmin.setPassword(ep.encrypt(password));
		
		Session currentSession = entityManager.unwrap(Session.class);
		AdminDetails obj=currentSession.get(AdminDetails.class, theAdmin.getUsername());
		if(obj==null)
			currentSession.save(theAdmin);       //if no same username found then create new admin account
		else
		{
			theModel.addAttribute("firstname", theAdmin.getFirstname());
			theModel.addAttribute("lastname", theAdmin.getLastname());
			theModel.addAttribute("username", theAdmin.getUsername());
			theModel.addAttribute("password", password);
			theModel.addAttribute("usernameExistsError", "Username exists");
			return "AdminSignupPage";
		}
		
		theModel.addAttribute("success", "New user created!");
		return "AdminSignupPage";	
	}
	
	@PostMapping("/studentSignup")
	@Transactional
	public String studentSignup(@ModelAttribute("newstudent") StudentDetails theStudent, Model theModel) throws Exception 
	{
		String password=theStudent.getPassword();
		
		EncryptPassword ep=new EncryptPassword();
		theStudent.setPassword(ep.encrypt(theStudent.getPassword()));
		
		Session currentSession = entityManager.unwrap(Session.class);
		StudentDetails obj=currentSession.get(StudentDetails.class, theStudent.getUsername());
		if(obj==null)
			currentSession.save(theStudent);       //if no same username found then create new user
		else
		{
			theModel.addAttribute("firstname", theStudent.getFirstname());
			theModel.addAttribute("lastname", theStudent.getLastname());
			theModel.addAttribute("email", theStudent.getEmail());
			theModel.addAttribute("contact", theStudent.getContact());
			theModel.addAttribute("username", theStudent.getUsername());
			theModel.addAttribute("password", password);
			theModel.addAttribute("usernameExistsError", "Username exists");
			return "StudentSignupPage";
		}
		
		theModel.addAttribute("success", "New user created!");
		return "StudentSignupPage";
		
	}
	
	@RequestMapping("/logout")
	public String logout(Model theModel)
	{
		HttpSession session=request.getSession();
		session.removeAttribute("adminUsername");
		session.removeAttribute("studentUsername");
		session.invalidate();
		theModel.addAttribute("logoutDone", "successfully logged out");
		
		return "main";
	}
	
	@GetMapping("/bookList")
	@Transactional
	public String bookDetails(Model theModel)
	{
		Session currentSession = entityManager.unwrap(Session.class);
		Query<BookDetails> query=currentSession.createQuery("from BookDetails",BookDetails.class);
		List<BookDetails> bookDetails=query.getResultList();
		theModel.addAttribute("bookdetails",bookDetails);
		if(bookDetails.isEmpty())
			theModel.addAttribute("emptyBookDetails","No books available");
		
		HttpSession session = request.getSession();
		if(session.getAttribute("adminUsername") != null)
			return "BookList";
		
		return "StudentBookList";
	}
	
	
	@GetMapping("/viewBookList")
	@Transactional
	public String viewBookDetails(@RequestParam("bookId") int bookId, Model theModel)
	{
		Session currentSession = entityManager.unwrap(Session.class);
		Query<BookDetails> query1=currentSession.createQuery("from BookDetails",BookDetails.class);
		List<BookDetails> bookDetails=query1.getResultList();
		theModel.addAttribute("bookdetails",bookDetails);
		
		@SuppressWarnings("unchecked")
		NativeQuery<BookList> query2=currentSession.createSQLQuery("select * from booklist where id="+bookId);
		query2.addEntity(BookList.class);
		List<BookList> bookList=query2.list();
		theModel.addAttribute("bookList",bookList);
		theModel.addAttribute("bookid",bookId);
		
		HttpSession session = request.getSession();
		if(session.getAttribute("adminUsername") != null)
			return "BookList";
		
		return "StudentBookList";
	}
	
	@GetMapping("/viewAddBook")
	@Transactional
	public String viewaddBook(Model theModel)
	{
		System.out.println("Inside /viewAddBook");
		
		Session currentSession = entityManager.unwrap(Session.class);
		
		Query<VendorDetails> query1=currentSession.createQuery("from VendorDetails",VendorDetails.class);
		List<VendorDetails> vendorDetails=query1.getResultList();
		theModel.addAttribute("vendorDetails",vendorDetails);
		if(vendorDetails.isEmpty())
			theModel.addAttribute("emptyVendorDetails", "First add a vendor.");
		
		Query<BookDetails> query2=currentSession.createQuery("from BookDetails",BookDetails.class);
		List<BookDetails> bookDetails=query2.getResultList();
		theModel.addAttribute("bookdetails",bookDetails);
		if(bookDetails.isEmpty())
			theModel.addAttribute("emptyBookDetails", "No books available.");
		
		return "AddBook";
	}
	
	
	@PostMapping("/addNewBook")
	@Transactional
	public String addNewBook(@ModelAttribute("theBookDetails") BookDetails theBookDetails , Model theModel)
	{
		int vendorId = Integer.parseInt(request.getParameter("vendorid"));
		System.out.println("vendorId = "+vendorId);
		Session currentSession = entityManager.unwrap(Session.class);
		@SuppressWarnings("rawtypes")
		NativeQuery query=currentSession.createSQLQuery("select * from book_details where bookname=:bookname and author=:author and publisher=:publisher");
		query.addEntity(BookDetails.class);
		query.setParameter("bookname", theBookDetails.getBookname());
		query.setParameter("author", theBookDetails.getAuthor());
		query.setParameter("publisher", theBookDetails.getPublisher());
		
		@SuppressWarnings("unchecked")
		List<BookDetails> obj=query.list();
			
		if(obj.isEmpty())
		{
			theBookDetails.setCopies(theBookDetails.getTotalcopies());
			VendorDetails vendorDetails = currentSession.get(VendorDetails.class, vendorId);
			for(int i=0;i<theBookDetails.getTotalcopies();i++)
			{
				BookList bookList=new BookList("Available");
				theBookDetails.add(bookList);
				vendorDetails.add(bookList);
				currentSession.save(bookList);
			}
			currentSession.save(theBookDetails);
			currentSession.save(vendorDetails);
			theModel.addAttribute("newBookAdded","New Book added!");
		}
		else
		{
			theModel.addAttribute("bookname", theBookDetails.getBookname());
			theModel.addAttribute("author", theBookDetails.getAuthor());
			theModel.addAttribute("pages", theBookDetails.getPages());
			theModel.addAttribute("publisher", theBookDetails.getPublisher());
			theModel.addAttribute("genre", theBookDetails.getGenre());
			theModel.addAttribute("totalcopies", theBookDetails.getTotalcopies());
			theModel.addAttribute("vendorid", vendorId);
			theModel.addAttribute("newBookError","Book already exists");
		}
		
		Query<BookDetails> query1=currentSession.createQuery("from BookDetails",BookDetails.class);
		List<BookDetails> bookDetails=query1.getResultList();
		theModel.addAttribute("bookdetails",bookDetails);
		
		Query<VendorDetails> query2=currentSession.createQuery("from VendorDetails",VendorDetails.class);
		List<VendorDetails> vendorDetails=query2.getResultList();
		theModel.addAttribute("vendorDetails",vendorDetails);
		
		theModel.addAttribute("clickButton","Slide down");
		return "AddBook";
	}
	
	
	@GetMapping("/addCopies")
	@Transactional
	public String addBook(@RequestParam("bookId") int bookId, @RequestParam("totalCopies") int totalCopies, 
						  @RequestParam("copies") int availableCopies, @RequestParam("newCopies") int newCopies, 
						  @RequestParam("vendorid") int vendorId, Model theModel)
	{
		Session currentSession = entityManager.unwrap(Session.class);
		@SuppressWarnings("rawtypes")
		Query query=currentSession.createQuery("update BookDetails set totalcopies=:newtotalcopies , copies=:availableCopies where bookid=:bookId");
		query.setParameter("newtotalcopies", totalCopies+newCopies);
		query.setParameter("availableCopies", availableCopies+newCopies);
		query.setParameter("bookId", bookId);
		query.executeUpdate();
		
		
		BookDetails theBookDetails=currentSession.get(BookDetails.class, bookId);
		VendorDetails theVendorDetails=currentSession.get(VendorDetails.class, vendorId);
		for(int i=0;i<newCopies;i++)
		{
			BookList bookList=new BookList("Available");
			theBookDetails.add(bookList);
			theVendorDetails.add(bookList);
			currentSession.save(bookList);
		}
		currentSession.save(theVendorDetails);
		
		Query<BookDetails> query1=currentSession.createQuery("from BookDetails",BookDetails.class);
		List<BookDetails> bookDetails=query1.getResultList();
		theModel.addAttribute("bookdetails",bookDetails);
		if(bookDetails.isEmpty())
			theModel.addAttribute("emptyBookDetails", "No books available.");
		
		Query<VendorDetails> query2=currentSession.createQuery("from VendorDetails",VendorDetails.class);
		List<VendorDetails> vendorDetails=query2.getResultList();
		theModel.addAttribute("vendorDetails",vendorDetails);
		
		theModel.addAttribute("bookCopiesAdded","book copies added");
		return "AddBook";
	}
	
	@GetMapping("/issueBook")
	@Transactional
	public String issueBook(Model theModel)
	{
		Session currentSession = entityManager.unwrap(Session.class);
		Query<BookDetails> query=currentSession.createQuery("from BookDetails where copies>0",BookDetails.class);
		List<BookDetails> bookDetails=query.getResultList();
		theModel.addAttribute("bookdetails",bookDetails);
		if(bookDetails.isEmpty())
			theModel.addAttribute("emptyBookDetails", "No books available for issue.");
		
		return "IssueBook";
	}
	
	
	@GetMapping("/issueBookList")
	@Transactional
	public String issueBookList(@RequestParam("bookId") int bookId, Model theModel)
	{
		Session currentSession = entityManager.unwrap(Session.class);
		Query<BookDetails> query1=currentSession.createQuery("from BookDetails",BookDetails.class);
		List<BookDetails> bookDetails=query1.getResultList();
		theModel.addAttribute("bookdetails",bookDetails);
		
		@SuppressWarnings("unchecked")
		NativeQuery<BookList> query2=currentSession.createSQLQuery("select * from booklist where id="+bookId);
		query2.addEntity(BookList.class);
		List<BookList> bookList=query2.list();
		theModel.addAttribute("bookList",bookList);
		theModel.addAttribute("bookid",bookId);
		
		System.out.println("booklist : "+bookList.get(0).barcode);
		return "IssueBook";
	}
	
	@RequestMapping("/issueBookUsername")
	@Transactional
	public String issueBookUsername(@RequestParam("bookId") int bookid, @RequestParam("barcode") int barcode, Model theModel)
	{
		Session currentSession = entityManager.unwrap(Session.class);
		Query<BookDetails> query1=currentSession.createQuery("from BookDetails",BookDetails.class);
		List<BookDetails> bookDetails=query1.getResultList();
		theModel.addAttribute("bookdetails",bookDetails);
		
		theModel.addAttribute("bookId", bookid);
		theModel.addAttribute("barcode", barcode);
		return "IssueBook";
	}
	
	
	@PostMapping("/issueBookConfirm")
	@Transactional
	public String issueBookConfirm(Model theModel)
	{
		int bookId= Integer.parseInt(request.getParameter("bookid"));
		int barcode=Integer.parseInt(request.getParameter("barcode"));
		String username=request.getParameter("username");
		
		System.out.println("bookId= "+bookId);
		System.out.println("barcode= "+barcode);
		System.out.println("username= "+username);
		
		Session currentSession = entityManager.unwrap(Session.class);
		
		StudentDetails studentDetails=currentSession.get(StudentDetails.class, username);
		
		Query<IssueBookHistory> query=currentSession.createQuery("from IssueBookHistory where studentDetails=:studentDetails and returndate is null", IssueBookHistory.class);
		query.setParameter("studentDetails", studentDetails);
		IssueBookHistory theIssueBookHistory= query.uniqueResult();
		
		if(studentDetails==null)
		{
			theModel.addAttribute("invalidUsername", "Invalid Username entered");
		}
		else if(theIssueBookHistory!=null)
		{
			System.out.println("theIssueBookHistory = "+theIssueBookHistory.getStudentDetails().getUsername());
			theModel.addAttribute("bookHolder", "User has already issued a book");
		}
		else
		{
			String studentname = studentDetails.getFirstname() + " " + studentDetails.getLastname();
			BookDetails theBookDetails=currentSession.get(BookDetails.class, bookId);
			BookList bookList=currentSession.get(BookList.class, barcode);
			long millis=System.currentTimeMillis();  
	        Date issueDate=new Date(millis);
	        Date returnDate=null;
	        int totalDays=0;
	        
	        IssueBookHistory issueBookHistory=new IssueBookHistory();
	        issueBookHistory.setBookDetails(theBookDetails);
	        issueBookHistory.setBookList(bookList);
	        issueBookHistory.setStudentDetails(studentDetails);
	        issueBookHistory.setIssuedate(issueDate);
	        issueBookHistory.setReturndate(returnDate);
	        issueBookHistory.setTotaldays(totalDays);
	        
	        currentSession.save(issueBookHistory);
	        
	        String bookname = theBookDetails.getBookname();
	        IssueBookHistory2 issueBookHistory2=new IssueBookHistory2(bookId, barcode, bookname, username, studentname, issueDate, returnDate, totalDays);
	        currentSession.save(issueBookHistory2);
	        
	        int copies=theBookDetails.getCopies();
	        @SuppressWarnings("rawtypes")
			Query query1=currentSession.createQuery("update BookDetails set copies=:copies where bookid=:bookid");
	        query1.setParameter("copies", copies-1);
	        query1.setParameter("bookid", bookId);
	        query1.executeUpdate();
	        
	        @SuppressWarnings("rawtypes")
			Query query2=currentSession.createQuery("update BookList set status=:status where barcode=:barcode");
	        query2.setParameter("status", "Unavailable");
	        query2.setParameter("barcode", barcode);
	        query2.executeUpdate();
	        
	        theModel.addAttribute("bookIssued", "Book issued successfully");
	        
	        String email = studentDetails.getEmail();
	        SendMessage obj = new SendMessage();
	        String result = obj.sendIssueMessage(barcode, bookname, email, issueDate, 0);
	        theModel.addAttribute("result",result);
		}
		
		Query<BookDetails> query3=currentSession.createQuery("from BookDetails",BookDetails.class);
		List<BookDetails> bookDetails=query3.getResultList();
		theModel.addAttribute("bookdetails",bookDetails);
		theModel.addAttribute("erbookdetails","errbookDetails");
		
		return "IssueBook";
	}
	
	
	@RequestMapping("/returnBook")
	@Transactional
	public String returnBook(Model theModel)
	{
		Session currentSession = entityManager.unwrap(Session.class);
		//calculateTotalDays();
		Query<IssueBookHistory> query3 = currentSession.createQuery("from IssueBookHistory where returndate is null", IssueBookHistory.class);
		List<IssueBookHistory> issueBookHistory = query3.getResultList();
		theModel.addAttribute("issueBookHistory", issueBookHistory);
		
		if(!(issueBookHistory.isEmpty()))
			theModel.addAttribute("status", "not empty");
		
		return "ReturnBook";
	}
	
	
	@RequestMapping("/returnBookModal")
	@Transactional
	public String returnBookModal(@RequestParam("issueId") int issueId, Model theModel)
	{
		Session currentSession = entityManager.unwrap(Session.class);
		Query<IssueBookHistory> query3 = currentSession.createQuery("from IssueBookHistory where returndate is null", IssueBookHistory.class);
		List<IssueBookHistory> issueBookHistory = query3.getResultList();
		theModel.addAttribute("issueBookHistory", issueBookHistory);
		theModel.addAttribute("issueid", issueId);
		theModel.addAttribute("openModal", "Done");
		
		if(!(issueBookHistory.isEmpty()))
			theModel.addAttribute("status", "not empty");
		
		return "ReturnBook";
	}
	
	@RequestMapping("/returnBookConfirm")
	@Transactional
	public String returnBookConfirm(Model theModel)
	{
		int issueId=Integer.parseInt(request.getParameter("issueId"));
		Session currentSession = entityManager.unwrap(Session.class);
		IssueBookHistory theIssueBookHistory = currentSession.get(IssueBookHistory.class, issueId);
		theIssueBookHistory.getBookList().setStatus("Available");
		int copies = theIssueBookHistory.getBookDetails().getCopies();
		theIssueBookHistory.getBookDetails().setCopies(copies+1);
		long millis=System.currentTimeMillis();  
        Date todayDate=new Date(millis);
        theIssueBookHistory.setReturndate(todayDate);
        
        IssueBookHistory2 theIssueBookHistory2 = currentSession.get(IssueBookHistory2.class, issueId);
        theIssueBookHistory2.setReturndate(todayDate);
		
		Query<IssueBookHistory> query = currentSession.createQuery("from IssueBookHistory where returndate is null", IssueBookHistory.class);
		List<IssueBookHistory> issueBookHistory = query.getResultList();
		theModel.addAttribute("issueBookHistory", issueBookHistory);
		theModel.addAttribute("issueid", issueId);
		theModel.addAttribute("returnDone", "Book returned");
		
		if(!(issueBookHistory.isEmpty()))
			theModel.addAttribute("status", "not empty");
		
		return "ReturnBook";
	}
	
	@RequestMapping("/userDetails")
	@Transactional
	public String userDetails(Model theModel)
	{
		Session currentSession = entityManager.unwrap(Session.class);
		//calculateTotalDays();
		Query<StudentDetails> query = currentSession.createQuery("from StudentDetails", StudentDetails.class);
		List<StudentDetails> studentDetails = query.list();
		theModel.addAttribute("studentDetails", studentDetails);
		if(studentDetails.isEmpty())
			theModel.addAttribute("emptyStudentDetails", "No students available.");
		
		return "UserDetails";
	}
	
	@PostMapping("/fetchUserDetails")
	@Transactional
	public String fetchUserDetails(Model theModel)
	{
		String username = request.getParameter("username");
		Session currentSession = entityManager.unwrap(Session.class);
		StudentDetails studentDetails = currentSession.get(StudentDetails.class, username);
		theModel.addAttribute("studentDetails", studentDetails);
		
		Query<IssueBookHistory2> query = currentSession.createQuery("from IssueBookHistory2 where username=:username", IssueBookHistory2.class);
		query.setParameter("username", username);
		List<IssueBookHistory2> studentIssueBookHistory = query.list();
		theModel.addAttribute("studentIssueBookHistory", studentIssueBookHistory);
		
		if(studentIssueBookHistory.isEmpty())
			theModel.addAttribute("emptyBookHistory", "Student has 0 book issues");
		
		return "FetchUserDetails";
	}
	
	@RequestMapping("/individualBookDetails")
	@Transactional
	public String individualBookDetails(Model theModel)
	{
		Session currentSession = entityManager.unwrap(Session.class);
		//calculateTotalDays();
		Query<BookDetails> query = currentSession.createQuery("from BookDetails", BookDetails.class);
		List<BookDetails> bookDetails = query.list();
		theModel.addAttribute("bookDetails", bookDetails);
		if(bookDetails.isEmpty())
			theModel.addAttribute("emptyBookDetails", "No book available.");
		
		return "BookDetails";
	}
	
	@RequestMapping("/fetchIndividualBookDetails")
	@Transactional
	public String fetchIndividualBookDetails(Model theModel)
	{
		int bookid = Integer.parseInt(request.getParameter("bookid"));
		Session currentSession = entityManager.unwrap(Session.class);
		BookDetails bookDetails = currentSession.get(BookDetails.class, bookid);
		theModel.addAttribute("bookDetails", bookDetails);
		
		Query<IssueBookHistory2> query = currentSession.createQuery("from IssueBookHistory2 where bookid=:bookid", IssueBookHistory2.class);
		query.setParameter("bookid", bookid);
		List<IssueBookHistory2> bookIssueBookHistory = query.list();
		theModel.addAttribute("bookIssueBookHistory", bookIssueBookHistory);
		
		if(bookIssueBookHistory.isEmpty())
			theModel.addAttribute("emptyStudentHistory", "Book has not been issued yet");
		
		return "FetchIndividualBookDetails";
	}
	
	
	@GetMapping("/deleteBook")
	@Transactional
	public String deleteBook(Model theModel)
	{	
		Session currentSession=entityManager.unwrap(Session.class);
		Query<BookDetails> query=currentSession.createQuery("from BookDetails where copies>0",BookDetails.class);
		List<BookDetails> bookDetails=query.getResultList();
		theModel.addAttribute("bookdetails",bookDetails);
		if(bookDetails.isEmpty())
			theModel.addAttribute("emptyBookDetails", "No books to delete.");
		
		return "DeleteBook";
	}
	
	
	@GetMapping("/deleteBookList")
	@Transactional
	public String deleteBookList(@RequestParam("bookId") int bookId, Model theModel)
	{
		Session currentSession=entityManager.unwrap(Session.class);
		Query<BookDetails> query1=currentSession.createQuery("from BookDetails",BookDetails.class);
		List<BookDetails> bookDetails=query1.getResultList();
		theModel.addAttribute("bookdetails",bookDetails);
		
		@SuppressWarnings("unchecked")
		NativeQuery<BookList> query2=currentSession.createSQLQuery("select * from booklist where id="+bookId);
		query2.addEntity(BookList.class);
		List<BookList> bookList=query2.list();
		theModel.addAttribute("bookList",bookList);
		theModel.addAttribute("bookid",bookId);
		theModel.addAttribute("showList","show book list");
		
		return "DeleteBook";
	}
	
	@GetMapping("/deleteBookConfirmModal")
	@Transactional
	public String deleteBookConfirmModal(@RequestParam("bookId") int bookid, @RequestParam("barcode") int barcode,Model theModel)
	{
		Session currentSession=entityManager.unwrap(Session.class);
		Query<BookDetails> query1=currentSession.createQuery("from BookDetails",BookDetails.class);
		List<BookDetails> bookDetails=query1.getResultList();
		theModel.addAttribute("bookdetails",bookDetails);
		theModel.addAttribute("bookId", bookid);
		theModel.addAttribute("barcode", barcode);
		theModel.addAttribute("deleteBookConfirmation", "Delete the book!");
		
		return "DeleteBook";
	}
	
	@PostMapping("/deleteBookConfirm")
	@Transactional
	public String deleteBookConfirm(Model theModel)
	{
		int bookid=Integer.parseInt(request.getParameter("bookId"));
		int barcode=Integer.parseInt(request.getParameter("barcode"));
		Session currentSession=entityManager.unwrap(Session.class);
		
		BookList bookList = currentSession.get(BookList.class, barcode);
		if(bookList != null)
		{
			currentSession.delete(bookList);
			BookDetails thebookDetails = currentSession.get(BookDetails.class, bookid);
			@SuppressWarnings("rawtypes")
			Query query1 = currentSession.createQuery("update BookDetails set totalcopies=:totalcopies , copies=:copies where bookid=:bookid");
			query1.setParameter("totalcopies", thebookDetails.getTotalcopies()-1);
			query1.setParameter("copies", thebookDetails.getCopies()-1);
			query1.setParameter("bookid", bookid);
			query1.executeUpdate();
			theModel.addAttribute("deleteBookDone", "book deleted successfully");
		}
		
		Query<BookDetails> query2 = currentSession.createQuery("from BookDetails", BookDetails.class);
		List<BookDetails> bookDetails=query2.getResultList();
		theModel.addAttribute("bookdetails",bookDetails);	
		if(bookDetails.isEmpty())
			theModel.addAttribute("emptyBookDetails", "No books to delete.");
		
		return "DeleteBook";
	}
	
	
	@PostMapping("/deleteAllBooksConfirmModal")
	@Transactional
	public String deleteAllBooksConfirmModal(Model theModel)
	{
		int bookid=Integer.parseInt(request.getParameter("bookId"));
		Session currentSession=entityManager.unwrap(Session.class);
		Query<BookDetails> query1=currentSession.createQuery("from BookDetails",BookDetails.class);
		List<BookDetails> bookDetails=query1.getResultList();
		theModel.addAttribute("bookdetails",bookDetails);
		theModel.addAttribute("bookId", bookid);
		theModel.addAttribute("deleteAllBooksConfirmation", "Delete all books!");
		
		return "DeleteBook";
	}
	
	@PostMapping("/deleteAllBooksConfirm")
	@Transactional
	public String deleteAllBooksConfirm(Model theModel)
	{
		int bookid=Integer.parseInt(request.getParameter("bookId"));
		Session currentSession=entityManager.unwrap(Session.class);
		
		BookDetails theBookDetails = currentSession.get(BookDetails.class, bookid);
		if(theBookDetails.getTotalcopies()==theBookDetails.getCopies())
		{
			currentSession.delete(theBookDetails);
		}
		else
		{
			List<BookList> bookList = theBookDetails.getBookList();
			for(int i=0;i<bookList.size();)
			{
				System.out.println("i= "+i);
				if(((bookList.get(i)).getStatus()).compareTo("Available")==0)
				{
					currentSession.delete(bookList.get(i));
					bookList.remove(i);
					theBookDetails.setTotalcopies(theBookDetails.getTotalcopies()-1);
					theBookDetails.setCopies(theBookDetails.getCopies()-1);
				}
				else
					i++;
			}
		}
		
		Query<BookDetails> query2 = currentSession.createQuery("from BookDetails", BookDetails.class);
		List<BookDetails> bookDetails=query2.getResultList();
		theModel.addAttribute("bookdetails",bookDetails);	
		if(bookDetails.isEmpty())
			theModel.addAttribute("emptyBookDetails", "No books to delete.");
		theModel.addAttribute("deleteAllBooksDone","All books deleted successfully");	
		
		return "DeleteBook";
	}

	@RequestMapping("/bookIssueHistory/{pageNo}")
	@Transactional
	public String bookIssueHistoryPagination(@PathVariable("pageNo") int pageNo)
	{
		HttpSession session=request.getSession();
		Session currentSession=entityManager.unwrap(Session.class);
		
		@SuppressWarnings("rawtypes")
		Query query1=currentSession.createQuery("select count(issueid) from IssueBookHistory2");
		long t =  (long) query1.getSingleResult();
		int totalPages=(int)Math.ceil(((double)t)/10);
		System.out.println("t : "+t);
		System.out.println("totalPages : "+totalPages);
		session.setAttribute("totalPages", totalPages);
		session.setAttribute("pageNo", pageNo);
		
		@SuppressWarnings("rawtypes")
		NativeQuery query2 = currentSession.createSQLQuery("select * from issue_book_history2 limit :limit offset :offset");
		query2.addEntity(IssueBookHistory2.class);
		query2.setParameter("limit", 10);
		query2.setParameter("offset", 10*(pageNo-1));
		@SuppressWarnings("unchecked")
		List<IssueBookHistory2> issueBookHistory2 = query2.getResultList();
		session.setAttribute("issueBookHistory", issueBookHistory2);
		
		if(issueBookHistory2.isEmpty())
			session.setAttribute("emptyIssueBookHistory", "No records present");
		
		return "redirect:/BookIssueHistory.jsp";
	}


	@RequestMapping("/sendReminderMail")
	@Transactional
	public String sendReminderMail(Model theModel)
	{
		//calculateTotalDays();
		Session currentSession=entityManager.unwrap(Session.class);
		Query<IssueBookHistory> query = currentSession.createQuery("from IssueBookHistory where returndate is null and totaldays>6", IssueBookHistory.class);
		List<IssueBookHistory> issueBookHistory = query.getResultList();
		SendMessage obj = new SendMessage();
		int count = obj.sendReminderMessage(issueBookHistory);
		
		if(count == 0)
			theModel.addAttribute("result", "No mails sent due to network problem.");
		else if(count == issueBookHistory.size())
			theModel.addAttribute("result", "Mails have been sent to all the students.");
		else
			theModel.addAttribute("result", "Only some of the mails sent. This could be due to network error or any other possible reason.");
		
		theModel.addAttribute("count", count); 
		return "AdminPage";
	}
	
	@Transactional
	public void calculateTotalDays()
	{
		Session currentSession = entityManager.unwrap(Session.class);
		Query<IssueBookHistory> query1 = currentSession.createQuery("from IssueBookHistory where returndate is null", IssueBookHistory.class);
		List<IssueBookHistory> theIssueBookHistory = query1.getResultList();
		for(int i=0;i<theIssueBookHistory.size();i++)
		{
			Date issueDate = theIssueBookHistory.get(i).getIssuedate();
			long millis=System.currentTimeMillis();  
	        Date todayDate=new Date(millis);
	        
	        @SuppressWarnings("rawtypes")
			NativeQuery query2 = currentSession.createSQLQuery("select datediff(:todayDate, :issueDate)");
	        query2.setParameter("todayDate", todayDate);
	        query2.setParameter("issueDate", issueDate);
	        int totaldays =  ((BigInteger) query2.uniqueResult()).intValue();
	        
	        @SuppressWarnings("rawtypes")
			Query query3=currentSession.createQuery("update IssueBookHistory set totaldays=:totaldays where bookList=:bookList and returndate is null");
	        query3.setParameter("totaldays", totaldays);
	        query3.setParameter("bookList", theIssueBookHistory.get(i).getBookList());
	        query3.executeUpdate();
	        
	        @SuppressWarnings("rawtypes")
			Query query4=currentSession.createQuery("update IssueBookHistory2 set totaldays=:totaldays where barcode=:barcode and returndate is null");
	        query4.setParameter("totaldays", totaldays);
	        query4.setParameter("barcode", theIssueBookHistory.get(i).getBookList().getBarcode());
	        query4.executeUpdate();
		}
	}
	
	@GetMapping("/viewVendor")
	@Transactional
	public String viewVendor(Model theModel)
	{
		System.out.println("Inside /viewVendor");
		
		Session currentSession=entityManager.unwrap(Session.class);
		Query<VendorDetails> query=currentSession.createQuery("from VendorDetails",VendorDetails.class);
		List<VendorDetails> vendorDetails=query.getResultList();
		theModel.addAttribute("vendorDetails",vendorDetails);
		if(vendorDetails.isEmpty())
			theModel.addAttribute("emptyVendorDetails", "No vendors found.");
		
		return "Vendor";
	}
	
	@RequestMapping("/viewVendorBookList")
	@Transactional
	public String viewVendorBookList(@RequestParam("vendorId") int vendorId, Model theModel)
	{
		Session currentSession = entityManager.unwrap(Session.class);
		Query<VendorDetails> query1=currentSession.createQuery("from VendorDetails",VendorDetails.class);
		List<VendorDetails> vendorDetails=query1.getResultList();
		theModel.addAttribute("vendorDetails",vendorDetails);
		
		VendorDetails theVendor = currentSession.get(VendorDetails.class, vendorId);
		Query<BookList> query2 = currentSession.createQuery("from BookList where vendorDetails=:vendorDetails", BookList.class);
		// to get booklist in ascending barcode order
		query2.setParameter("vendorDetails", theVendor);
		List<BookList> bookList = query2.getResultList();
		theModel.addAttribute("bookList",bookList);
		if(bookList.isEmpty())
			theModel.addAttribute("emptyBookList","Vendor has provided zero books.");

		theModel.addAttribute("openBookList","Open book list modal.");

		return "Vendor";
	}
	
	@PostMapping("/addNewVendor")
	@Transactional
	public String addNewVendor(@ModelAttribute("theVendorDetails") VendorDetails theVendorDetails , Model theModel)
	{
		Session currentSession=entityManager.unwrap(Session.class);
	
		@SuppressWarnings("rawtypes")
		NativeQuery query=currentSession.createSQLQuery("select * from vendor_details where email=:email or contact=:contact");
		query.addEntity(VendorDetails.class);
		query.setParameter("email", theVendorDetails.getEmail());
		query.setParameter("contact", theVendorDetails.getContact());
		
		@SuppressWarnings("unchecked")
		List<VendorDetails> obj=query.list();
			
		System.out.println("obj = "+obj);
		
		if(obj.isEmpty())
		{
			currentSession.save(theVendorDetails);
			theModel.addAttribute("newVendorAdded","New Vendor added!");
		}
		else
		{
			theModel.addAttribute("firstname", theVendorDetails.getFirstname());
			theModel.addAttribute("lastname", theVendorDetails.getLastname());
			theModel.addAttribute("email", theVendorDetails.getEmail());
			theModel.addAttribute("contact", theVendorDetails.getContact());

			theModel.addAttribute("newVendorError","Vendor already exists");
		}
		
		Query<VendorDetails> query1=currentSession.createQuery("from VendorDetails",VendorDetails.class);
		List<VendorDetails> vendorDetails=query1.getResultList();
		theModel.addAttribute("vendorDetails",vendorDetails);
		
		return "Vendor";
	}
	
	@PostMapping("/changeStudentEmail")
	@Transactional
	public String changeStudentEmail(Model theModel)
	{
		String presentEmail = request.getParameter("presentEmail");
		String newEmail = request.getParameter("newEmail");
		HttpSession session = request.getSession();
		String username = (String) session.getAttribute("studentUsername");
		
		Session currentSession = entityManager.unwrap(Session.class);
		Query<StudentDetails> query1 = currentSession.createQuery("from StudentDetails where email=:email and username=:username", StudentDetails.class);
		query1.setParameter("email", presentEmail);
		query1.setParameter("username", username);
		StudentDetails studentDetails = query1.uniqueResult();
		if(studentDetails == null)
		{
			theModel.addAttribute("wrongEmail", "wrong present email");
			theModel.addAttribute("presentEmail", presentEmail);
			theModel.addAttribute("newEmail", newEmail);
		}
		else
		{
			studentDetails.setEmail(newEmail);
			currentSession.update(studentDetails);
			theModel.addAttribute("changedEmail", "New email set up");
		}
		
		return "StudentUpdateDetails";
	}
	
	@PostMapping("/changeStudentContact")
	@Transactional
	public String changeStudentContact(Model theModel)
	{
		String presentContact = request.getParameter("presentContact");
		String newContact = request.getParameter("newContact");
		HttpSession session = request.getSession();
		String username = (String) session.getAttribute("studentUsername");
		
		Session currentSession = entityManager.unwrap(Session.class);
		Query<StudentDetails> query1 = currentSession.createQuery("from StudentDetails where contact=:contact and username=:username", StudentDetails.class);
		query1.setParameter("contact", presentContact);
		query1.setParameter("username", username);
		StudentDetails studentDetails = query1.uniqueResult();
		if(studentDetails == null)
		{
			theModel.addAttribute("wrongContact", "wrong present contact");
			theModel.addAttribute("presentContact", presentContact);
			theModel.addAttribute("newContact", newContact);
		}
		else
		{
			studentDetails.setContact(newContact);
			currentSession.update(studentDetails);
			theModel.addAttribute("changedContact", "New contact set up");
		}
		
		return "StudentUpdateDetails";
	}
	
	@PostMapping("/changeStudentPassword")
	@Transactional
	public String changeStudentPassword(Model theModel) throws Exception
	{
		String presentPassword = request.getParameter("presentPassword");
		String newPassword = request.getParameter("newPassword");
		HttpSession session = request.getSession();
		String username = (String) session.getAttribute("studentUsername");
		EncryptPassword ep = new EncryptPassword();
		String encryptedPresentPassword = ep.encrypt(presentPassword);
		
		Session currentSession = entityManager.unwrap(Session.class);
		Query<StudentDetails> query1 = currentSession.createQuery("from StudentDetails where password=:password and username=:username", StudentDetails.class);
		query1.setParameter("password", encryptedPresentPassword);
		query1.setParameter("username", username);
		StudentDetails studentDetails = query1.uniqueResult();
		if(studentDetails == null)
		{
			theModel.addAttribute("wrongPassword", "wrong present password");
			theModel.addAttribute("presentPassword", presentPassword);
			theModel.addAttribute("newPassword", newPassword);
		}
		else
		{
			String encryptedNewPassword = ep.encrypt(newPassword);
			studentDetails.setPassword(encryptedNewPassword);
			currentSession.update(studentDetails);
			theModel.addAttribute("changedPassword", "New password set up");
		}
		
		return "StudentUpdateDetails";
	}
	
	@RequestMapping("/studentIssueHistory")
	@Transactional
	public String studentIssueHistory(Model theModel)
	{
		HttpSession session = request.getSession();
		String username= (String) session.getAttribute("studentUsername");
		
		Session currentSession = entityManager.unwrap(Session.class);
		Query<IssueBookHistory2> query = currentSession.createQuery("from IssueBookHistory2 where username=:username", IssueBookHistory2.class);
		query.setParameter("username", username);
		List<IssueBookHistory2> studentIssueBookHistory = query.list();
		theModel.addAttribute("studentIssueBookHistory", studentIssueBookHistory);
		
		if(studentIssueBookHistory.isEmpty())
			theModel.addAttribute("emptyIssueBookHistory", "Student has 0 book issues");
		
		return "StudentIssueHistory";
	}
	
	@RequestMapping("/studentFeedback")
	@Transactional
	public String studentFeedback(Model theModel)
	{
		HttpSession session = request.getSession();
		String username = (String) session.getAttribute("studentUsername");
		
		Session currentSession = entityManager.unwrap(Session.class);
		StudentDetails studentDetails = currentSession.get(StudentDetails.class, username);
		String name = studentDetails.getFirstname()+" "+studentDetails.getLastname();
		theModel.addAttribute("username", username);
		theModel.addAttribute("name", name);

		return "StudentFeedback";
	}
	
	@PostMapping("/storeStudentFeedback")
	@Transactional
	public String storeStudentFeedback(Model theModel)
	{
		String username = request.getParameter("username");
		String message = request.getParameter("message");
	
		Session currentSession = entityManager.unwrap(Session.class);
		StudentDetails theStudentDetails = currentSession.get(StudentDetails.class, username);
		Query<Feedback> query1 = currentSession.createQuery("from Feedback where studentDetails=:studentDetails", Feedback.class);
		query1.setParameter("studentDetails", theStudentDetails);
		Feedback theFeedback = query1.uniqueResult();
		if(theFeedback == null)
		{
			Feedback feedback = new Feedback(theStudentDetails, message);
			currentSession.save(feedback);
		}
		else
		{
			theFeedback.setMessage(message);
			currentSession.update(theFeedback);
		}
			
		theModel.addAttribute("feedbackSubmitted", "Feedback submitted");
		
		StudentDetails studentDetails = currentSession.get(StudentDetails.class, username);
		String name = studentDetails.getFirstname()+" "+studentDetails.getLastname();
		theModel.addAttribute("username", username);
		theModel.addAttribute("name", name);

		return "StudentFeedback";
	}
	
	@PostMapping("/searchForm")
	@Transactional
	public String searchForm()
	{
		String val = request.getParameter("searchItem");
		System.out.println("Requested Site : "+val);
		if(val.isEmpty())
			return "main";
		Session currentSession = entityManager.unwrap(Session.class);
		@SuppressWarnings("rawtypes")
		NativeQuery query = currentSession.createSQLQuery("select address from search_bar where link=:val");
		query.setParameter("val", val);
		String address = (String) query.uniqueResult();
		if(address.isEmpty())
			return "main";
		else
			return address;
	}
	
	@PreDestroy
	public void closeEntityManager()
	{
		entityManager.close();
	}

}
