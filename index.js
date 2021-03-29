var newScript = document.createElement('script');
newScript.type = 'text/javascript';
newScript.src = '../SiteAssets/js/jquery.min.js'; // set the source of the script to your script
newScript.onload = function() { 
  $(document).ready(function() {    
	SP.SOD.executeOrDelayUntilEventNotified(addCustomeUserAction, "sp.bodyloaded");
  });
};
var head = document.getElementsByTagName("head")[0];
head.appendChild(newScript);
var link = document.createElement('link');
// set the attributes for link element 
link.rel = 'stylesheet';       
link.type = 'text/css';
link.href = '../SiteAssets/css/style.css'; 
// Append link element to HTML head
head.appendChild(link); 

function addCustomeUserAction() {
	getBannerDetails().then(function(data) {
		var results = data.d.results;		
		var bannerTitle;
		var backgroundColor;
		var status;
		for(var i=0;i<results.length;i++){
			if(results[i].Status === 'Delta'){
			bannerTitle = results[i].Title;
			status = results[i].Status;
			backgroundColor = '#A4262C';
			}
			else{
			bannerTitle = results[i].BannerMessage2;
			status = results[i].Status;
			backgroundColor = '#007D34';
			}
		}
		var a = document.createElement('a');                  
		// Create the text node for anchor element. 
		var link = document.createTextNode(" take me to the link");                  
		// Append the text node to anchor element. 
		a.appendChild(link);                   
		// Set the title. 
		a.title = " take me to the link";                    
		// Set the href property. 
		a.href = "https://www.geeksforgeeks.org";  
		a.id="link";
		// Append the anchor element to the body.                   
		var element = document.createElement("div");
		element.appendChild(document.createTextNode(bannerTitle));
		if(status === 'Live'){
			element.appendChild(a);
		}	
		element.id = 'top';	
		element.style.backgroundColor = backgroundColor;
		var originalElement = document.getElementById('s4-workspace');
		originalElement.insertBefore(element,originalElement.childNodes[0]);
			
		}).catch(function(error) {
			// Error handling code goes here
		})
	}
	
	function getBannerDetails(){
		var deferred = $.Deferred();
		$.ajax({
			url:"/sites/CaptureClicks-Teams/_api/lists/getbytitle('bannerList')/items?$select=Title,BannerMessage2,EnableBanner,Status",
			method:"GET",			
			headers: {
				"accept": "application/json;odata=verbose"				
			},
			success: function (data) {				
				deferred.resolve(data);
			},
			error: function (data) {
				deferred.reject(data);
			}
    });
    return deferred.promise();
	};	

