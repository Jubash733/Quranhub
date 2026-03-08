# Deployment & Release Guide

This guide outlines the steps to prepare and release the Quran App to production.

## 1. Environment Configuration
Create a `.env` file in the root directory:
```env
GEMINI_API_KEY=your_key_here
```

## 2. Firebase Configuration
1. Create a project in [Firebase Console](https://console.firebase.google.com/).
2. Add an Android app with package name `com.example.quran_app`.
3. Download `google-services.json` and place it in `android/app/`.
4. Enable **Crashlytics** in the Firebase console.

## 3. Build Optimization
The `android/app/build.gradle` is already configured with:
- `minifyEnabled true`: Obfuscates code.
- `shrinkResources true`: Removes unused resources.

## 4. Signing the App
1. Generate a keystore:
   ```bash
   keytool -genkey -v -keystore f:/quran_new/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Create `android/key.properties`:
   ```properties
   storePassword=your_password
   keyPassword=your_password
   keyAlias=upload
   storeFile=f:/quran_new/upload-keystore.jks
   ```

## 5. Build Commands
```bash
flutter clean
flutter pub get
flutter build apk --release
# Or for App Bundle (Play Store)
flutter build appbundle --release
```

## 6. Post-Release
- Monitor **Firebase Crashlytics** for any production crashes.
- Update the **Privacy Policy** if new data processing features are added.
