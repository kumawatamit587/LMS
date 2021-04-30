package com.portal.LMS.controller;

import java.sql.Date;
import java.util.List;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import com.portal.LMS.entity.IssueBookHistory;

public class SendMessage {
	
	@SuppressWarnings("finally")
	public String sendIssueMessage(int barcode, String bookname, String email, Date issueDate, int totalDays)
	{
    	System.out.println("Sending Mail Message......... : "+email);
		String result="";
	    final String subject ="Central Institute Library Book Reminder";
	    String messg="You have issued the book <strong>"+bookname+" (barcode: "+barcode+")</strong> on "+issueDate+" from the Central Institute Library. Don't forget to return the book within 7 days otherwise you will be entilted to pay the late book return fine. Refer to the library rules section on the website for more information.";
		
	    // Sender's email ID and password needs to be mentioned
	    final String from = "CentralInstituteLibrary@gmail.com";
	    final String pass = "cil123321";

	    // Defining the gmail host
	    String host = "smtp.gmail.com";
	    
	    // Creating Properties object
	    Properties props = new Properties();

	    // Defining properties
	    props.put("mail.smtp.host", host);
	    props.put("mail.transport.protocol", "smtp");
	    props.put("mail.smtp.auth", "true");
	    props.put("mail.smtp.starttls.enable", "true");
	    props.put("mail.user", from);
	    props.put("mail.password", pass);
	    props.put("mail.smtp.port", "587"); //443

	    // Authorized the Session object.
	    Session mailSession = Session.getInstance(props, new javax.mail.Authenticator() {

	        @Override
	        protected PasswordAuthentication getPasswordAuthentication() 
	        {
	            return new PasswordAuthentication(from, pass);
	        }

	    });

	    try 
	    {
	        MimeMessage message = new MimeMessage(mailSession);
	        message.setFrom(new InternetAddress(from));
	        message.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
	        message.setSubject(subject);
	        message.setContent(messg, "text/html; charset=utf-8");

	        // Send message
	        Transport.send(message);

	        result = "Notification mail sent.";
	    } 
	    catch (MessagingException mex) 
	    {
	        mex.printStackTrace();
	        result = "Unable to send mail due to network error.";
	    }
	    
	    finally
	    {
	    	System.out.println("Result : "+result);
	    	return result;
	    }
	}
	
	
	public int sendReminderMessage(List<IssueBookHistory> issueBookHistory)
	{
    	System.out.println("Sending Reminder Mail Message.........");
		String result="", subject ="Central Institute Library Book Reminder", messg="";
	    
	 // Sender's email ID and password needs to be mentioned
	    final String from = "CentralInstituteLibrary@gmail.com";
	    final String pass = "cil123321";

	    // Defining the gmail host
	    String host = "smtp.gmail.com";
	    
	    // Creating Properties object
	    Properties props = new Properties();

	    // Defining properties
	    props.put("mail.smtp.host", host);
	    props.put("mail.transport.protocol", "smtp");
	    props.put("mail.smtp.auth", "true");
	    props.put("mail.smtp.starttls.enable", "true");
	    props.put("mail.user", from);
	    props.put("mail.password", pass);
	    props.put("mail.smtp.port", "587"); //443

	    // Authorized the Session object.
	    Session mailSession = Session.getInstance(props, new javax.mail.Authenticator() {

	        @Override
	        protected PasswordAuthentication getPasswordAuthentication() 
	        {
	            return new PasswordAuthentication(from, pass);
	        }

	    });
	    
	    int count=0;
	    for(IssueBookHistory book:issueBookHistory)
	    {
	    	int barcode = book.getBookList().getBarcode();
	    	String bookname = book.getBookDetails().getBookname();
	    	String email = book.getStudentDetails().getEmail();
	    	Date issueDate = book.getIssuedate();
	    	int totalDays = book.getTotaldays();
	    	
	    	if(totalDays==7)
				messg="You have issued the book <strong>"+bookname+" (barcode: "+barcode+")</strong> on "+issueDate+" from the Central Institute Library. It has been "+totalDays+" days. Today is the last day of your book issue period, so you are requested to return back the book by today itself to get away from any fine. From tomorrow onwards, you will be fined for exceeding the maximum number of days of book issue period.";
			else if(totalDays==8)
				messg="You have issued the book <strong>"+bookname+" (barcode: "+barcode+")</strong> on "+issueDate+" from the Central Institute Library. It has been "+totalDays+" days & you have exceeded the time limit of 7 days for book issue. You will be fined from today onwards, so you are requested to return the book as soon as possible to pay minimum fine.";
			else if(totalDays>8)
				messg="You have issued the book <strong>"+bookname+" (barcode: "+barcode+")</strong> on "+issueDate+" from the Central Institute Library. It has been "+totalDays+" days & you have exceeded the time limit of 7 days for book issue. You are requested to return the book as soon as possible to pay minimum fine."; 
	    	
	    	try
	    	{
		    	MimeMessage message = new MimeMessage(mailSession);
		        message.setFrom(new InternetAddress(from));
		        message.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
		        message.setSubject(subject);
		        message.setContent(messg, "text/html; charset=utf-8");
		        System.out.println(barcode+"  "+bookname+"  "+email+"  "+issueDate+"  "+totalDays+"  "+messg);
		        // Send message
		        Transport.send(message);
	
		        result = "Notification mail sent.";
		        count++;
	    	}
	    	
	    	catch (MessagingException mex) 
		    {
		        mex.printStackTrace();
		        result = "Unable to send mail due to network error.";
		    }
		    
		    finally
		    {
		    	System.out.println("Result : "+result);
		    }
	    } 
	    return count;
	}

}
