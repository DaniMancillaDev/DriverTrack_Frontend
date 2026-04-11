from datetime import date
from decimal import Decimal
from typing import Optional
from pydantic import BaseModel

class MaintenanceUpdate(BaseModel):
    date: Optional[date] = None

m = MaintenanceUpdate(**{"date": "2026-03-25"})
print("Success:", m)
