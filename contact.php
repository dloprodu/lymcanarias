<?php 

	/* ==========================  Define variables ========================== */

	#Your e-mail address
	define("__TO__", "besimdauti24@gmail.com");

	#Message subject
	define("__SUBJECT__", "Lyncanarias WEB - Consulta de usuario");

	#Success message
	define('__SUCCESS_MESSAGE__', "Su mensaje se ha enviado. Gracias por contactar con nostros!");

	#Error message 
	define('__ERROR_MESSAGE__', "Lo sentimos, su mensaje no se ha podido enviar. Intentelo de nuevo pasado unos minutos.");

	#Messege when one or more fields are empty
	define('__MESSAGE_EMPTY_FILDS__', "Por favor, rellene todos los campos");

	/* ========================  End Define variables ======================== */

	//Send mail function
	function send_mail($to,$subject,$message,$headers){
		if(@mail($to,$subject,$message,$headers)){
			echo json_encode(array('info' => 'success', 'msg' => __SUCCESS_MESSAGE__));
		} else {
			echo json_encode(array('info' => 'error', 'msg' => __ERROR_MESSAGE__));
		}
	}

	//Check e-mail validation
	function check_email($email){
		if(!@eregi("^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$", $email)){
			return false;
		} else {
			return true;
		}
	}

	//Get post data
	if(isset($_POST['name']) and isset($_POST['mail']) and isset($_POST['comment'])){
		$name 	 = $_POST['name'];
		$mail 	 = $_POST['mail'];
		$website = $_POST['website'];
		$comment = $_POST['comment'];

		if($name == '') {
			echo json_encode(array('info' => 'error', 'msg' => "Por favor introduzca su nombre."));
			exit();
		} else if($mail == '' or check_email($mail) == false){
			echo json_encode(array('info' => 'error', 'msg' => "Por favor introduzca un e-mail válido."));
			exit();
		} else if($comment == ''){
			echo json_encode(array('info' => 'error', 'msg' => "Por favor introduzca un mensaje."));
			exit();
		} else {
			//Send Mail
			$to = __TO__;
			$subject = __SUBJECT__ . ' ' . $name;
			$message = '
			<html>
			<head>
			  <title>Mail from '. $name .'</title>
			</head>
			<body>
			  <table style="width: 500px; font-family: arial; font-size: 14px;" border="1">
				<tr style="height: 32px;">
				  <th align="right" style="width:150px; padding-right:5px;">Name:</th>
				  <td align="left" style="padding-left:5px; line-height: 20px;">'. $name .'</td>
				</tr>
				<tr style="height: 32px;">
				  <th align="right" style="width:150px; padding-right:5px;">E-mail:</th>
				  <td align="left" style="padding-left:5px; line-height: 20px;">'. $mail .'</td>
				</tr>
				<tr style="height: 32px;">
				  <th align="right" style="width:150px; padding-right:5px;">subject:</th>
				  <td align="left" style="padding-left:5px; line-height: 20px;">'. $subject .'</td>
				</tr>
				<tr style="height: 32px;">
				  <th align="right" style="width:150px; padding-right:5px;">Comment:</th>
				  <td align="left" style="padding-left:5px; line-height: 20px;">'. $comment .'</td>
				</tr>
			  </table>
			</body>
			</html>
			';

			$headers  = 'MIME-Version: 1.0' . "\r\n";
			$headers .= 'Content-type: text/html; charset=utf-8' . "\r\n";
			$headers .= 'From: ' . $mail . "\r\n";

			send_mail($to,$subject,$message,$headers);
		}
	} else {
		echo json_encode(array('info' => 'error', 'msg' => __MESSAGE_EMPTY_FILDS__));
	}
 ?>