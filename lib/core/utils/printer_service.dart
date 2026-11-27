import 'package:flutter/services.dart';
import 'package:mobilization_app/index.dart';
// lib/services/printer_service.dart

class PrinterService {
  static const MethodChannel _channel = MethodChannel('com.mobilization.msysconsult.mobilization_app/printer');

  Future<void> printReceipt(Map<String, dynamic> receiptData) async {
    await _channel.invokeMethod('printReceipt', receiptData);
  }
}