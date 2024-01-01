from pydantic import BaseModel
from typing import Optional

class Search(BaseModel):
    hashed_id: Optional[str]