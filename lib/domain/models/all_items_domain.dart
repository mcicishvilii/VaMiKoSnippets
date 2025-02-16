class MishosItemDomain {
  final int id;
  final String title;
  final String description;
  final bool status;
  final String updatedAt;

  MishosItemDomain(
      {required this.id,
      required this.title,
      required this.description,
      required this.status,
      required this.updatedAt});
}
