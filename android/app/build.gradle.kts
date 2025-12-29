plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.dalykc.beeplayertveg"
    compileSdk = 34
    ndkVersion = "25.2.9519653"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    // Enable required build features
    buildFeatures {
        viewBinding = true
        dataBinding = true
        buildConfig = true  // Enable BuildConfig generation
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.dalykc.beeplayertveg"

        // Minimum SDK: Android 5.0 (API 21) - Supports most Android TV boxes
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = flutter.versionCode?.toInt() ?: 1
        versionName = flutter.versionName ?: "1.0.0"

        // TV-specific configurations
        buildConfigField("boolean", "IS_TV", "true")

        // MultiDex support for older devices and to prevent 65K method limit
        multiDexEnabled = true

        // TV-SAFE: Build ONLY for ARM architectures (armeabi-v7a and arm64-v8a)
        // Remove x86 and x86_64 to reduce APK size and avoid compatibility issues
        ndk {
            abiFilters.addAll(listOf("armeabi-v7a", "arm64-v8a"))
        }

        // Enable vector drawable support for older devices
        vectorDrawables.useSupportLibrary = true
    }

    // DISABLE ABI splits to create a single universal APK that works on all devices
    splits {
        abi {
            isEnable = false
        }
    }

    buildTypes {
        getByName("release") {
            // DISABLE minification to ensure stability on TV boxes
            isMinifyEnabled = false
            isShrinkResources = false

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            isDebuggable = false
            signingConfig = signingConfigs.getByName("debug")

            ndk {
                debugSymbolLevel = "NONE"
            }
        }

        getByName("debug") {
            isDebuggable = true
            isMinifyEnabled = false
            isShrinkResources = false

            // Debug settings for better performance
            ndk {
                debugSymbolLevel = "FULL"
            }

            // Enable multidex for debug builds
            multiDexEnabled = true
        }
    }

    // Package options for compatibility
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
        jniLibs {
            useLegacyPackaging = false
        }
    }
}
            isShrinkResources = false

            // Debug settings for better performance
            ndk {
                debugSymbolLevel = "FULL"
            }

            // Enable multidex for debug builds
            multiDexEnabled = true
        }
    }

    // Package options for compatibility
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
        jniLibs {
            useLegacyPackaging = false
        }
    }
}

flutter {
    source = "../.."
}
