import pyrebase

from dotenv import load_dotenv
import os



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
auth = firebase.auth()



def login(email, password):
    try:
        login= auth.sign_in_with_email_and_password(email,password)
        return login
    except:
        return 'Credenciais Invalidas'


def singup(email, password):
    try:
        auth.create_user_with_email_and_password(email, password)
        return True
    except:
        return 'Email ja esta regisatdo'


def resetpassword(email):
    try:
        auth.send_password_reset_email(email)
        return 'Email para nova Password Enviado'
    except:
        return 'Credenciais Invalidas'

login('bruno.bx04@gmail.com', 'admin.')
