import datetime
from pydantic import BaseModel
from typing import Optional

class MaintenanceUpdate(BaseModel):
    date: datetime.date | None = None
    date2: Optional[datetime.date] = None

m = MaintenanceUpdate(**{"date": "2026-03-25", "date2": "2026-03-25"})
print("Success:", m)
