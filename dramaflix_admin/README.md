# 🛠 DramaFlix Admin Panel

The **DramaFlix Admin Panel** is the central management hub for the DramaFlix streaming platform. It allows administrators to manage content, monitor user activity, and maintain the system.

## 🚀 Key Features

- **Store & Episode Management**: Create, edit, and delete stories and their associated episodes.
- **Media Uploads**: Securely upload video files and thumbnails to Supabase Storage.
- **Analytics Dashboard**: Real-time insights into user engagement and playback statistics.
- **User Management**: Monitor and manage user accounts and permissions.

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Web & Desktop)
- **State Management**: [Riverpod](https://riverpod.dev/)
- **Backend API**: [Supabase](https://supabase.com/)
- **Data Persistence**: Supabase Database

## 📂 Architecture

The admin project follows a modular architecture:
- `lib/features/dashboard/`: Main metrics and overview.
- `lib/features/content_management/`: Interface for uploading and editing dramas.
- `lib/features/user_reports/`: Tools for managing user feedback and moderation.

## 🚦 Setup Instructions

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Supabase Setup**:
   Ensure you have the environment variables or service configurations set up for your Supabase project.

3. **Run for Web**:
   ```bash
   flutter run -d chrome
   ```

---
Part of the DramaFlix Ecosystem.
