package com.portal.LMS.controller;

import java.security.MessageDigest;

public class EncryptPassword {
	
	public String encrypt(String password) throws Exception
	{
		//Creating the MessageDigest object  
	      MessageDigest md = MessageDigest.getInstance("SHA-256");

	      //Passing data to the created MessageDigest Object
	      md.update(password.getBytes());
	      
	      //Compute the message digest
	      byte[] digest = md.digest();      
	      System.out.println(digest);  
	     
	      //Converting the byte array in to HexString format
	      StringBuffer hexString = new StringBuffer();
	      
	      for (int i = 0;i<digest.length;i++) {
	         hexString.append(Integer.toHexString(0xFF & digest[i]));
	      }
	      
	      return hexString.toString();
	}

}
