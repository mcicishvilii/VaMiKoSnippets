class ContentBlock {
  String type; // 'text' or 'code'
  String data;

  ContentBlock({required this.type, required this.data});

  Map<String, String> toJson() => {
        'type': type,
        'data': data,
      };
}
