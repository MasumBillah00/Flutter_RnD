class Attachment {
  final int attachmentRSN;
  final String attachmentDesc;
  final String attachmentStatusDesc;
  final int attachmentCode;
  final String attachmentTypeDesc;

  Attachment({
    required this.attachmentRSN,
    required this.attachmentDesc,
    required this.attachmentStatusDesc,
    required this.attachmentCode,
    required this.attachmentTypeDesc,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      attachmentRSN: json['attachmentRSN'],
      attachmentDesc: json['attachmentDesc'],
      attachmentStatusDesc: json['attachmentStatusDesc'],
      attachmentCode: json['attachmentCode'],
      attachmentTypeDesc: json['attachmentTypeDesc'],
    );
  }
}