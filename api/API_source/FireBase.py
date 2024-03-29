
from dotenv import load_dotenv
import os
import pyrebase

load_dotenv()

apiKey= os.getenv('FIRE_APIKEY')
authDomain= os.getenv('FIRE_AUTHDOMAIN')
databaseURL = os.getenv('FIRE_DATABASE_URL')
projectId= os.getenv('FIRE_PROJECTID')
storageBucket= os.getenv('FIRE_STORAGEBUCKET')
messagingSenderId= os.getenv('FIRE_MESSAGINGSENDERID'),
appId= os.getenv('FIRE_APPID'),
measurementId= os.getenv('FIRE_MEASUREMENTID')


firebaseConfig = {
    'apiKey': apiKey,
    'authDomain': authDomain,
    'databaseURL' :databaseURL,
    'projectId': projectId,
    'storageBucket': storageBucket,
    'messagingSenderId': messagingSenderId,
    'appId': appId,
    'measurementId': measurementId
}

firebase =pyrebase.initialize_app(firebaseConfig)
auth_manual = firebase.auth()


def login(email, password):
    try:
        login= auth_manual.sign_in_with_email_and_password(email,password)
        return login
    except:
        return 'Credenciais Invalidas'


def singup(email, password):
    try:
        auth_manual.create_user_with_email_and_password(email, password)
        return True
    except:
        return 'Email ja esta registado'


def resetpassword(email):
    try:
        auth_manual.send_password_reset_email(email)
        return 'Email para nova Password Enviado'
    except:
        return 'Credenciais Invalidas'

