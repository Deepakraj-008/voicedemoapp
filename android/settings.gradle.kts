pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

import java.util.Properties
import java.io.File

/**
 * Read flutter.sdk from local.properties
 */
val localProps = Properties().apply {
    val f = File(rootDir, "local.properties")
    if (!f.exists()) {
        throw GradleException("local.properties not found at ${f.absolutePath}")
    }
    f.inputStream().use { load(it) }
}
val flutterSdkPath = localProps.getProperty("flutter.sdk")
    ?: throw GradleException("`flutter.sdk` not set in local.properties")

// Let Flutter inject its Gradle logic
includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

// Your Android app module
include(":app")