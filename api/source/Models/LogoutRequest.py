from pydantic import BaseModel

class LogoutRequest(BaseModel):
    email: str