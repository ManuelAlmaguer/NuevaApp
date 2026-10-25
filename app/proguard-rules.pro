# ---- NuevaApp release rules ----
-keepattributes *Annotation*, InnerClasses, Signature, Exceptions, SourceFile, LineNumberTable
-renamesourcefileattribute SourceFile

# Kotlin
-dontwarn kotlin.**
-keep class kotlin.Metadata { *; }

# Compose
-dontwarn androidx.compose.**

# Keep app entry points
-keep class com.manuelalmaguer.nuevaapp.MainActivity { *; }
