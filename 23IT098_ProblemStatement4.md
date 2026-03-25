# 23IT098_ProblemStatement4

## PDF Name
StudentID_ProblemStatement4

For your submission, use this filename format:
23IT098_ProblemStatement4.pdf

## Project Title
SmartFab Material Tracker

## Problem Statement 4 Summary
Develop a Flutter-based Smart Manufacturing Material Tracking application with role-based usage, local data persistence, barcode-driven usage logging, and cost/report generation.

## The 3 Solutions Completed
1. Role-Based Login with Hardcoded Credentials
- Implemented local authentication using predefined users and roles.
- Admin credentials: admin / admin123
- Operator credentials: operator / operator123
- Role router directs user to Admin or Operator dashboard after login.

2. Material Tracking + Scan/Log + Costing
- Material inventory management with stock, minimum stock, barcode, and unit cost.
- Operator usage logging through barcode workflow.
- Automatic stock deduction and insufficient-stock handling.
- Costing pipeline includes raw material cost, processing cost, manufacturing cost, and suggested selling price.

3. Reports + Local Persistence + Sync Queue Center (Offline-First)
- Data persistence using Hive for materials, users, processes, tasks, and logs.
- Admin reports support CSV and PDF generation in memory.
- Sync center screen shows pending sync records and last sync time (local/offline mode).
- Low-stock monitoring and inventory history are available for admin visibility.

## Technology Stack
- Flutter (Dart)
- State Management: Provider
- Local Storage: Hive / Hive Flutter
- Barcode Scanner: mobile_scanner
- Reporting: csv, pdf
- Utilities: intl, uuid, path_provider

## Module-Wise Implementation
1. Authentication Module
- Username/password local login
- Role-based access control (Admin, Operator)

2. Admin Module
- Dashboard overview (materials, logs, tasks, low stock)
- Materials CRUD
- Process management
- User listing
- Inventory history
- Report generation (CSV/PDF)
- Sync center view

3. Operator Module
- Operator dashboard
- Scan and log consumption
- Task viewing and completion toggle

4. Data Layer
- AppDataProvider handles business logic and persistence
- CloudSyncService currently configured for offline/local mode

## List of Screen Shots of Each UI Screen
Capture and include all screenshots below in the final PDF.

1. Login Screen
- File: lib/screens/auth/login_screen.dart
- Show: username/password fields and sign-in button

2. Role Router Flow
- File: lib/screens/home/role_router_screen.dart
- Show: redirection behavior (optional transition screenshot)

3. Admin Dashboard
- File: lib/screens/admin/admin_dashboard_screen.dart
- Show: overview cards and quick navigation

4. Materials Screen
- File: lib/screens/admin/materials_screen.dart
- Show: materials list and add/edit/delete actions

5. Processes Screen
- File: lib/screens/admin/processes_screen.dart
- Show: process list and add process dialog

6. Users Screen
- File: lib/screens/admin/users_screen.dart
- Show: users list with roles

7. Inventory History Screen
- File: lib/screens/admin/inventory_history_screen.dart
- Show: usage history/log records

8. Reports Screen
- File: lib/screens/admin/reports_screen.dart
- Show: calculated values and export actions (CSV/PDF)

9. Sync Center Screen
- File: lib/screens/admin/sync_center_screen.dart
- Show: pending sync records and last synced info

10. Operator Dashboard
- File: lib/screens/operator/operator_dashboard_screen.dart
- Show: operator metrics and navigation

11. Scan & Log Screen
- File: lib/screens/operator/scan_log_screen.dart
- Show: barcode/QR input or scan result and log action

12. Tasks Screen
- File: lib/screens/operator/tasks_screen.dart
- Show: assigned tasks and completion toggle

## Suggested Screenshot Naming Convention
Use the format below to keep your PDF organized.
- 01_Login.png
- 02_AdminDashboard.png
- 03_Materials.png
- 04_Processes.png
- 05_Users.png
- 06_InventoryHistory.png
- 07_Reports.png
- 08_SyncCenter.png
- 09_OperatorDashboard.png
- 10_ScanLog.png
- 11_Tasks.png

## Testing and Validation
1. Static Analysis
- flutter analyze passed with no issues.

2. Unit/Widget Testing
- Existing test suite passed.

3. Functional Validation
- Verified login for both hardcoded roles.
- Verified route redirection by role.
- Verified data persistence and dashboard/report behavior.

## Future Implementation
1. Secure Authentication and User Management
- Migrate hardcoded users to managed identity with secure password hashing.
- Add forgot-password, lockout policy, and audit trails.

2. Real Cloud Synchronization
- Re-enable and harden cloud sync with conflict resolution and retry strategy.
- Add background sync with connectivity detection.

3. Production-Grade QR/Barcode Workflow
- Continuous scanner mode with duplicate-scan prevention.
- Batch scan support and camera permission UX improvements.

4. Advanced Analytics and Reporting
- Trend charts for material usage over time.
- Process-wise cost breakdown and forecasted low-stock alerts.
- Export to printable branded reports and downloadable files.

5. Enterprise Features
- Multi-plant and multi-line support.
- Approval workflows for material/process changes.
- Role hierarchy beyond Admin/Operator.

6. Quality and Release Engineering
- Expand test coverage (provider logic, route guards, form validation).
- Add CI checks for format, analyze, and test.
- Add release builds and versioning policy.

## Conclusion
The SmartFab Material Tracker successfully delivers the required core objective of Problem Statement 4 through three implemented solutions: role-based access with hardcoded credentials, operator-centric material scan/log with automated costing, and offline-first reporting/persistence with sync-center visibility. The application is modular, testable, and ready for academic demonstration. With future enhancements in security, cloud sync, and analytics, this prototype can evolve into a production-ready smart manufacturing operations platform.

## Faculty Demo Operation (Step-by-Step)
Use the following exact flow during presentation to prove everything is working.

1. Start Application
- Run flutter pub get (if needed once).
- Run flutter run.
- Show login screen appears successfully.

2. Demonstrate Role-Based Login
- Login as Admin using admin / admin123.
- Show admin dashboard opens.
- Logout.
- Login as Operator using operator / operator123.
- Show operator dashboard opens.

3. Demonstrate Admin Functionalities
- Login again as Admin.
- Open Materials screen and add one new material (barcode, stock, unit cost).
- Open Processes screen and add one process cost.
- Open Users screen and show role-based users list.
- Open Inventory History and show records section.

4. Demonstrate Operator Functionalities
- Logout and login as Operator.
- Open Scan and Log screen.
- Enter or scan material barcode.
- Add quantity used and additional processing cost.
- Submit log and show success message.
- Explain that stock is reduced automatically after logging.

5. Demonstrate Reports and Costing
- Login as Admin.
- Open Reports screen.
- Show raw material cost, manufacturing cost, and suggested selling price.
- Show CSV and PDF generation actions.

6. Demonstrate Offline Persistence
- Close app and run again.
- Show previously added materials and logs are still present.
- Explain that Hive local database stores app data for offline-first behavior.

7. Demonstrate Sync Center Visibility
- Open Sync Center screen.
- Show pending sync and last sync timestamp section (local mode view).

## Viva Explanation Script (What We Have Made)
Use this short script while presenting:

"We built a Flutter application named SmartFab Material Tracker for smart manufacturing operations. The app solves three major requirements. First, role-based login with hardcoded Admin and Operator credentials so access is separated by responsibilities. Second, material tracking through scan or barcode input with automatic stock deduction and cost calculations, including raw material and processing cost. Third, offline-first persistence and report generation where all data is saved locally using Hive, and admin can generate CSV/PDF reports. The architecture is modular using Provider for state management, reusable widgets for UI consistency, and separate screens for admin and operator workflows. This makes the project scalable, easy to maintain, and ready for further enhancements such as secure cloud sync and analytics." 

## Quick Proof Checklist for Faculty
1. Role routing works for both users.
2. Material can be added and listed.
3. Operator log reduces stock.
4. Reports show computed costing values.
5. Data remains after app restart.
6. Analyze and tests pass.

## Submission Checklist
1. Export this document as PDF named exactly: 23IT098_ProblemStatement4.pdf
2. Insert all listed screenshots in proper sequence.
3. Verify credentials and role navigation before final submission.
4. Attach source code repository link if required by your evaluator.
