from pydantic import BaseModel
from typing import Optional

class SendEmail(BaseModel):
    email: str