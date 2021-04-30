package com.portal.LMS.entity;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name="book_details")
public class BookDetails {
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	@Column(name="bookid")
	private int bookid;
	
	@Column(name="bookname")
	private String bookname;
	
	@Column(name="author")
	public String author;
	
	@Column(name="pages")
	private int pages;
	
	@Column(name="publisher")
	private String publisher;
	
	@Column(name="genre")
	private String genre;
	
	@Column(name="totalcopies")
	private int totalcopies;
	
	@Column(name="copies")
	private int copies;

	@OneToMany(mappedBy="bookDetails", cascade=CascadeType.ALL)
	public List<BookList> bookList;
	
	@OneToMany(mappedBy="bookList", cascade=CascadeType.ALL)
	List<IssueBookHistory> issueBookHistory;
	
	public BookDetails()
	{
	}

	public BookDetails(String bookname, String author, int pages, String publisher, String genre, int totalcopies, int copies) {
		super();
		this.bookname = bookname;
		this.author = author;
		this.pages = pages;
		this.publisher = publisher;
		this.genre = genre;
		this.totalcopies = totalcopies;
		this.copies = copies;
	}

	public int getBookid() {
		return bookid;
	}

	public void setBookid(int bookid) {
		this.bookid = bookid;
	}

	public String getBookname() {
		return bookname;
	}

	public void setBookname(String bookname) {
		this.bookname = bookname;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public int getPages() {
		return pages;
	}

	public void setPages(int pages) {
		this.pages = pages;
	}

	public String getPublisher() {
		return publisher;
	}

	public void setPublisher(String publisher) {
		this.publisher = publisher;
	}

	public String getGenre() {
		return genre;
	}

	public void setGenre(String genre) {
		this.genre = genre;
	}

	public int getTotalcopies() {
		return totalcopies;
	}

	public void setTotalcopies(int totalcopies) {
		this.totalcopies = totalcopies;
	}
	
	public int getCopies() {
		return copies;
	}

	public void setCopies(int copies) {
		this.copies = copies;
	}

	public List<BookList> getBookList() {
		return bookList;
	}

	public void setBookList(List<BookList> bookList) {
		this.bookList = bookList;
	}
	
	public List<IssueBookHistory> getIssueBookHistory() {
		return issueBookHistory;
	}

	public void setIssueBookHistory(List<IssueBookHistory> issueBookHistory) {
		this.issueBookHistory = issueBookHistory;
	}

	public void add(BookList newBook) 
	{
			
		if (bookList == null) 
		{
			bookList = new ArrayList<>();
		}
		
		bookList.add(newBook);
		
		newBook.setBookDetails(this);
	}
	
	
}
