class ReceiptItem {
  final String name;
  final String qty;
  final String price;

  ReceiptItem({required this.name, required this.qty, required this.price});

  Map<String, String> toMap() => {'name': name, 'qty': qty, 'price': price};
}

class PaymentReceipt {
  final String merchantName;
  final String transactionId;
  final String dateTime;
  final List<ReceiptItem> items;
  final String subtotal;
  final String total;

  PaymentReceipt({
    required this.merchantName,
    required this.transactionId,
    required this.dateTime,
    required this.items,
    required this.subtotal,
    required this.total,
  });
}
