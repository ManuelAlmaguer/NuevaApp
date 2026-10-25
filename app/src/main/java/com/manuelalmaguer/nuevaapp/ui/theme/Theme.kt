package com.manuelalmaguer.nuevaapp.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

private val Indigo = Color(0xFF4F46E5)
private val IndigoDark = Color(0xFFA5B4FC)
private val Teal = Color(0xFF0D9488)
private val TealDark = Color(0xFF5EEAD4)

private val LightColors = lightColorScheme(
    primary = Indigo,
    onPrimary = Color.White,
    primaryContainer = Color(0xFFE0E7FF),
    onPrimaryContainer = Color(0xFF1E1B4B),
    secondary = Teal,
    onSecondary = Color.White,
    background = Color(0xFFFAFAFF),
    surface = Color(0xFFFFFFFF),
    surfaceVariant = Color(0xFFF1F2F9),
    onSurfaceVariant = Color(0xFF4B5563)
)

private val DarkColors = darkColorScheme(
    primary = IndigoDark,
    onPrimary = Color(0xFF1E1B4B),
    primaryContainer = Color(0xFF3730A3),
    onPrimaryContainer = Color(0xFFE0E7FF),
    secondary = TealDark,
    onSecondary = Color(0xFF00302B),
    background = Color(0xFF0B0B12),
    surface = Color(0xFF14141C),
    surfaceVariant = Color(0xFF1F2030),
    onSurfaceVariant = Color(0xFFC7CAD6)
)

@Composable
fun NuevaAppTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = if (darkTheme) DarkColors else LightColors,
        typography = AppTypography,
        content = content
    )
}