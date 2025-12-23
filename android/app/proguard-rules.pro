# Flutter app obfuscation and optimization
# Preserve Flutter runtime classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }

# Preserve native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

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

# Preserve media player related classes
-keep class androidx.media3.** { *; }
-keep class android.media.** { *; }

# Preserve libraries used by video player plugins
-keep class com.google.android.exoplayer2.** { *; }

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

# Remove logging in release builds
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# Optimization settings
-optimizationpasses 5
-dontusemixedcaseclassnames

# تجاهل تحذيرات مكتبات جوجل بلاي كور لأننا لا نستخدمها
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**
-keep class com.google.android.play.core.** { *; }