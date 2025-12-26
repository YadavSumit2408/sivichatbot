# SiviChatbot – Mini Chat Application (Flutter)

A mini chat application built as part of the **MySivi AI – Flutter Developer Assignment**.  
The app follows clean architecture principles, uses **MVC with BLoC/Cubit**, and covers all required and bonus features mentioned in the assignment. :contentReference[oaicite:0]{index=0}

---

## 📱 Project Overview

SiviChatbot is a Flutter-based mini chat application featuring:
- A functional Home tab with users and chat history
- A real-time styled chat screen
- API-driven receiver messages
- Clean UI/UX with proper state management

---

## ✅ Features Covered (Assignment Requirements)

### 🏠 Home Screen
- Custom **top-tab switcher** inside the AppBar:
  - **Users**
  - **Chat History**
- Switcher hides on scroll down and reappears on scroll up
- Scroll position preserved while switching tabs

---

### 👤 Users List Tab
- Displays a scrollable list of users added locally
- Each user shows:
  - Name
  - Avatar with initial
- **Floating Action Button (+)**:
  - Visible only on Users tab
  - Adds a new user (name only)
  - Shows snackbar confirmation (“User added”)
- Tapping a user navigates to the Chat Screen

---

### 💬 Chat History Tab
- Displays previous chat sessions with:
  - User avatar
  - User name
  - Last message
  - Last chat time
- Scroll position preserved when switching tabs

---

### 💬 Chat Screen
- Two types of messages:
  
#### 1. Sender Messages (Local)
- Displayed on the **right**
- Rounded chat bubbles
- Sender avatar with initial

#### 2. Receiver Messages (API-based)
- Displayed on the **left**
- Rounded chat bubbles
- Receiver avatar with initial
- Messages fetched from open-source public APIs such as:
  - `dummyjson.com`
  - `jsonplaceholder.typicode.com`
  - `quotable.io`

---

## 🌟 Bonus Features Implemented

- 📖 **Word Meaning Feature**
  - Long-press or tap on any word in sender or receiver messages
  - Opens a **bottom sheet** showing the word meaning
  - Meanings fetched using a public dictionary API
- 🧠 Clean state handling and error-safe API integration

---

## 🏗 Architecture & Technical Details

- **Architecture**: MVC (Model–View–Controller)
- **State Management**: BLoC / Cubit
- **Separation of Concerns**:
  - UI (Views)
  - Business Logic (Cubits)
  - Data Layer (Repositories & APIs)
- Easy to scale and test

---

## 🎨 UI & App Setup
- Splash Screen implemented
- Custom App Icon added
- UI closely follows the provided reference design
- Smooth animations and clean layout

---

## 🧪 Additional Notes
- Error handling for API failures
- Clean navigation flow
- Code structured for maintainability and scalability

---

## 📦 Submission
- Code pushed to GitHub with proper commit history
- APK and demo video shared via Google Drive
- Submitted as per assignment instructions

---

## 👨‍💻 Developer
**Sumit Yadav**  
Flutter Developer

---


