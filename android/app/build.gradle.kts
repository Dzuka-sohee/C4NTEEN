plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.C4NTEEN.c4nteen"
    compileSdk = 36  // ✅ Update ke SDK terbaru
    ndkVersion = "29.0.13113456"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.C4NTEEN.c4nteen"
        minSdk = flutter.minSdkVersion
        targetSdk = 36  // ✅ Samakan dengan compileSdk
        versionCode = 1
        versionName = "1.0"
        multiDexEnabled = true
    }

    buildTypes {
    release {
        signingConfig = signingConfigs.getByName("debug")

        // ✅ Nonaktifkan shrink & minify
        isMinifyEnabled = false
        isShrinkResources = false
    }
}

}

dependencies {
    // ✅ Firebase BoM (versi terbaru kompatibel dengan SDK 36)
    implementation(platform("com.google.firebase:firebase-bom:33.7.0"))

    // Firebase modules
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")
    implementation("com.google.firebase:firebase-storage")

    // ✅ Google Sign-In (kompatibel dengan SDK 36)
    implementation("com.google.android.gms:play-services-auth:20.7.0")
}

flutter {
    source = "../.."
}

// ✅ PENTING: Plugin Google Services HARUS di paling bawah
apply(plugin = "com.google.gms.google-services")
