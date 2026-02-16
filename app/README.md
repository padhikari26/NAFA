
# NAFA Mobile App

NAFA Mobile App is a cross-platform application designed to provide users with a seamless experience for accessing NAFA services. Built using Flutter, it supports both Android and iOS devices.

## Features
- User authentication and registration
- Access to core NAFA features
- Notifications and alerts
- File picker and saver
- PDF viewing
- Audio and video playback
- Calendar integration
- Device information and connectivity

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android Studio or Xcode (for platform-specific builds)
- Dart

### Installation
1. Clone the repository:
	```bash
	git clone https://github.com/aadarsha07/nafausa-app.git
	```
2. Navigate to the project directory:
	```bash
	cd nafa-mobile-app
	```
3. Install dependencies:
	```bash
	flutter pub get
	```



## Project Structure
- `lib/` - Main application code
- `android/` - Android-specific files
- `ios/` - iOS-specific files
- `assets/` - Images and animations
- `build/` - Build outputs

## Contributing
Contributions are welcome! Please open issues or submit pull requests for improvements and bug fixes.

## License
This project is licensed under the MIT License.

## Contact
For questions or support, contact [aadarsha07](https://github.com/aadarsha07).


### Building the App

This project is a starting point for a Flutter application.
```bash
flutter clean && flutter pub get
```

###  Build apk for development
```bash
flutter build apk lib/main_dev.dart --release && cd build/app/outputs/flutter-apk && cp app-release.apk nafausa-dev.apk && cd -
```


###  Build apk for production
```bash
flutter build apk lib/main_prod.dart --release && cd build/app/outputs/flutter-apk && cp app-release.apk nafausa-live.apk && cd -
```

###  Build appbundle for production
```bash
flutter build appbundle -t lib/main_prod.dart --release