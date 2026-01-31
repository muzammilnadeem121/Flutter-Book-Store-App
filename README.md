# 📚 E-Project — Online Book Store App (Flutter + Firebase)

A full-featured **Online Book Store mobile application** built using **Flutter** and **Firebase**, including a complete **Admin Panel** for managing books, users, reviews, and analytics.

This project follows clean architecture principles and uses **Provider** for state management.

---

## 🚀 Features

### 👤 User Features
- User Authentication (Login / Register)
- Edit Profile & Change Password
- Browse Books by category
- Book Details Screen
- Wishlist functionality (Firestore-based)
- Add Reviews & Like Reviews
- Rate books (one-time rating per user)
- Cart management
- Persistent user data

---

### 🛠️ Admin Panel Features
- Role-based access (Admin / User)
- Manage Books (Add / Edit / Delete)
- Manage Reviews (Moderation)
- Manage Users
- Analytics Dashboard:
  - Total users
  - Total books
  - Total reviews
  - Wishlist insights

---

## 🧠 Tech Stack

| Technology | Purpose |
|---------|--------|
| Flutter | UI Framework |
| Dart | Programming Language |
| Firebase Authentication | User Auth |
| Cloud Firestore | Database |
| Provider | State Management |

---

## 📂 Project Structure

```
lib/
│
├── models/ # Data models
├── services/ # Firebase services
├── providers/ # Providers (state management)
├── features/
│ ├── Auth/
│ ├── admin/
│ ├── bookDetails/
│ ├── wishlist/
│ ├── splash/
│ └── layout/
│
├── routes/
| ├── app_routes.dart
└── main.dart
```

---

## 🔐 User Roles

### User
- Browse and review books
- Add to wishlist
- Rate books
- Manage profile

### Admin
- Manage books
- Moderate reviews
- Manage users
- View analytics

---

## 🔥 Firebase Collections

- `users`
- `books`
- `ratings`

---

## ⚙️ Setup Instructions

1. Clone the repository

   ```
   git clone https://github.com/muzammilnadeem121/Flutter-Book-Store-App.git
   ````

2. Install Dependencies

    ```
    flutter pub get
    ```

3. Firebase Setup

    - Create a Firebase Project.
    - Enable Authentication & Firestore.
    - Add Firebase Config file.

4. Run the App

    ```
    flutter run
    ````

---
## 📌 Future Enhancements

- Pagination & performance optimizations
- Push notifications
- Orders & payments module
- Advanced analytics

## 👨‍💻 Author

### **Muzammil Nadeem**
**Flutter Developer**

---

## ⭐ Support

If you like this project, don’t forget to ⭐ the repository!