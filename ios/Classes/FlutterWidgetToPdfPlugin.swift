import Flutter
import UIKit

public class FlutterWidgetToPdfPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_widget_to_pdf", binaryMessenger: registrar.messenger())
        let instance = FlutterWidgetToPdfPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String:Any],
              let imageBytes = args["imageBytes"] as? FlutterStandardTypedData else {
                  result(FlutterError(code: "Invalid argument", message: "imageBytes is null", details: nil))
                  return
              }
        let filename = args["filename"] as? String ?? "\(Int(Date().timeIntervalSince1970)).pdf"
        
        guard let image = UIImage(data: imageBytes.data) else {
            result(FlutterError(code: "Image error", message: "Unable to decode image", details: nil))
            return
        }
        
        let pdfData = NSMutableData()
        let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData)!
        var mediaBox = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        guard let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil) else {
            result(FlutterError(code: "PDF error", message: "Unable to create PDF context", details: nil))
            return
        }
        pdfContext.beginPage(mediaBox: &mediaBox)
        pdfContext.draw(image.cgImage!, in: mediaBox)
        pdfContext.endPage()
        pdfContext.closePDF()
        
        let tmpUrl = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        do {
            try pdfData.write(to: tmpUrl)
        } catch {
            debugPrint("Error saving file: \(error)")
            result(false)
        }
        switch call.method {
        case "SAVE_PDF":
            if #available(iOS 14.0, *) {
                let picker = UIDocumentPickerViewController(forExporting: [tmpUrl])
                picker.shouldShowFileExtensions = true
                UIApplication.shared.keyWindow?.rootViewController?.present(picker, animated: true, completion: nil)
            } else {
                sharePdf(tmpUrl)
            }
            result(true)
        case "SHARE_PDF":
            sharePdf(tmpUrl)
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func sharePdf(_ url: URL) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
}
