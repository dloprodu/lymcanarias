<%@ WebHandler Language="C#" Class="contact" %>

using System;
using System.Web;
using System.Net.Mail;

public class contact : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "application/json; charset=utf-8";

        string name = context.Request.Form["name"];
        string phone = context.Request.Form["phone"];
        string from = context.Request.Form["mail"];
        string coment = context.Request.Form["comment"];

        if (string.IsNullOrEmpty(name))
        {
            context.Response.Write("{ \"info\" : \"error\", \"msg\" : \"Por favor introduzca su nombre.\" }");
            return;
        }

        if (!IsValidEmail(from))
        {
            context.Response.Write("{ \"info\" : \"error\", \"msg\" : \"Por favor introduzca un e-mail válido.\" }");
            return;
        }

        if (string.IsNullOrEmpty(coment))
        {
            context.Response.Write("{ \"info\" : \"error\", \"msg\" : \"Por favor indíquenos en que le podemos ayudar.\" }");
            return;
        }

        try
        {
            SmtpClient smtpClient = new SmtpClient
            {
                Host = "smtp.gmail.com",
                Port = 587, //465 587 25
                EnableSsl = true,
                Timeout = 10000,
                DeliveryMethod = SmtpDeliveryMethod.Network,
                UseDefaultCredentials = false,
                Credentials = new System.Net.NetworkCredential("lymcanarias@gmail.com", "empresa2017")
            };

            MailMessage mail = new MailMessage();
            mail.IsBodyHtml = true;

            //Setting From , To and CC
            mail.From = new MailAddress(from, name);
            mail.To.Add(new MailAddress("lymcanarias@gmail.com"));
            //mail.CC.Add(new MailAddress("dloprodu@gmail.com"));
            mail.Subject = "LYM Canarias WEB: " + name;
            mail.Body = GetMailContent(name, from, phone, "LYM Canarias Web", coment);

            smtpClient.Send(mail);

            context.Response.Write("{ \"info\" : \"success\", \"msg\" : \"Su mensaje se ha enviado. Gracias por contactar con nostros!\" }");
        }
        catch (Exception e)
        {
            context.Response.Write("{ \"info\" : \"error\", \"msg\" : \"Lo sentimos, su mensaje no se ha podido enviar. Intentelo de nuevo pasado unos minutos.\" }");
        }
    }

    public bool IsValidEmail(string email)
    {
        if (string.IsNullOrEmpty(email))
        {
            return false;
        }

        try {
            var addr = new System.Net.Mail.MailAddress(email);
            return (addr.Address == email);
        }
        catch {
            return false;
        }
    }

    public string GetMailContent(string name, string mail, string phone, string subject, string coment)
    {
        return @"
		<html>
		<head>
			<title>Mail from " + name + @"</title>
		</head>
		<body>
			<table style=""width: 500px; font-family: arial; font-size: 14px;"" border=""1"">
			<tr style=""height: 32px;"">
				<th align=""right"" style=""width:150px; padding-right: 5px;"">Name:</th>
				<td align=""left"" style=""padding-left:5px; line-height: 20px;"">" + name + @"</td>
			</tr>
			<tr style=""height: 32px;"">
				<th align=""right"" style=""width:150px; padding-right:5px;"">E-mail:</th>
				<td align=""left"" style=""padding-left:5px; line-height: 20px;"">" + mail + @"</td>
			</tr>
			<tr style=""height: 32px;"">
				<th align=""right"" style=""width:150px; padding-right:5px;"">Teléfono:</th>
				<td align=""left"" style=""padding-left:5px; line-height: 20px;"">" + phone + @"</td>
			</tr>
			<tr style=""height: 32px;"">
				<th align=""right"" style=""width:150px; padding-right:5px;"">Tema:</th>
				<td align=""left"" style=""padding-left:5px; line-height: 20px;"">" + subject + @"</td>
			</tr>
			<tr style=""height: 32px;"">
				<th align=""right"" style=""width:150px; padding-right:5px;"">Comentario:</th>
				<td align=""left"" style=""padding-left:5px; line-height: 20px;"">" + coment + @"</td>
			</tr>
			</table>
		</body>
		</html>
		";
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}