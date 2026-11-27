package com.mobilization.msysconsult.mobilization_app

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Typeface
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.print.PrintHelper

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.mobilization.msysconsult.mobilization_app/printer"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "printReceipt" -> {
                        val data = call.arguments as Map<*, *>
                        try {
                            val bitmap = buildReceiptBitmap(data)
                            printBitmap(bitmap)
                            result.success(null)
                        } catch (e: Exception) {
                            result.error("PRINT_ERROR", e.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun printBitmap(bitmap: Bitmap) {
        val printHelper = PrintHelper(this)
        printHelper.scaleMode = PrintHelper.SCALE_MODE_FIT
        printHelper.printBitmap("Receipt", bitmap)
    }

    private fun buildReceiptBitmap(data: Map<*, *>): Bitmap {
        // 58mm at 203 DPI = ~464 pixels wide
        // Use 384 which is standard for 58mm thermal printers
        val width = 384
        val lineHeight = 40f
        val padding = 16f
        val codeLineHeight = 68f
        val codeLineSpacing = 24f

        // Calculate total height dynamically based on content
        val items = data["items"] as? List<*> ?: emptyList<Any>()
        val lineCount = 18 + items.size // header(3) + details(8) + items + dividers+total(3) + footer(2) lines
        val height = (lineCount * lineHeight + padding * 4 + codeLineHeight + codeLineSpacing).toInt()

        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        canvas.drawColor(Color.WHITE)

        val paint = Paint().apply {
            isAntiAlias = true
            color = Color.BLACK
        }

        var y = padding + lineHeight

        // ── Helper functions ──────────────────────────────────────────────

        fun drawCenter(text: String, textSize: Float, bold: Boolean = false) {
            paint.textSize = textSize
            paint.typeface = if (bold) Typeface.DEFAULT_BOLD else Typeface.DEFAULT
            val textWidth = paint.measureText(text)
            canvas.drawText(text, (width - textWidth) / 2f, y, paint)
            y += lineHeight
        }

        fun drawRow(left: String, right: String, textSize: Float, bold: Boolean = false) {
            paint.textSize = textSize
            paint.typeface = if (bold) Typeface.DEFAULT_BOLD else Typeface.DEFAULT
            canvas.drawText(left, padding, y, paint)
            val rightWidth = paint.measureText(right)
            canvas.drawText(right, width - rightWidth - padding, y, paint)
            y += lineHeight
        }

        fun drawDivider() {
            paint.textSize = 24f
            paint.typeface = Typeface.DEFAULT
            val line = "- ".repeat(24)
            canvas.drawText(line, padding, y, paint)
            y += lineHeight
        }

        fun drawCodeLine(source: String) {
            val content = source.ifBlank { "RECEIPT" }
            val barcodePaint = Paint(paint).apply {
                style = Paint.Style.FILL
            }
            val top = y
            val bottom = top + codeLineHeight
            var x = padding
            val maxX = width - padding

            content.forEachIndexed { index, char ->
                val value = char.code + index
                val barWidth = 3f + (value % 5)
                val gapWidth = 3f + ((value / 4) % 4)
                canvas.drawRect(x, top, (x + barWidth).coerceAtMost(maxX), bottom, barcodePaint)
                x += barWidth + gapWidth
                if (x >= maxX) return@forEachIndexed
            }

            while (x < maxX) {
                val fillerWidth = 4f
                val fillerGap = 4f
                canvas.drawRect(x, top, (x + fillerWidth).coerceAtMost(maxX), bottom, barcodePaint)
                x += fillerWidth + fillerGap
            }

            y += codeLineHeight + codeLineSpacing
        }

        // ── Header ────────────────────────────────────────────────────────
        drawRow(data["clientName"].toString(), right = "", textSize = 27f, bold = true)
        drawRow(data["clientNumber"].toString(), right = "", textSize = 23f)
        drawDivider()

        // ── Transaction details ───────────────────────────────────────────
        drawRow("Date:", data["date"].toString(), 22f)
        drawRow("Txn ID:", data["transactionId"].toString(), 22f)
        drawRow("Customer:", data["customerName"].toString(), 22f)
        drawRow("Customer Number:", data["customerNumber"].toString(), 22f)
        drawRow("Customer Account:", data["customerAccount"].toString(), 22f)
        drawRow("Payment Method:", data["paymentMethod"].toString(), 22f)
        drawRow("Transaction Status:", data["status"].toString(), 22f)
        drawDivider()

        // ── Items ─────────────────────────────────────────────────────────
        items.forEach { item ->
            val itemMap = item as? Map<*, *>
            val name = itemMap?.get("name") as? String ?: ""
            val amount = itemMap?.get("amount") as? Double ?: 0.0
            drawRow(name, "GHS ${"%.2f".format(amount)}", 22f)
        }

        drawDivider()



        // ── Total ─────────────────────────────────────────────────────────
        val total = data["total"] as? Double ?: 0.0
        drawRow("TOTAL", "GHS ${"%.2f".format(total)}", 28f, bold = true)
        drawDivider()
        drawCodeLine("${data["transactionId"].toString()}${data["customerNumber"].toString()}")


        // ── Footer ────────────────────────────────────────────────────────
        drawCenter("Thank you for your payment!", 22f)
        drawCenter("Powered by COOPS", 20f)

        return bitmap
    }
}