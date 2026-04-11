import re

# 1. Update app/models/user.py
with open('../DriveTrack/app/models/user.py', 'r') as f:
    content = f.read()

if 'password_changed_at' not in content:
    content = content.replace(
        'created_at: Mapped[datetime] = mapped_column(',
        'password_changed_at: Mapped[Optional[datetime]] = mapped_column(nullable=True, default=None)\n    created_at: Mapped[datetime] = mapped_column('
    )
    with open('../DriveTrack/app/models/user.py', 'w') as f:
        f.write(content)


# 2. Update app/schemas/user.py
with open('../DriveTrack/app/schemas/user.py', 'r') as f:
    content = f.read()

if 'password_changed_at' not in content:
    content = content.replace(
        'created_at: datetime',
        'created_at: datetime\n    password_changed_at: Optional[datetime] = None'
    )
    with open('../DriveTrack/app/schemas/user.py', 'w') as f:
        f.write(content)

# 3. Update app/services/users.py
with open('../DriveTrack/app/services/users.py', 'r') as f:
    content = f.read()

if 'password_changed_at' not in content:
    content = content.replace(
        'from sqlalchemy.ext.asyncio import AsyncSession',
        'from sqlalchemy.ext.asyncio import AsyncSession\nfrom datetime import datetime, timezone'
    )
    content = content.replace(
        'db_user.hashed_password = get_password_hash(new_password)',
        'db_user.hashed_password = get_password_hash(new_password)\n    db_user.password_changed_at = datetime.now(timezone.utc)'
    )
    with open('../DriveTrack/app/services/users.py', 'w') as f:
        f.write(content)

print("Backend updated.")
