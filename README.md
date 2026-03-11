# Museum-system
This is a web based museum system that includes stored procedure, trigger, events, and etc. 

```
avaritia/
│
├── admin/                      # Admin panel
│   ├── index.php               # Admin dashboard
│   ├── artifacts.php           # CRUD for artifacts
│   ├── auctions.php            # Auction management
│   ├── users.php               # User management
│   ├── reports.php             # Sales reports
│   ├── flagged.php             # Forgery/flag management
│   └── audit.php               # Audit log viewer
│
├── assets/                     # Static files
│   ├── css/
│   │   └── style.css
│   ├── js/
│   │   └── main.js
│   └── images/
│       └── ORACLE_sigil.png
│
├── includes/                   # Shared backend components
│   ├── db.php                  # PDO database connection
│   ├── auth.php                # Authentication/session helpers
│   ├── header.php              # Shared HTML header
│   └── footer.php              # Shared HTML footer
│
├── sql/                        # Database setup
│   ├── create_database.sql
│   ├── seed_data.sql
│   ├── functions.sql
│   ├── procedures.sql
│   ├── triggers.sql
│   └── events.sql
│
├── index.php                   # Landing page
├── about.html
├── catalog.php
├── artifact.php
├── auction.php
├── register.php
├── login.php
├── logout.php
├── dashboard.php
├── my-bids.php
├── my-wins.php
└── profile.php
```
