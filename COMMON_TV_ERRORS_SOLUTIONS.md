# Common Android TV Box Build & Runtime Errors - Solutions

## Build Time Errors

### Error 1: SDK Compilation Errors

**Error Message**:
```
error: Unable to resolve dependency for app@debug/compileClasspath: 
com.google.android.gms:play-services-*
```

**Solution**:
```gradle
// In android/app/build.gradle.kts, add:
dependencies {
    implementation 'com.google.android.gms:play-services-base:18.0.0'
}
```

---

### Error 2: Gradle Sync Failed

**Error Message**:
```
FAILURE: Build failed with an exception.
Could not determine the dependencies of task ':app:compileDebugJavaWithJavac'
```

**Solution**:
```bash
# Clean and rebuild
flutter clean
rm -rf build/
rm -rf android/.gradle
flutter pub get
flutter build apk --release
```

---

### Error 3: Native Compilation Failed

**Error Message**:
```
error: undefined reference to 'Java_...Native methods'
```

**Solution**: Add in `android/app/build.gradle.kts`:
```kotlin
android {
    ndkVersion = "27.0.12033604"
    
    packagingOptions {
        pickFirst 'lib/arm64-v8a/libc++_shared.so'
        pickFirst 'lib/armeabi-v7a/libc++_shared.so'
    }
}
```

---

### Error 4: Manifest Merge Failed

**Error Message**:
```
Manifest merger failed : uses-sdk:minSdkVersion 16 cannot be less than 
version 19 defined in library
```

**Solution**: In `android/app/build.gradle.kts`:
```kotlin
defaultConfig {
    minSdk = 21  // Already set - should be 21 or higher
    targetSdk = 34
}
```

---

## Runtime Errors

### Error 1: Network Timeout on Startup

**Symptom**: App hangs when fetching playlists, then crashes
**Cause**: No network error handling for TV boxes with unstable WiFi

**Solution**: Already fixed in your code with null-safe error handling
```dart
final errorData = e.response?.data ?? {
  'statusCode': 0,
  'message': 'Network error',
  'error': 'REQUEST_ERROR'
};
```

---

### Error 2: Video Playback Fails with "Media Player Error"

**Symptom**: "Error opening file" or "Unsupported format"
**Possible Causes**:
1. Stream URL format incompatible
2. Codec not supported
3. Network interruption

**Solutions**:
```dart
// In video player view:
MediaKit.ensureInitialized();

// Set appropriate player options
final player = Player();
await player.open(
  Media(streamUrl),
  play: true,
);

// Error handling
player.streams.error.listen((error) {
  print('Playback error: $error');
  // Retry or show user-friendly error
});
```

---

### Error 3: Remote Control Buttons Not Responding

**Symptom**: D-pad or remote buttons don't work
**Cause**: Focus not properly managed, or remote key mapping missing

**Solution**: Your RemoteKeyHandler should be wrapping the entire app:
```dart
// In main.dart - this is already done
MultiBlocProvider(
  providers: [...],
  child: const RemoteKeyHandler(child: MyApp()),
)
```

To debug:
```dart
// Add debug logging
class RemoteKeyHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKey: (node, event) {
        print('Key pressed: ${event.logicalKey}');
        return KeyEventResult.ignored;
      },
      child: child,
    );
  }
}
```

---

### Error 4: Text Not Scaling Properly on TV

**Symptom**: Text appears too small/too large on 55" vs 32" TV
**Cause**: Not disabling system text scaling

**Solution**: Already implemented in your code:
```dart
builder: (context, child) {
  return MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
    child: child!,
  );
},
```

To use responsive sizing with TVUtils:
```dart
Text(
  'Channel Name',
  style: TVUtils.getTVBodyStyle(context),
)
```

---

### Error 5: Landscape Orientation Issues

**Symptom**: App rotates to portrait when it shouldn't
**Cause**: Device settings override or incorrect orientation lock

**Solution**: Already configured:
```dart
SystemChrome.setPreferredOrientations([
  DeviceOrientation.landscapeLeft,
  DeviceOrientation.landscapeRight,
]);
```

If still having issues, add to AndroidManifest.xml (already done):
```xml
android:screenOrientation="sensorLandscape"
```

---

### Error 6: App Crashes on Login

**Symptom**: Login button works but app crashes after
**Possible Causes**:
1. Null pointer in token storage
2. Network error during playlist fetch
3. Missing required data

**Solution**:
```dart
// In AuthCubit
Future<void> login(String username, String password) async {
  try {
    emit(AuthLoading());
    final response = await authRepo.login(username, password);
    
    response.fold(
      (failure) {
        // Error handling - shows message to user
        emit(AuthError(failure.message));
      },
      (userData) {
        // Success - go to next screen
        emit(AuthSuccess(userData));
      },
    );
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}
```

---

### Error 7: Memory Leak - App Gets Slow Over Time

**Symptom**: App becomes sluggish after playing videos for a while
**Cause**: Video player not releasing memory, or large images not cached

**Solution**:
```dart
// Dispose video player properly
@override
void dispose() {
  _chewie?.dispose();
  _videoPlayerController?.dispose();
  super.dispose();
}

// Use cached_network_image with memory limit
CachedNetworkImage(
  imageUrl: url,
  memCacheHeight: 360,  // Scale down large images
  memCacheWidth: 640,
)
```

---

### Error 8: Freezing on Network Switch

**Symptom**: App freezes when WiFi drops/reconnects
**Cause**: Network requests not properly timed out

**Solution**: Configure Dio with timeouts:
```dart
// In DioConsumer
Dio(
  BaseOptions(
    connectTimeout: Duration(seconds: 15),
    receiveTimeout: Duration(seconds: 15),
    sendTimeout: Duration(seconds: 15),
  ),
)
```

Already configured - check your dio_consumer.dart

---

### Error 9: Favorites/History Not Saving

**Symptom**: Favorites disappear on app restart
**Cause**: SharedPreferences not initialized or permission issues

**Solution**:
```dart
// Ensure initialization before use
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();  // Must do this!
  runApp(MyApp());
}

// Debug: Check what's saved
final prefs = await SharedPreferences.getInstance();
final keys = prefs.getKeys();
print('Saved keys: $keys');
```

---

### Error 10: ProGuard Obfuscation Breaking HTTP

**Symptom**: Works in debug, crashes in release with network errors
**Cause**: ProGuard over-obfuscating essential HTTP classes

**Solution**: Already fixed in proguard-rules.pro:
```
-keep class io.flutter.plugins.** { *; }
-keep class com.google.api.client.** { *; }
-keep class io.reactivex.** { *; }
-keep class com.google.gson.** { *; }
```

---

## Logcat Debug Commands

### View all Flutter errors:
```bash
adb logcat | grep -i flutter
```

### View only errors:
```bash
adb logcat | grep -i error
```

### View network errors:
```bash
adb logcat | grep -E "(Dio|http|network|timeout)"
```

### View video player errors:
```bash
adb logcat | grep -E "(Media|Video|Chewie)"
```

### Save detailed logs to file:
```bash
adb logcat > app_logs.txt
# Wait a few seconds, then Ctrl+C
# View with: cat app_logs.txt
```

### Real-time detailed log:
```bash
adb logcat -v threadtime | grep flutter
```

---

## TV Box Specific Issues

### Issue: App Not Appearing on TV Home Screen

**Solution**: LEANBACK_LAUNCHER is already in your manifest:
```xml
<category android:name="android.intent.category.LEANBACK_LAUNCHER"/>
```

If still not showing:
1. Restart TV box
2. Clear Play Store cache: Settings > Apps > Play Store > Storage > Clear Cache
3. Reinstall app

---

### Issue: Remote Control Discovery

**Solution**: Android automatically detects remote. If not working:
1. Unpair and re-pair remote in Bluetooth settings
2. Restart app
3. Try using volume buttons first (usually works first)

---

## Quick Troubleshooting Flowchart

```
App doesn't start?
├─ Check logcat for errors
├─ Verify internet connection
└─ Try debug build to see detailed error

Video won't play?
├─ Check playlist is active
├─ Verify internet speed (test ping api.beeplayer1.com)
├─ Try different video/channel
└─ Check codec support

Remote not working?
├─ Check Focus is enabled
├─ Verify RemoteKeyHandler wraps app
├─ Try pressing other keys
└─ Check Bluetooth pairing

App slow/freezing?
├─ Close other apps
├─ Check available RAM
├─ Clear app cache
└─ Restart TV box

Build fails?
├─ Run: flutter clean
├─ Run: flutter pub get
├─ Check gradle version
└─ Check internet connection (gradle downloads)
```

---

## Testing the Fixes

Run these commands to verify everything works:

```bash
# 1. Clean build
flutter clean
flutter pub get

# 2. Run analysis
flutter analyze

# 3. Build APK
flutter build apk --release

# 4. Install on device
adb install -r build/app/outputs/flutter-apk/app-release.apk

# 5. Check app starts
adb shell am start -n com.dalykc.beeplayertveg/.MainActivity

# 6. Monitor logs
adb logcat | grep flutter
```

---

## Performance Optimization

If app is slow on TV box:

```gradle
// android/app/build.gradle.kts
android {
    buildTypes {
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
            // Add R8/ProGuard optimization
        }
    }
}
```

Also in gradle.properties:
```
org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=1G
org.gradle.parallel=true
org.gradle.workers.max=4
```

---

All common errors covered. Your app should now build and run smoothly on Android TV boxes! 🚀
