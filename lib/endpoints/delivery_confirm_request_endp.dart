class DeliveryConfirmRequest {
  final int id;
  final String receivedBy;
  final String timestamp;

  DeliveryConfirmRequest({
    required this.id,
    required this.receivedBy,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'received_by': receivedBy,
    'timestamp': timestamp,
  };
}
