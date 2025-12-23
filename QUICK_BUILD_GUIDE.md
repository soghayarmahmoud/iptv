# Build APK for Android Box - Quick Start

## Pre-Build Checklist
- [ ] Flutter installed and updated: `flutter --version`
- [ ] Android SDK installed: `flutter doctor`
- [ ] 8GB+ disk space available
- [ ] Java JDK 11 installed

## Step 1: Clean and Prepare
```bash
cd g:\flutter_work\iptv
flutter clean
flutter pub get
```

## Step 2: Build Release APK (Production)
**Best for Android boxes - optimized and secure**

```bash
flutter build apk --release
```

**Output**: 
- `build/app/outputs/flutter-apk/app-release.apk`
- Size: ~45-55 MB
- Build time: 5-10 minutes

### What happens during release build:
1. ✅ Code compiled with Java 11
2. ✅ Dart code compiled to native ARM64
3. ✅ ProGuard obfuscation (minifies code)
4. ✅ Resource shrinking (removes unused assets)
5. ✅ Immersive UI configuration
6. ✅ Android 10+ optimization

## Step 3: Install on Android Box

### Method A: USB Drive
1. Copy `app-release.apk` to USB drive
2. Insert USB into Android box
3. Open Files/File Manager
4. Navigate to USB storage
5. Tap APK → Install
6. Allow installation if prompted

### Method B: ADB (Android Debug Bridge)
```bash
# Enable Developer Mode on Android Box:
# Settings > About > Build Number (tap 7 times)
# Then: Settings > Developer Options > USB Debugging

# Connect via USB cable
adb devices

# Install app
adb install -r build/app/outputs/flutter-apk/app-release.apk

# Verify installation
adb shell pm list packages | grep beeplayertveg
```

### Method C: WiFi Installation (No USB)
```bash
# On Android Box:
# Settings > Developer Options > ADB over Network (Enable)
# Note the IP address shown

# On your computer:
adb connect <ANDROID_BOX_IP>:5555
adb install -r build/app/outputs/flutter-apk/app-release.apk
adb disconnect
```

## Step 4: Launch App
- Tap "Bee Player" icon on home screen
- OR: Settings > Apps > Bee Player > Open

## Step 5: Test Features

### Test Login
1. Enter credentials
2. Verify success message

### Test Video Playback
1. Navigate to Live TV (D-pad right)
2. Select a channel (Press Enter)
3. Video should start playing
4. Press spacebar/enter to pause
5. D-pad left/right to seek

### Test Remote Control
- **D-pad**: Navigate menus
- **Enter/Select**: Activate items
- **Back/Escape**: Go back
- **Play/Pause**: Playback control
- **Volume**: Adjust volume

## Troubleshooting

### Error: "Could not resolve all files for configuration"
```bash
# Solution: Update Gradle
flutter clean
flutter pub get
```

### Error: "AndroidManifest.xml not found"
```bash
# Solution: Complete rebuild
flutter clean
rm -rf build/
flutter pub get
flutter build apk --release
```

### App Crashes on Startup
```bash
# Check logs
adb logcat | grep flutter > error_log.txt

# Install debug APK first to see detailed errors
flutter build apk --debug
adb install -r build/app/outputs/flutter-apk/app-debug.apk
adb logcat
```

### Video Not Playing
- Check internet connection (ping api.beeplayer1.com)
- Verify playlist is active
- Check cleartext traffic is enabled (already configured)
- Test with different channel/video

### App Too Slow
```bash
# In gradle.properties, try:
org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=1G
org.gradle.parallel=true
```

## Advanced: Build Variants

### Profile Build (Development Testing)
```bash
# Optimized but with debugging info
flutter build apk --profile
adb install -r build/app/outputs/flutter-apk/app-profile.apk
```

### Debug Build (Development Only)
```bash
# Fastest to build, not recommended for Android box
flutter build apk --debug
```

## After Installation: Next Steps

1. **Update Version** (for app store):
   - Edit `pubspec.yaml`: version: 1.0.0+2
   - Edit `android/app/build.gradle.kts`: versionCode++

2. **Code Signing** (for Google Play):
   - Create keystore: `keytool -genkey -v -keystore ...`
   - Configure `android/key.properties`
   - Update signing config in build.gradle.kts

3. **App Bundle** (for Google Play):
   ```bash
   flutter build appbundle --release
   ```

## Files Generated

After successful build, you'll have:

```
build/app/outputs/
├── flutter-apk/
│   ├── app-release.apk       ← USE THIS FOR ANDROID BOX
│   ├── app-debug.apk
│   └── app-profile.apk
└── apk/
    └── release/
        └── app-release.apk
```

## Size Breakdown (Release APK ~50 MB)

- Flutter framework: ~25%
- Dart dependencies: ~30%
- Asset files: ~15%
- Video player plugins: ~20%
- Other libs: ~10%

## Performance Expectations

| Metric | Expected |
|--------|----------|
| Install time | 1-2 minutes |
| Startup time | 2-3 seconds |
| Video load time | 1-2 seconds |
| UI responsiveness | Smooth (60 FPS) |
| Memory usage | 150-250 MB |

## Important Notes for Android 10 Boxes

✅ **Already Configured**:
- Cleartext traffic support
- Immersive fullscreen mode
- Landscape orientation lock
- Remote control button handling
- Hardware video acceleration
- Proper permission declarations

⚠️ **Ensure on Box**:
- Developer Mode enabled
- USB Debugging enabled (if using ADB)
- Sufficient storage (>200 MB free)
- Network connectivity (WiFi or Ethernet)

## Security Notes

- Release APK is minified and obfuscated
- Debug APK contains sensitive debugging info
- Never distribute debug APK to users
- Sign all production APKs with your keystore

---

**Your app is ready to build and deploy! 🚀**

For detailed deployment guide, see: `BUILD_AND_DEPLOYMENT_GUIDE.md`
