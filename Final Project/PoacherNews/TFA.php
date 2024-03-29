<?php
    include 'util/loginCheck.php';
?>

<!DOCTYPE html>
<html>
<head>
    <?php include 'includes/globalHead.html' ?>
    <link rel="stylesheet" href="/res/css/settings.css">
    
    <title>Login</title>
    <style>
        .accountContainer {
            max-width: 450px;
            border: solid 2px #83A8F0;
            border-radius: 20px 0px;
            padding: 10px;
            margin: 8% auto 8% auto;
        }

        .accountContainer h1 {
            border-bottom: 1px solid #83A8F0;
        }

        .formFields {
            margin: 0px 25px 0px 25px;
            display: grid;
            grid-template-columns: 1fr;
            grid-row-gap: 5px;
        }

        .formFields a {
            text-align: center;
            margin-bottom: 10px;
        }

        .formFields input {
            line-height: 25px;
            font-size: 15px;
            padding: 5px;
            border: 1px solid grey;
            border-radius: 15px;
        }

        .errorMessage {
            margin: 5px 0px 5px 0px;
            padding: 10px;
            border-radius: 2px;
            font-weight: bold;
            box-shadow: 0 0 0 1px #e0b4b4 inset;
            background-color: #fff6f6;
            color: #9f3a38;
        }

        #verifySubmitButton {
            background: #83A8F0;
            color: white;
            border-radius: 100px;
            cursor: pointer;
            font-size: 14px;
            min-width: 250px;
            line-height: 15px;
            padding: 6px 16px;
            position: relative;
            text-align: center;
            white-space: nowrap;
            margin: 10px;
        }
        #verifySubmitButton:hover {
            border: 1px solid #1864F7;
            opacity: 0.75;
        }
    </style>
</head>
<body>
    <?php
        // Redirect unregisterd users or users with two-factor authentication disabled to index.php
        if(empty($_SESSION['loggedin']) || $_SESSION['tfastatus'] == 0) {
            echo '<meta http-equiv="refresh" content="0; url=/index.php">';
            exit;
        }
		// Store TFA.php in $_SESSION['tfaURL']
		// Used to destroy session if user does not successfully enter two-factor authentication / recovery code
		else if(!empty($_SESSION['loggedin'])) {
            $_SESSION['tfaURL'] = basename($_SERVER['PHP_SELF']);
        }
        // Redirect users who have successfully logged in through TFA.php to index.php
        // $_SESSION['enabledTFACheck'] set upon successful login through TFA.php (util/settingsHandler.php line 214)	
        if(!empty($_SESSION['enabledTFACheck'])) {
			// Unset $_SESSION['tfaURL'] to prevent logged in users from setting it again by manually accessing TFA.php
			unset($_SESSION['tfaURL']);
            echo '<meta http-equiv="refresh" content="0; url=/index.php">';
            exit;
        }
 
    	include 'includes/header.php';
        include 'includes/nav.php';
    ?>
    
    <div id="mainContent">
        <form id="TFACode" class="accountContainer">
            <input type="hidden" name="action" value="TFACode"/>
            <h1>Two-Factor Authentication</h1>
            <span class="subheader">Enter your authenticator code to login</span>
            <div class="formFields">
            <br>
                <input id="ACode" type="text" name="ACode" placeholder="Authentication Code">
                <input id="verifySubmitButton" type="submit" name="submit" value="Submit">
                <a id="recoveryCode" href="recoveryCode.php">Recovery Code</a>
            </div>
			
            <div id="errorMessage" class="settingsMessage"></div>
        </form>
        
        <script>
        	$("#TFACode").submit(function(event) {
        		$("#errorMessage").hide();
        		$("#errorMessage").text('');
				$("#errorMessage").removeClass("error");
        		event.preventDefault();
        		$.post("util/settingsHandler.php", $(this).serialize(), function(data) {
            		if(data != "Success") {
                		$("#errorMessage").addClass("error");
                		$("#errorMessage").text(data);
                		$("#errorMessage").fadeIn();                
            		} else {
                		$("#ACode").hide();
                		$("#recoveryCode").hide();				
						$("#verifySubmitButton").hide();
                		$("#errorMessage").addClass("success");
                		$("#errorMessage").text("Authentication success. You will be redirected momentarily..");
                		$("#errorMessage").fadeIn();
						
						// Redirect (set in milliseconds)
						window.setTimeout(function() {
							window.location.href = 'index.php';
						}, 3000);
            		}
				});
    		});
        </script>        
    </div>
    <?php include('includes/footer.html'); ?>
</body>
</html>
