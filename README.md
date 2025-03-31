# Budget Tracker App

## Overview
The **Budget Tracker App** is a Flutter-based expense management application that helps users track their daily expenditures, categorize them, and visualize spending patterns through interactive charts. The app also supports exporting expense reports, including charts, to a PDF document for easy sharing.

## Features
- **Expense Management:** Add, edit, delete, and filter expenses by category.
- **Sorting & Filtering:** Sort expenses by amount and date, filter by category.
- **Total Expenditure Display:** Shows the total expenditure for the displayed expenses.
- **Dark Mode Support:** Toggle between light and dark themes.
- **Charts & Visualization:** View spending trends through bar charts.
- **Export to PDF:** Generate a well-structured PDF report with charts and expense details.
- **Firebase Integration:** Store and sync expenses securely using Firebase.

## Installation
1. **Clone the repository:**
   ```sh
   git clone https://github.com/your-username/budget-tracker.git
   cd budget-tracker
   ```
2. **Install dependencies:**
   ```sh
   flutter pub get
   ```
3. **Set up Firebase:**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/).
   - Enable **Firestore Database** for expense storage.
   - Enable **Authentication** if user login is required.
   - Download and place the `google-services.json` file (for Android) in `android/app/`.
   - Download and place the `GoogleService-Info.plist` file (for iOS) in `ios/Runner/`.
   - Add Firebase dependencies in `pubspec.yaml`:
     ```yaml
     dependencies:
       firebase_core: latest_version
       cloud_firestore: latest_version
       firebase_auth: latest_version  # If authentication is needed
     ```
   - Initialize Firebase in `main.dart`:
     ```dart
     void main() async {
       WidgetsFlutterBinding.ensureInitialized();
       await Firebase.initializeApp();
       runApp(MyApp());
     }
     ```

4. **Run the app:**
   ```sh
   flutter run
   ```

## Dependencies
This app uses the following Flutter packages:
- `provider` - State management
- `flutter/material.dart` - UI framework
- `path_provider` - Access device storage
- `pdf` - Generate PDF documents
- `printing` - Print and share PDFs
- `charts_flutter` - Chart visualization
- `firebase_core` - Firebase initialization
- `cloud_firestore` - Firestore database for storing expenses
- `firebase_auth` (optional) - Authentication support

## Project Structure
```
lib/
├── main.dart  # Entry point of the app
├── screens/
│   ├── home_screen.dart  # Main UI screen
│   ├── charts_screen.dart  # Expense charts screen
├── models/
│   ├── expense.dart  # Expense data model
├── providers/
│   ├── expense_provider.dart  # Expense state management
│   ├── theme_provider.dart  # Dark mode toggle
├── utils/
│   ├── pdf_exporter.dart  # PDF generation logic
```

## Saving and Exporting Reports
The generated **PDF reports** are stored in:
```
/storage/emulated/0/Android/data/YOUR_PACKAGE_NAME/files/Budget_Tracker_Report.pdf
```
The report includes:
- Total expenditure
- Expense breakdown
- Charts for visual representation
- Detailed list of transactions

## Contribution
Feel free to contribute! Fork the repository, make changes, and submit a pull request.

## License
This project is licensed under the **MIT License**.

---
🚀 Happy Budgeting!

