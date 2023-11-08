package com.example.demo1
import android.content.Context
import android.database.Cursor
import android.media.RingtoneManager
import android.hardware.Camera
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


@Suppress("DEPRECATION")
class MainActivity: FlutterFragmentActivity() {
    private var camera: Camera? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val ringtoneChannel = "ringtone_channel"
        val flashlightChannel = "flashlight_channel"

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ringtoneChannel).setMethodCallHandler { call, result ->
            when (call.method) {
                "getRingtones" -> {
                    val ringtones = getAllRingtones(this)
                    result.success(ringtones)
                }
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, flashlightChannel).setMethodCallHandler { call, result ->
            when (call.method) {
                "turnOnFlashlight" -> {
                    val on = call.arguments as? List<Boolean>
                    if (on != null && on.isNotEmpty() && on[0]) {
                        turnOnFlashlight()
                        // Delay for 5 seconds and then turn off flashlight
                        Thread {
                            Thread.sleep(5000)
                            turnOffFlashlight()
                        }.start()
                        result.success(true)
                    } else {
                        turnOffFlashlight()
                        result.success(false)
                    }
                }
            }
        }
    }

    private fun getAllRingtones(context: Context): List<String> {
        val manager = RingtoneManager(context)
        manager.setType(RingtoneManager.TYPE_RINGTONE)

        val cursor: Cursor = manager.cursor
        val list: MutableList<String> = mutableListOf()

        while (cursor.moveToNext()) {
            val notificationTitle: String = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX)
            list.add(notificationTitle)
        }
        return list
    }

    private fun turnOnFlashlight() {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
            // Check if the device is running Android 6.0 (Marshmallow) or higher
            try {
                // Use the Camera2 API to control the flashlight
                val cameraManager = getSystemService(Context.CAMERA_SERVICE) as android.hardware.camera2.CameraManager
                val cameraId = cameraManager.cameraIdList[0] // Use the first available camera

                cameraManager.setTorchMode(cameraId, true)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        } else {
            // For devices with API level below 23, use the deprecated Camera API
            try {
                camera = Camera.open()
                val parameters = camera?.parameters
                parameters?.flashMode = Camera.Parameters.FLASH_MODE_TORCH
                camera?.parameters = parameters
                camera?.startPreview()
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    private fun turnOffFlashlight() {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
            try {
                val cameraManager = getSystemService(Context.CAMERA_SERVICE) as android.hardware.camera2.CameraManager
                val cameraId = cameraManager.cameraIdList[0] // Use the first available camera

                cameraManager.setTorchMode(cameraId, false)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        } else {
            // For devices below API 23, use the deprecated Camera API
            try {
                camera?.stopPreview()
                camera?.release()
                camera = null
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}
