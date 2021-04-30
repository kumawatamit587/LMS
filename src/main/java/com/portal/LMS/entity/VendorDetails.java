package com.portal.LMS.entity;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name="vendor_details")
public class VendorDetails {
	
	@Id
	@Column(name="vendor_id")
	private int vendorid;
	
	@Column(name="firstname")
	private String firstname;
	
	@Column(name="lastname")
	private String lastname;

	@Column(name="email")
	private String email;
	
	@Column(name="contact")
	private String contact;
	
	@OneToMany(mappedBy = "vendorDetails" , cascade = {CascadeType.PERSIST, CascadeType.MERGE, CascadeType.DETACH, CascadeType.REFRESH})
	List<BookList> bookList;
	
	public VendorDetails()
	{
	}

	public VendorDetails(String firstname, String lastname, String email, String contact) {
		super();
		this.firstname = firstname;
		this.lastname = lastname;
		this.email = email;
		this.contact = contact;
	}

	public int getVendorid() {
		return vendorid;
	}

	public void setVendorid(int vendorid) {
		this.vendorid = vendorid;
	}

	public String getFirstname() {
		return firstname;
	}

	public void setFirstname(String firstname) {
		this.firstname = firstname;
	}

	public String getLastname() {
		return lastname;
	}

	public void setLastname(String lastname) {
		this.lastname = lastname;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getContact() {
		return contact;
	}

	public void setContact(String contact) {
		this.contact = contact;
	}

	public List<BookList> getBookList() {
		return bookList;
	}

	public void setBookList(List<BookList> bookList) {
		this.bookList = bookList;
	}
	
	public void add(BookList newBook) 
	{
			
		if (bookList == null) 
		{
			bookList = new ArrayList<>();
		}
		
		bookList.add(newBook);
		
		newBook.setVendorDetails(this);
	}

}
