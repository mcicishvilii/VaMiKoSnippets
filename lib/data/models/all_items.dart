import '../../domain/models/all_items_domain.dart';

class MishosItem {
  final int id;
  final String title;
  final String description;
  final bool status;
  final String updatedAt;

  MishosItem(
      {required this.id,
      required this.title,
      required this.description,
      required this.status,
      required this.updatedAt});

  factory MishosItem.fromJson(Map<String, dynamic> json) {
    return MishosItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      updatedAt: json['updated_at'],
    );
  }
  MishosItemDomain toDomain() {
    return MishosItemDomain(
      id: id,
      title: title,
      description: description,
      status: status,
      updatedAt: updatedAt,
    );
  }
}
