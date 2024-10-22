


class Document {
  final String documentDesc;
  final int documentRSN;

  Document({required this.documentDesc, required this.documentRSN});

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      documentDesc: json['documentDesc'],
      documentRSN: json['documentRSN'],
    );
  }
}