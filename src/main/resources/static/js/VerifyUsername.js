/**
 *  To verify that user chooses unique username during signup
 */

function verifyAdminUsername()
	{  
		var username=document.getElementById("adminUsername").value; 
		console.log(username);
		var url="VerifyAdminUsername?username="+username;  
		  
		const xhr = new XMLHttpRequest();
		xhr.open('GET', url, true);
		
		xhr.onreadystatechange = function(){
			if(xhr.readyState==4)
			{  
			var val=xhr.responseText;
			if(val=="1")
				{
					document.getElementById('adminUsername').classList.remove("is-invalid");
					document.getElementById('adminUsername').classList.add("is-valid");
					document.getElementById("submitButton").disabled = false;
				}
			else
				{
					document.getElementById('adminUsername').classList.remove("is-valid");
					document.getElementById('adminUsername').classList.add("is-invalid");
					document.getElementById("submitButton").disabled = true;
				}
			}  
		}
		xhr.send();
	}


function verifyStudentUsername()
	{  
		var username=document.getElementById("studentUsername").value; 
		console.log(username);
		var url="VerifyStudentUsername?username="+username;  
		  
		const xhr = new XMLHttpRequest();
		xhr.open('GET', url, true);
		
		xhr.onreadystatechange = function(){
			if(xhr.readyState==4)
			{  
			var val=xhr.responseText;
			if(val=="1")
				{
					document.getElementById('studentUsername').classList.remove("is-invalid");
					document.getElementById('studentUsername').classList.add("is-valid");
					document.getElementById("submitButton").disabled = false;
				}
			else
				{
					document.getElementById('studentUsername').classList.remove("is-valid");
					document.getElementById('studentUsername').classList.add("is-invalid");
					document.getElementById("submitButton").disabled = true;
				}
			}  
		}
		xhr.send();
	}