package com.donut.wx033a6b34f2c7ea15

import android.app.Activity
import android.provider.Settings
import com.tencent.luggage.wxa.SaaA.plugin.AsyncJsApi
import com.tencent.luggage.wxa.SaaA.plugin.NativePluginInterface
import com.tencent.luggage.wxa.SaaA.plugin.SyncJsApi
import org.json.JSONObject

class TestNativePlugin: NativePluginInterface {
    private val TAG = "TestNativePlugin"

    override fun getPluginID(): String {
        android.util.Log.e(TAG, "getPluginID")
        return BuildConfig.PLUGIN_ID
    }

    @SyncJsApi(methodName = "getAndroidId")
    fun getAndroidId(data: JSONObject?, activity: Activity): String {
        val androidId: String = Settings.Secure.getString(activity.contentResolver, Settings.Secure.ANDROID_ID)
        return androidId
    }
}