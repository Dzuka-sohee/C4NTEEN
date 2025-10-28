// ✅ Pastikan hanya ada satu blok plugins di atas
plugins {
    // Versi ini harus sama dengan versi di classpath
}

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Versi Gradle plugin (boleh disesuaikan dengan yang terbaru di project-mu)
        classpath("com.android.tools.build:gradle:8.7.3")
        classpath("com.google.gms:google-services:4.3.15") // harus sama dengan di atas
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ Bagian ini aman — mengatur folder build jadi lebih rapi
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

// ✅ Pastikan clean task tetap ada
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
