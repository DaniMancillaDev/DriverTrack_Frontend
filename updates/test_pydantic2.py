from datetime import date
from pydantic import BaseModel
from typing import Optional

class MaintenanceUpdate(BaseModel):
    date_field: Optional[date] = None
    date: Optional[date] = None

m = MaintenanceUpdate(**{"date_field": "2026-03-25", "date": "2026-03-25"})
print("Success:", m)
