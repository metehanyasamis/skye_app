# Mapbox Setup for Skye

The Address field uses **mapbox_maps_flutter** for map-based location selection. You need a Mapbox access token.

## 1. Get Mapbox Token

1. Sign up at [mapbox.com](https://www.mapbox.com)
2. Go to [Account > Access Tokens](https://account.mapbox.com/access-tokens/)
3. Create a **public** token with default scopes (or `styles:read`, `fonts:read`, `datasets:read`)

## 2. Provide the Token

**Option A – Native config (recommended for local dev)**  
Add the token to native config files:

- **Android** `android/app/src/main/AndroidManifest.xml`:
  ```xml
  <meta-data android:name="com.mapbox.token" android:value="pk.your_token_here" />
  ```
  (inside `<application>`)

- **iOS** `ios/Runner/Info.plist`:
  ```xml
  <key>MBXAccessToken</key>
  <string>pk.your_token_here</string>
  ```

**Option B – Dart define**  
```bash
flutter run --dart-define ACCESS_TOKEN=pk.your_public_token_here
```
For release: `flutter build apk --dart-define ACCESS_TOKEN=pk.your_token`

## 3. Android: Secret Token (for SDK download)

Mapbox SDKs are downloaded at build time. You need a **secret** token with `Downloads: Read` scope:

1. Create a secret token at [Mapbox Tokens](https://account.mapbox.com/access-tokens/)
2. Add to `~/.gradle/gradle.properties`:
   ```
   MAPBOX_DOWNLOADS_TOKEN=sk.your_secret_token
   ```

Or set `MAPBOX_DOWNLOADS_TOKEN` as an environment variable before building.

See: [Mapbox Android install guide](https://docs.mapbox.com/android/maps/guides/install/)

## 4. iOS: Secret Token

For iOS, create a `.netrc` file in your home directory or use Xcode build phase.

See: [Mapbox iOS install guide](https://docs.mapbox.com/ios/maps/guides/install/)
