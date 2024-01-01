from firebase_admin import auth

def logout(email):
    try:
        user = auth.get_user_by_email(email)
        auth.revoke_refresh_tokens(user.uid)
        return {"success": True, "message": "Logout realizado com sucesso."}
    except Exception as e:
        return {"success": False, "message": str(e)}
