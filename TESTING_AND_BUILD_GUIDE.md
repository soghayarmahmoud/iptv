# Quick Test & Build Guide for Android TV Box

## Build APK

### Debug Build (for testing with logcat):
```bash
cd g:\flutter_work\iptv
flutter clean
flutter pub get
flutter build apk --debug
```

The debug APK will be at: `build/app/outputs/flutter-apk/app-debug.apk`

### Release Build (for production):
```bash
cd g:\flutter_work\iptv
flutter clean
flutter pub get
flutter build apk --release
```

The release APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

## Test on Android TV Box

### Option 1: Using ADB (Android Debug Bridge)

1. **Connect your TV box via USB and enable USB debugging**
   
2. **Check if device is connected**:
   ```bash
   adb devices
   ```

3. **Install the APK**:
   ```bash
   adb install build/app/outputs/flutter-apk/app-debug.apk
   ```

4. **View live logs during app startup**:
   ```bash
   adb logcat | grep -i flutter
   ```

5. **Open app on device**:
   ```bash
   adb shell am start -n com.dalykc.beeplayertveg/.MainActivity
   ```

### Option 2: Manual Installation

1. Copy the APK file to your TV box using USB storage
2. Use a file manager on the TV box to navigate to the APK
3. Tap to install
4. Grant all required permissions

## What to Check After Installation

### Crash Indicators (Check Logcat):
```
❌ CRASH: Stack trace output
❌ FATAL EXCEPTION
❌ java.lang.NullPointerException
❌ java.lang.RuntimeException
```

### Success Indicators (You should see):
```
✅ "Navigated to: /splash" or similar
✅ "App Started"
✅ Splash screen displays for ~3.5 seconds
✅ Transitions to either Home or Start screen
✅ No errors in logcat (except MediaKit warnings which are safe)
```

### Safe Warnings (Non-blocking):
```
⚠️ "MediaKit initialization warning: ..." - OK, app continues
⚠️ "SystemChrome orientation error: ..." - OK, app continues
⚠️ "CacheHelper initialization error: ..." - OK, uses empty cache
```

## Troubleshooting

### If app still crashes after splash:

1. **Check detailed logs**:
   ```bash
   adb logcat > crash_log.txt
   # Then share this file
   ```

2. **Try uninstall and reinstall**:
   ```bash
   adb uninstall com.dalykc.beeplayertveg
   adb install build/app/outputs/flutter-apk/app-debug.apk
   ```

3. **Check device storage**:
   - TV box may not have enough free space for cache
   - Try to free up at least 500MB

4. **Clear app data**:
   ```bash
   adb shell pm clear com.dalykc.beeplayertveg
   adb shell am start -n com.dalykc.beeplayertveg/.MainActivity
   ```

## Key Improvements Made

The fixes target these common Android TV box issues:

1. ✅ **Null pointer crashes** - All nullable data is type-checked
2. ✅ **Storage access errors** - All storage ops have try-catch
3. ✅ **Orientation errors** - Safe fallback if device doesn't support
4. ✅ **Navigation crashes** - Widget mounted check before navigation
5. ✅ **MediaKit failures** - App continues even if MediaKit init fails
6. ✅ **Race conditions** - Proper async/await handling

## Video Testing

Once the app successfully boots:

1. Navigate to Live TV or Movies
2. Select a channel/movie
3. Tap Play
4. Verify video starts playing
5. Test with remote:
   - D-Pad navigation
   - Select/OK button
   - Back button

## Expected Timeline

- Splash screen: 3.5 seconds
- Transition animation: 0.4 seconds  
- Home/Start screen load: 1-2 seconds
- Total: ~5 seconds from app open to interactive UI

## Common Issues Already Fixed

| Issue | Before | After |
|-------|--------|-------|
| Crash after splash | ❌ Crashes | ✅ Navigates correctly |
| Corrupt cache data | ❌ Crash on load | ✅ Defaults to safe value |
| Storage unavailable | ❌ Crash | ✅ Continues with defaults |
| Old Android API | ❌ Crash | ✅ Graceful degradation |
| No secure storage | ❌ Crash | ✅ Returns null safely |

---

**Need help?** Check the error logs from `adb logcat` and look for the specific error messages mentioned in the troubleshooting section.
