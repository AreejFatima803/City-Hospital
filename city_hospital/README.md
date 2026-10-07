# City Hospital

## Backend
1. Atlas: create a free cluster -> Database Access (add user) -> Network Access (allow your IP or 0.0.0.0/0 for testing) -> Connect -> Drivers -> copy the URI.
2. cd backend && cp .env.example .env  (paste MONGO_URI, set JWT_SECRET and ADMIN_KEY)
3. npm install && npm start   (doctors are seeded on first run)
4. Admin panel: http://localhost:5000/admin (enter ADMIN_KEY)

## Flutter
1. cd app && flutter create .   (generates android/ios folders; keeps lib/ and pubspec.yaml)
2. Set baseUrl in lib/api.dart (10.0.2.2 for Android emulator, your PC's LAN IP for a real phone)
3. Android real/emulator over http: add android:usesCleartextTraffic="true" to <application> in android/app/src/main/AndroidManifest.xml
4. flutter pub get && flutter run

## APK without installing Flutter
1. Create a GitHub repo and upload the contents of this folder (so `.github/` and `app/` are at the repo root).
2. Repo -> Actions -> "Build APK" -> Run workflow -> enter your backend URL.
3. When it finishes, open the run and download `city-hospital-apk` (zip containing app-release.apk).

Note: release APKs need the INTERNET permission in AndroidManifest.xml (the workflow adds it; add it yourself if building locally):
`<uses-permission android:name="android.permission.INTERNET"/>`
