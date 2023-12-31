from pydantic import BaseModel
from typing import Optional

class UserSignup(BaseModel):
    email: Optional[str] = ''
    password: Optional[str] = ''