# DramaFlix

**DramaFlix** is a modern, high-performance mobile OTT streaming application built with Flutter. It is designed specifically for streaming short-form drama episodes (approximately 30 seconds each) organized into compelling stories.

## Features
- **Short-Form Content**: Optimized for quick, engaging drama episodes.
- **Stories & Episodes**: Organized content hierarchy for easy navigation.
- **Animated Splash Screen**: A premium entrance experience with smooth fade and scale animations.
- **Authentication**: Secure user login and registration powered by Supabase.
- **Modern Navigation**: Seamless routing using `go_router`.
- **State Management**: Robust and scalable state handling with Riverpod.

## Tech Stack
- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [Riverpod](https://riverpod.dev/)
- **Backend (Auth & DB)**: [Supabase](https://supabase.com/)
- **Navigation**: [go_router](https://pub.dev/packages/go_router)
- **Animations**: [flutter_animate](https://pub.dev/packages/flutter_animate)

## Project Structure
The project follows a clean, feature-based architecture:
- `lib/core/`: Global configurations, themes, and router.
- `lib/models/`: Data models (Story, Episode).
- `lib/services/`: API and third-party service wrappers (Supabase).
- `lib/providers/`: Data and state providers using Riverpod.
- `lib/features/`: Feature-specific modules (Splash, Auth, Home, Explore, etc.).
- `lib/shared/`: Reusable UI widgets and components.

## Getting Started
1. **Prerequisites**: Ensure you have Flutter installed on your machine.
2. **Clone the project**:
   ```bash
   git clone <repository-url>
   ```
3. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
4. **Configuration**:
   - Update `lib/services/supabase_service.dart` with your Supabase `URL` and `Anon Key`.
5. **Run the App**:
   ```bash
   flutter run
   ```

## License
This project is licensed under the MIT License.
