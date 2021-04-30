package com.portal.LMS.entity;

import java.sql.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="issue_book_history2")
public class IssueBookHistory2 {
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	@Column(name="issueid")
	private int issueid;
	
	@Column(name="bookid")
	public int bookid;
	
	@Column(name="barcode")
	int barcode;
	
	@Column(name="bookname")
	String bookname;
	
	@Column(name="username")
	String username;
	
	@Column(name="studentname")
	String studentname;
	
	@Column(name="issuedate")
	private Date issuedate;
	
	@Column(name="returndate")
	private Date returndate;
	
	@Column(name="totaldays")
	private int totaldays;
	
	public IssueBookHistory2()
	{
	}

	public IssueBookHistory2(int bookid, int barcode, String bookname, String username, String studentname, Date issuedate, Date returndate, int totaldays) {
		this.bookid = bookid;
		this.barcode = barcode;
		this.bookname = bookname;
		this.username = username;
		this.studentname = studentname;
		this.issuedate = issuedate;
		this.returndate = returndate;
		this.totaldays = totaldays;
	}

	public int getIssueid() {
		return issueid;
	}

	public void setIssueid(int issueid) {
		this.issueid = issueid;
	}

	public int getBookid() {
		return bookid;
	}

	public void setBookid(int bookid) {
		this.bookid = bookid;
	}

	public int getBarcode() {
		return barcode;
	}

	public void setBarcode(int barcode) {
		this.barcode = barcode;
	}

	public String getBookname() {
		return bookname;
	}

	public void setBookname(String bookname) {
		this.bookname = bookname;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getStudentname() {
		return studentname;
	}

	public void setStudentname(String studentname) {
		this.studentname = studentname;
	}

	public Date getIssuedate() {
		return issuedate;
	}

	public void setIssuedate(Date issuedate) {
		this.issuedate = issuedate;
	}

	public Date getReturndate() {
		return returndate;
	}

	public void setReturndate(Date returndate) {
		this.returndate = returndate;
	}

	public int getTotaldays() {
		return totaldays;
	}

	public void setTotaldays(int totaldays) {
		this.totaldays = totaldays;
	}
	
	
}
