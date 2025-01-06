package com.bleckshiba.flutter_widget_to_pdf

import android.content.ContentValues
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.pdf.PdfDocument
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import androidx.core.net.toUri
import java.io.ByteArrayOutputStream
import java.io.File

object PdfUtil {

    private val A4_SIZE = intArrayOf(595, 841)

    /**
     * Convert imageByte to pdfByte
     */
    fun imageToPdf(ctx: Context, imageBytes: ByteArray): ByteArray {
        val bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
        val imageData = stream.toByteArray()

        // Create PDF
        val outputStream = ByteArrayOutputStream()
        val pdfDocument = PdfDocument()
        val pageInfo = PdfDocument.PageInfo.Builder(A4_SIZE[0], A4_SIZE[1], 1).create()
        val page = pdfDocument.startPage(pageInfo)
        page.canvas.drawBitmap(bitmap, (page.canvas.width - bitmap.width) / 2f, 0f, null)
        pdfDocument.finishPage(page)
        pdfDocument.writeTo(outputStream)
        pdfDocument.close()

        // Return PDF as ByteArray
        return outputStream.toByteArray()
    }

    /**
     * Save PDF to Downloads folder
     */
    fun savePdf(ctx: Context, filename: String, pdfBytes: ByteArray) {
        print(filename)
        val resolver = ctx.contentResolver
        val contentValues = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, filename)
            put(MediaStore.MediaColumns.MIME_TYPE, "application/pdf")
            put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
        }
        val uri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, contentValues)
        } else {
            val dir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
            val file = File(dir, filename)
            file.toUri()
        }
        uri?.let {
            resolver.openOutputStream(it).use { outputStream ->
                outputStream?.write(pdfBytes)
            }
        }
    }

    fun sharePdf() {}

}