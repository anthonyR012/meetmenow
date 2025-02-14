# **Flutter Video Call App (Agora & Firebase)**

## **📌 Overview**
This is a **cross-platform video calling application** built with **Flutter**, integrating **Agora Video SDK** for real-time communication, **Firebase Authentication** for user login, and **Cubit for state management**. 

The app includes features like:
- 🔐 **User Authentication** (Firebase)
- 📹 **Real-time Video Calling** (Agora)
- ⏳ **Call Timeout & Auto-End**
- 🎵 **Entry Notification Sound**
- 🔄 **Camera Flip Animation**
- 🌐 **Web, Android & iOS Support**

---

## **🚀 Features**
### ✅ **User Authentication**
- Uses **Firebase Authentication** to allow users to log in via email/password.
- Users can **register, sign in, and log out** securely.

### ✅ **Real-time Video Calls**
- Uses **Agora Video SDK** to create and join video calls.
- Allows **multiple users** to connect in the same call.

### ✅ **Call Timeout**
- If a user is **alone for more than 10 minutes**, the call **automatically ends**.
- Uses a **Cubit-based counter** for dynamic timeout handling.

### ✅ **Entry Notification Sound**
- Plays a **notification sound** when a user joins a call.
- Uses the **`audioplayers` package** to handle audio playback.

### ✅ **Camera Flip Animation**
- Smooth **3D camera flip effect** using `Transform.rotate`.
- Adds a **natural flip animation** when switching cameras.

### ✅ **Cross-Platform Support**
- 📱 **Android & iOS** (Firebase + Agora)
- 🖥️ **Web** (Agora Web SDK)

---

## **🛠️ Tech Stack**
| Component         | Technology Used          |
|------------------|------------------------|
| **Frontend**    | Flutter (Dart)          |
| **State Management** | Cubit (Flutter Bloc) |
| **Authentication** | Firebase Auth          |
| **Video Calls** | Agora Video SDK         |
| **Storage** | Firebase Firestore         |
| **Sound Effects** | Audioplayers           |

---

## **📂 Project Structure**
```
lib/
│── main.dart                    # App entry point
│
├── src/
│   ├── auth/                     # Authentication Logic
│   │   ├── bloc/                 # Cubit for Auth
│   │   ├── data/                 # Firebase Auth Data Sources
│   │   ├── domain/               # Auth Entities
│   │   ├── presentation/         # Login/Register Screens
│   │
│   ├── call/                     # Video Call Logic
│   │   ├── bloc/                 # Cubit for Call Management
│   │   ├── data/                 # Agora Service
│   │   ├── domain/               # Call Use Cases
│   │   ├── presentation/         # Video Call UI
│   │
│   ├── core/                     # App Utilities
│   │   ├── config/               # Firebase & Agora Config
│   │   ├── helpers/              # Helper Functions
│   │   ├── constants.dart        # App Constants
│
└── assets/
    ├── sound/                    # Notification Sounds
    │   ├── join-notification.mp3
    ├── icons/                    # SVG Icons
```

---

## **🔧 Setup & Installation**
### **1️⃣ Clone the Repository**
```sh
git clone https://github.com/your-repo/video-call-app.git
cd video-call-app
```

### **2️⃣ Install Dependencies**
```sh
flutter pub get
```

### **3️⃣ Setup Firebase**
- Go to [Firebase Console](https://console.firebase.google.com/).
- Create a new project.
- Enable **Email/Password Authentication**.
- Download `google-services.json` (Android) & `GoogleService-Info.plist` (iOS).
- Place them inside:
  ```
  android/app/google-services.json
  ios/Runner/GoogleService-Info.plist
  ```

### **4️⃣ Setup Agora**
- Go to [Agora Console](https://console.agora.io/).
- Create a project and **copy your App ID**.
- Replace it in `.env`:
  ```dart
  APP_ID_AGORA = "YOUR_AGORA_APP_ID";
  ```

### **5️⃣ Run the App**
```sh
flutter run
```
For web:
```sh
flutter run -d chrome
```

---

## **📜 License**
This project is **open-source** and available under the **MIT License**.

---

## **👨‍💻 Contributors**
- **Anthony Rubio** - _Lead Developer_

---

## **⭐ Support & Feedback**
If you like this project, **give it a star ⭐ on GitHub!**  
For feedback, reach out at **rubionn27@gmail.com**.
