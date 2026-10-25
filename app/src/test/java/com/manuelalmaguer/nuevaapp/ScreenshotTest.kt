package com.manuelalmaguer.nuevaapp

import android.graphics.Bitmap
import android.graphics.Canvas
import android.view.View
import androidx.compose.ui.test.junit4.createAndroidComposeRule
import androidx.test.ext.junit.runners.AndroidJUnit4
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode
import java.io.File
import java.io.FileOutputStream

/**
 * Genera capturas PNG de la app en la JVM (Robolectric + graphics nativo).
 * Salida: PNG en app/build/screenshots/
 *
 * Sirve como verificacion visual del render sin emulador ni dispositivo.
 */
@RunWith(AndroidJUnit4::class)
@Config(sdk = [33], qualifiers = "es-rCO-w411dp-h891dp-xxhdpi")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class ScreenshotTest {

    @get:Rule
    val composeRule = createAndroidComposeRule<MainActivity>()

    @Test
    fun captura_pantalla_principal() {
        composeRule.waitForIdle()
        val view = composeRule.activity.window.decorView

        if (view.width == 0 || view.height == 0) {
            val dm = composeRule.activity.resources.displayMetrics
            view.measure(
                View.MeasureSpec.makeMeasureSpec(dm.widthPixels, View.MeasureSpec.EXACTLY),
                View.MeasureSpec.makeMeasureSpec(dm.heightPixels, View.MeasureSpec.EXACTLY)
            )
            view.layout(0, 0, dm.widthPixels, dm.heightPixels)
        }

        val bitmap = Bitmap.createBitmap(view.width, view.height, Bitmap.Config.ARGB_8888)
        view.draw(Canvas(bitmap))

        val dir = File("build/screenshots").apply { mkdirs() }
        val out = File(dir, "home-light.png")
        FileOutputStream(out).use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }

        assertTrue("La captura debe existir", out.exists() && out.length() > 1_000)
    }
}