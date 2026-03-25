# SmartFab Material Tracker

Flutter-based smart manufacturing app for material tracking, operator usage logging, and costing/report visibility with role-based access.

## Project Summary
SmartFab Material Tracker is designed for factory-style workflows where admins manage inventory/process data and operators log material usage through barcode input. The application is built with an offline-first local architecture and includes costing insights for decision support.

## Problem Statement Coverage (3 Implemented Solutions)
1. Role-based login using hardcoded credentials (Admin and Operator).
2. Material scan/log flow with automatic stock reduction and costing support.
3. Offline data persistence with report generation and sync-center visibility.

## Roles and Credentials
1. Admin
- Username: admin
- Password: admin123

2. Operator
- Username: operator
- Password: operator123

## Key Features
1. Authentication and role routing
- Local username/password login
- Automatic redirection to Admin or Operator dashboard

2. Admin capabilities
- Dashboard overview
- Materials management (add/update/delete)
- Processes management
- Users listing
- Inventory history view
- Cost reports with CSV/PDF generation
- Sync center status screen

3. Operator capabilities
- Dashboard overview
- Scan and log material usage
- Assigned tasks and completion toggle

4. Costing and reporting
- Raw material cost
- Processing cost
- Manufacturing cost
- Suggested selling price

5. Offline-first behavior
- Local persistence using Hive
- App data retained across restarts

## Tech Stack
- Flutter (Dart)
- Provider (state management)
- Hive / Hive Flutter (local storage)
- mobile_scanner (barcode/QR scanning)
- csv, pdf (report generation)
- intl, uuid, path_provider (utility packages)

## Project Structure
```text
lib/
	core/
		constants/
		theme/
		utils/
	models/
	providers/
	services/
	screens/
		auth/
		home/
		admin/
		operator/
	widgets/
```

## How to Run
1. Install Flutter SDK and Android Studio (or equivalent toolchain).
2. Connect emulator/device.
3. In project root, run:

```bash
flutter pub get
flutter run
```

## Demo Operation Flow (Faculty Friendly)
1. Login as Admin and show dashboard.
2. Add a material from Materials screen.
3. Logout and login as Operator.
4. Open Scan & Log and log usage for barcode STL-1001.
5. Logout and login as Admin.
6. Show Inventory History and Reports updated values.
7. Restart app and show persisted data.

## Sample Scan & Log Input
- Barcode: STL-1001
- Quantity Used: 10
- Additional Processing Cost: 50
- Desired Margin: 20

Expected result:
- Usage log added
- Stock reduced
- Report values updated

## Testing and Quality
Run quality checks:

```bash
flutter analyze
flutter test
```

## Current Limitations
1. Authentication is local and hardcoded for demo use.
2. Cloud sync is currently offline/local-mode only.
3. Reporting export is generated in-app (can be extended for file sharing workflows).

## Future Improvements
1. Secure identity management and password recovery.
2. Production-grade cloud sync with conflict resolution.
3. Advanced analytics and chart dashboards.
4. Multi-plant workflow and approvals.
5. CI/CD and higher automated test coverage.

## Documentation File
For academic submission content, see:
- [23IT098_ProblemStatement4.md](23IT098_ProblemStatement4.md)

## License
This project is intended for educational use.
