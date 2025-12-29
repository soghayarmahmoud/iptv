# Flutter app obfuscation and optimization for Android TV
# ====================================================

# Preserve Flutter runtime and embedding classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }

# Preserve all plugin registrants (required for Flutter plugins)
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }
-keep class * extends io.flutter.embedding.engine.plugins.FlutterPlugin { *; }
-keep class * extends io.flutter.embedding.android.FlutterFragment { *; }
-keep class * extends io.flutter.embedding.android.FlutterActivity { *; }

# Preserve native methods and JNI
-keepclasseswithmembernames class * {
    native <methods>;
    @androidx.annotation.Keep <methods>;
    @androidx.annotation.Keep <fields>;
    @androidx.annotation.Keep <init>(...);
}

# Keep setters in Views so that animations can still work
-keepclassmembers public class * extends android.view.View {
   void set*(***);
   *** get*();
}

# Keep the special class that is extended by all fragments
-keep public class * extends androidx.fragment.app.Fragment

# Keep the special class that is extended by all activities
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider

# Preserve enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Preserve Android lifecycle callbacks
-keepclassmembers class * extends android.app.Activity {
    public void *(android.view.View);
}

# Preserve views for layout inflation
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}

# Preserve Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Preserve media player related classes for TV
-keep class androidx.media3.** { *; }
-keep class android.media.** { *; }
-keep class com.google.android.exoplayer2.** { *; }
-keep class com.google.android.exoplayer2.ext.leanback.** { *; }
-keep class com.google.android.exoplayer2.ui.** { *; }
-keep class com.google.android.exoplayer2.source.** { *; }
-keep class com.google.android.exoplayer2.ext.rtmp.** { *; }
-keep class com.google.android.exoplayer2.ext.rtsp.** { *; }
-keep class com.google.android.exoplayer2.upstream.** { *; }
-keep class com.google.android.exoplayer2.offline.** { *; }

# Preserve TV-specific classes
-keep class androidx.leanback.** { *; }
-keep interface androidx.leanback.** { *; }
-keep class android.support.v17.leanback.** { *; }
-keep interface android.support.v17.leanback.** { *; }
-keep class androidx.tvprovider.media.tv.** { *; }

# Preserve AndroidX and support libraries
-keep class androidx.** { *; }
-keep interface androidx.** { *; }
-keep class android.support.v4.** { *; }
-keep interface android.support.v4.** { *; }

# CRITICAL: Preserve MediaKit classes (required for video playback)
-keep class media.** { *; }
-keep class com.alexmercerind.** { *; }
-dontwarn media.**

# Preserve Dio HTTP client library and network classes
-keep class io.flutter.plugins.** { *; }
-keep class com.google.api.client.** { *; }
-keep class io.reactivex.** { *; }
-keep interface io.reactivex.** { *; }

# Preserve JSON serialization
-keep class com.google.gson.** { *; }
-keepclassmembernames class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# CRITICAL: Preserve secure storage classes
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Remove logging in release builds
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# OPTIMIZATION: Reduce passes from 5 to 3 (safer, prevents over-optimization)
-optimizationpasses 3
-dontusemixedcaseclassnames

# تجاهل تحذيرات مكتبات جوجل بلاي كور لأننا لا نستخدمها
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**
-keep class com.google.android.play.core.** { *; }
