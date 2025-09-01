# ✅ Flutter Todo App

**Flutter:** 3.35.1  
**Dart:** 3.9.0  
**Version:** 1.0.0+1

## 📌 Description

This is a Todo List mobile application built with Flutter.  
It allows users to manage daily tasks with persistence powered by **Drift** and state management powered by **Riverpod**.

Beyond simple CRUD operations, the app also supports **task scheduling with notifications**. Users are reminded of their tasks at the scheduled time, and they can fully customize the behavior of notifications and dialogs in the Settings.

---

## ✨ Features

- 📄 **CRUD operations:** create, read, update, and delete tasks
- ⏰ **Scheduled notifications:** users receive reminders at task time
- 🔕 **Enable/disable notifications from Settings**
- ⚙️ **Ask before action option:**
  - When enabled → confirmation dialog before delete, edit, or complete a task
  - When disabled → actions are performed directly
- ✅ **Completing a task automatically cancels its scheduled notification**
- 🔑 **FastHash for task IDs:**
  - Drift uses a String ID for tasks
  - Local notifications require a 32-bit signed integer
  - A custom FastHash function converts task IDs into valid integers safely

---

## 🔔 Notifications

- On first launch, the app asks the user for **notification permission**.
- If the user denies permission:
  - They can later enable notifications manually in the **device settings** (Android/iOS system settings).
- Inside the app **Settings** page, users can enable or disable notifications:
  - ✅ When enabled → scheduled tasks will trigger notifications at the set time
  - ❌ When disabled → no task notifications are delivered
- Completing or deleting a task automatically removes its scheduled notification.

---

## 🏗️ Architecture

The project follows **Clean Architecture principles** with two main layers:

- **Presentation layer** → UI (views), Notifiers (application logic), States (Freezed)
- **Data layer** → Repositories (interfaces + implementations), Data sources, Models

> A domain layer (with use cases and entities) is **not included** because:
>
> - The business logic is simple (CRUD + notifications + settings).
> - Adding a full domain layer would introduce unnecessary boilerplate.
> - Repositories and states are sufficient to separate concerns.

---

## 📂 Folder Structure

```
features/
 ├─ setting/
 └─ task/
     ├─ data/
     │   ├─ data_sources/     → Drift tables, SharedPreferences, notifications
     │   ├─ models/task/      → Models used for persistence and mapping
     │   └─ repository/
     │       ├─ interfaces/   → Repository abstractions
     │       └─ impl/         → Repository implementations
     ├─ presentation/
     │   ├─ notifiers/        → StateNotifiers (application logic)
     │   ├─ states/           → Freezed states
     │   └─ views/            → UI screens and widgets
```

---

## 🧰 Why these technologies?

- **Clean Architecture** → Separation of concerns, easier maintenance, testability
- **Drift** → Type-safe reactive local database, great for offline persistence
- **Riverpod (with Hooks)** → Declarative, testable state management, avoids global mutable state, easy dependency injection

---

## 🧪 Tests

- Repository logic (with mocked data sources and preferences)
- Notifiers and state transitions
- `mocktail` is used for mocking dependencies

---

## 🚀 Installation & Run

1. **Clone the project**

```bash
git clone https://github.com/h-er0/flutt_todo_app.git
cd flutter_todo_app
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Generate code (Freezed, json_serializable, Drift)**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run app**

```bash
flutter run
```

---

## 📱 Running on Android & iOS

### ▶️ Android

- Connect an Android device or start an emulator
- Ensure you have Android SDK & AVD set up

```bash
flutter run -d android
```

- Alternatively, build and install the APK:

```bash
flutter build apk --release
flutter install
```

### 🍏 iOS

- Navigate to the `ios/` directory and install CocoaPods dependencies:

```bash
cd ios
pod install
cd ..
```

- Open the project in Xcode (`ios/Runner.xcworkspace`) if needed
- Make sure you have a valid Apple Developer account & provisioning profile

```bash
flutter run -d ios
```

- To build for release:

```bash
flutter build ios --release
```

---

## ⚠️ Challenges & Solutions

- **Notification IDs** → Solved with FastHash to map string IDs into valid 32-bit integers.
- **Dialogs before actions** → Implemented as a configurable setting (`askBeforeAction`).
- **Notification management** → When a task is completed or deleted, its notification is automatically removed.
- **No domain layer** → Decision taken to reduce boilerplate while keeping separation of concerns.

---

## 📖 Resources

- [Flutter Architecture Docs](https://flutter.dev/docs/development/data-and-backend/architecture)
- [Riverpod Documentation](https://riverpod.dev)
- [Drift Documentation](https://drift.simonbinder.eu/)
- [Freezed](https://pub.dev/packages/freezed)

---

## 👨‍💻 Author

Developed as part of a Flutter onboarding evaluation.
