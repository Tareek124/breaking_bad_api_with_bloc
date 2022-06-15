class Quote {
  late String characterQuote;

  Quote.fromJson(Map<String, dynamic> json) {
    characterQuote = json['quote'];
  }
}
