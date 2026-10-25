package com.manuelalmaguer.nuevaapp

import androidx.compose.ui.test.junit4.createAndroidComposeRule
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.assertIsDisplayed
import androidx.test.ext.junit.runners.AndroidJUnit4
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.annotation.Config

/**
 * Prueba de humo: la Activity arranca y la UI principal se renderiza.
 * Se ejecuta en la JVM (Robolectric), sin necesidad de emulador ni dispositivo.
 */
@RunWith(AndroidJUnit4::class)
@Config(sdk = [33], qualifiers = "es-rCO-w411dp-h891dp-xxhdpi")
class MainActivityTest {

    @get:Rule
    val composeRule = createAndroidComposeRule<MainActivity>()

    @Test
    fun `la pantalla principal muestra el titulo de la app`() {
        composeRule.onNodeWithText("NuevaApp").assertIsDisplayed()
    }

    @Test
    fun `la pantalla principal muestra el estado del build`() {
        composeRule.onNodeWithText("Estado del build").assertIsDisplayed()
        composeRule.onNodeWithText(BuildConfig.VERSION_NAME).assertIsDisplayed()
    }
}