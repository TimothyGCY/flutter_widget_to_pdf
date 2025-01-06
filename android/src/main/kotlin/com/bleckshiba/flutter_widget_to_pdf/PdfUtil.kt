package com.bleckshiba.flutter_widget_to_pdf

import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import androidx.core.content.FileProvider
import androidx.core.net.toUri
import com.itextpdf.io.image.ImageDataFactory
import com.itextpdf.kernel.geom.PageSize
import com.itextpdf.kernel.pdf.PdfDocument
import com.itextpdf.kernel.pdf.PdfWriter
import com.itextpdf.layout.Document
import com.itextpdf.layout.element.Image
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream

object PdfUtil {

    private const val MIME_TYPE = "application/pdf"

    /**
     * Convert imageByte to pdfByte
     */
    fun imageToPdf(imageBytes: ByteArray): ByteArray {
        val bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
        val imageData = stream.toByteArray()

        // Create PDF
        val outputStream = ByteArrayOutputStream()
        val pdfWriter = PdfWriter(outputStream)
        val pdfDocument = PdfDocument(pdfWriter)
        val document = Document(pdfDocument)

        // Add image to PDF
        val image = Image(ImageDataFactory.create(imageData))
        image.scaleToFit(PageSize.A4.width, PageSize.A4.height)
        val x = (PageSize.A4.width - image.imageScaledWidth) / 2
        val y = (PageSize.A4.height - image.imageScaledHeight) / 2
        image.setFixedPosition(x, y);
        document.add(image);
        document.close()

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
            put(MediaStore.MediaColumns.MIME_TYPE, MIME_TYPE)
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

    fun sharePdf(ctx: Context, pdfBytes: ByteArray, filename: String) {
        val file = File(ctx.cacheDir, filename)
        FileOutputStream(file).use { it.write(pdfBytes) }
        val pdfUri = FileProvider.getUriForFile(ctx, "${ctx.packageName}.file_share_provider", file)
        val shareIntent = Intent(Intent.ACTION_SEND).apply {
            action = Intent.ACTION_SEND
            putExtra(Intent.EXTRA_STREAM, pdfUri)
            type = MIME_TYPE
        }
        shareIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        val chooser = Intent.createChooser(shareIntent, null)
        chooser.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

        val resInfoList =
            ctx.packageManager.queryIntentActivities(chooser, PackageManager.MATCH_DEFAULT_ONLY)
        resInfoList.forEach { resolveInfo ->
            val packageName = resolveInfo.activityInfo.packageName
            ctx.grantUriPermission(
                packageName,
                pdfUri,
                Intent.FLAG_GRANT_WRITE_URI_PERMISSION or Intent.FLAG_GRANT_READ_URI_PERMISSION,
            )

        }
        ctx.startActivity(chooser)
    }
}