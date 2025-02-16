import '../../domain/models/all_items_domain.dart';

class MishosItem {
  final String itemName;
  final String description;
  final String url;

  MishosItem({
    required this.itemName,
    required this.description,
    required this.url,
  });

  factory MishosItem.fromJson(Map<String, dynamic> json) {
    return MishosItem(
      itemName: json['itemName'],
      description: json['description'],
      url: json['url'],
    );
  }
  MishosItemDomain toDomain() {
    return MishosItemDomain(
      itemName: itemName,
      description: description,
      url: url,
    );
  }
}
