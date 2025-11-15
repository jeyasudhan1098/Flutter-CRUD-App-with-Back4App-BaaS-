# 📌 Task Manager App – Flutter CRUD with Back4App (BaaS)

## Jeyasudhan R _2024tm93090

Youtube video : https://youtu.be/Z4_srTDf-tI

## 📱 Project Overview
The Task Manager App is a mobile and web application built using Flutter with Back4App Parse Server as the backend. It allows users to register, log in, and manage tasks with Create, Read, Update, and Delete (CRUD) operations.  
This project demonstrates a complete cloud-connected mobile app without building a custom server.

## ✨ Features
| Feature               | Description                                   |
|-----------------------|-----------------------------------------------|
| 🔐 Authentication     | User signup and login using Back4App          |
| 📝 CRUD on Tasks      | Create, view, update, and delete tasks        |
| ☁ Cloud Database      | Data stored and synced via Back4App           |
| 🔄 Session Management | Automatic session restore                     |
| 🚪 Logout             | Secure logout with session cleanup            |
| 📦 Scalability        | No server setup required                      |



## 🧰 Tech Stack
| Layer              | Technology                                   |
|--------------------|-----------------------------------------------|
| Frontend           | Flutter (Dart)                              |
| Backend            | Back4App (Parse Server API)                 |
| Database           | MongoDB via Back4App cloud                  |
| State Management   | Provider                                    |
| Device Support     | Android, iOS, Web                           |



## 🏗 Project Structure
lib/
 ├── main.dart
 ├── services/
 │    └── auth_service.dart
 ├── screens/
 │    ├── login_screen.dart
 │    ├── register_screen.dart
 │    ├── task_list_screen.dart
 │    ├── add_edit_task_screen.dart
 ├── models/
 │    └── task_model.dart
 ├── widgets/
 │    └── task_tile.dart


## 🔧 Backend Setup – Back4App

### 1️⃣ Log in / Sign up at
👉 https://www.back4app.com/

### 2️⃣ Create a New App
→ Set app name, region, and type (Backend as a Service)

### 3️⃣ Go to:
App Settings → Security & Keys
and copy:

### Setting	Description
Application ID	Parse App ID
Client Key	Used for client authentication
Server URL	Usually https://parseapi.back4app.com/

### 4️⃣ Replace them in main.dart:

const String appId = 'YOUR_APP_ID';
const String clientKey = 'YOUR_CLIENT_KEY';
const String serverUrl = 'https://parseapi.back4app.com/';

### ▶️ Run the App
Mobile (Android/iOS)
```bash
flutter pub get
flutter run
```
Web
```bash
flutter run -d chrome
```
