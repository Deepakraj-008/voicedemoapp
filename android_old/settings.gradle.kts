import org.gradle.api.initialization.resolve.RepositoriesMode

pluginManagement {
    // read flutter.sdk from local.properties
    val flutterSdkPath: String = run {
        val props = java.util.Properties()
        file("local.properties").inputStream().use { props.load(it) }
        val path = props.getProperty("flutter.sdk")
        check(path != null) { "flutter.sdk not set in local.properties" }
        path
    }

    // make Flutter's Gradle plugins available
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

// IMPORTANT: repositories for all modules (app + plugins)
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
    repositories {
        google()
        mavenCentral()
        // Flutter artifacts
        maven { url = uri("https://storage.googleapis.com/download.flutter.io") }
    }
}

// Flutter plugin loader + toolchain plugins (versions here are fine)
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.5.2" apply false
    id("org.jetbrains.kotlin.android") version "1.9.24" apply false
}

include(":app")