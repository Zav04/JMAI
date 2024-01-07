from pydantic import BaseModel
from typing import Optional

class UserSignup(BaseModel):
    hashed_id: str
    data: str