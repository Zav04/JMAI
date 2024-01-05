import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import os

def enviarEmailRequerimentoAceite(receiver_email):
    sender_email = os.getenv('EMAIL_SENDER')
    password = os.getenv('EMAIL_PASSWORD')

    message = MIMEMultipart("alternative")
    message["Subject"] = "JMAI - Requerimento Aceite"
    message["From"] = sender_email
    message["To"] = receiver_email

    html = """\
    <html>
    <head>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            line-height: 1.6;
        }
        .container {
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 7px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .header {
            background: #009688;
            color: #ffffff;
            padding: 10px 0;
            text-align: center;
            border-radius: 7px 7px 0 0;
        }
        .content {
            padding: 20px;
            text-align: center;
        }
        .footer {
            text-align: center;
            padding: 10px 0;
            color: #aaa;
        }
    </style>
    </head>
    <body>
    <div class="container">
        <div class="header">
            <h2>Requerimento Aceite</h2>
        </div>
        <div class="content">
            <p>Caro(a),</p>
            <p>É com satisfação que informamos que o seu requerimento foi aceite e encontra-se agora em fase de <strong>Pré-Avaliação</strong>.</p>
            <p>Procederemos com as etapas necessárias e entraremos em contacto consigo com mais informações brevemente.</p>
            <p>Obrigado por preferir os nossos serviços!</p>
        </div>
        <div class="footer">
            <p>Com os melhores cumprimentos,</p>
            <p>JMAI</p>
        </div>
    </div>
    </body>
    </html>

    """
    part2 = MIMEText(html, "html")
    message.attach(part2)

    # Enviar o e-mail
    with smtplib.SMTP_SSL('smtp.gmail.com', 465) as server:
        server.login(sender_email, password)
        server.sendmail(sender_email, receiver_email, message.as_string())
        server.quit()
        

def enviarEmailRequerimentoRecusado(receiver_email):
    sender_email = os.getenv('EMAIL_SENDER')
    password = os.getenv('EMAIL_PASSWORD')

    message = MIMEMultipart("alternative")
    message["Subject"] = "JMAI - Requerimento Recusado"
    message["From"] = sender_email
    message["To"] = receiver_email

    # Escreva o texto e/ou HTML do seu e-mail aqui
    html = """\
    <html>
    <head>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            line-height: 1.6;
        }
        .container {
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 7px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .header {
            background: #009688;
            color: #ffffff;
            padding: 10px 0;
            text-align: center;
            border-radius: 7px 7px 0 0;
        }
        .content {
            padding: 20px;
            text-align: center;
        }
        .footer {
            text-align: center;
            padding: 10px 0;
            color: #aaa;
        }
    </style>
    </head>
    <body>
<div class="container">
    <div class="header">
        <h2>Requerimento Recusado</h2>
    </div>
    <div class="content">
        <p>Caro(a),</p>
        <p>Após uma análise cuidadosa, lamentamos informar que o seu requerimento não pôde ser aceite. Esta decisão foi tomada com base em critérios específicos e rigorosos que regem os nossos procedimentos.</p>
        <p>Entendemos que esta notícia possa ser dececionante, e estamos disponíveis para esclarecer quaisquer dúvidas ou fornecer mais informações sobre os motivos desta decisão. Encorajamos a submissão de um novo requerimento no futuro, caso assim o deseje.</p>
        <p>Agradecemos a sua compreensão e interesse nos nossos serviços.</p>
    </div>
    <div class="footer">
        <p>Com os melhores cumprimentos,</p>
        <p>JMAI</p>
    </div>
</div>
    </body>
    </html>

    """

    part2 = MIMEText(html, "html")
    message.attach(part2)

    # Enviar o e-mail
    with smtplib.SMTP_SSL('smtp.gmail.com', 465) as server:
        server.login(sender_email, password)
        server.sendmail(sender_email, receiver_email, message.as_string())
        server.quit()
        
        

def enviarEmailPreAvaliação(receiver_email, grau_incapacidade):
    sender_email = os.getenv('EMAIL_SENDER')
    password = os.getenv('EMAIL_PASSWORD')

    message = MIMEMultipart("alternative")
    message["Subject"] = "JMAI - Requerimento Aceite"
    message["From"] = sender_email
    message["To"] = receiver_email


    html = """\
    <html>
    <head>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            line-height: 1.6;
        }
        .container {
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 7px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .header {
            background: #009688;
            color: #ffffff;
            padding: 10px 0;
            text-align: center;
            border-radius: 7px 7px 0 0;
        }
        .content {
            padding: 20px;
            text-align: center;
        }
        .footer {
            text-align: center;
            padding: 10px 0;
            color: #aaa;
        }
    </style>
    </head>
    <body>
    <div class="container">
    <div class="header">
        <h2>Requerimento Aceite</h2>
    </div>
    <div class="content">
        <p>Caro(a),</p>
        <p>É com satisfação que informamos que o seu requerimento foi aceite e encontra-se agora em fase de <strong>Pré-Avaliação</strong>.</p>
        <p>O valor simulado do grau de incapacidade é: <strong>${grau_incapacidade}%</strong>.</p>
        <p>Caso deseje submeter-se a uma junta médica presencial, solicitamos que aceda à nossa plataforma e siga os passos subsequentes para agendamento. Se preferir, pode também optar por continuar o processo de forma digital.</p>
        <p>Obrigado por preferir os nossos serviços!</p>
    </div>
    <div class="footer">
        <p>Com os melhores cumprimentos,</p>
        <p>JMAI</p>
    </div>
    </div>
    </body>
    </html>
    """

    html = html.replace('${grau_incapacidade}', grau_incapacidade);
    part2 = MIMEText(html, "html")
    message.attach(part2)

    with smtplib.SMTP_SSL('smtp.gmail.com', 465) as server:
        server.login(sender_email, password)
        server.sendmail(sender_email, receiver_email, message.as_string())
        server.quit()