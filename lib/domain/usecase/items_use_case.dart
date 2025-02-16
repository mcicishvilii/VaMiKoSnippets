import 'package:flutmisho/domain/models/all_items_domain.dart';
import 'package:flutmisho/domain/repository/all_items_repository.dart';
import 'package:flutmisho/utils/resource.dart';

class MishoUseCaseAll {
  final UserRepository repository;

  MishoUseCaseAll(this.repository);

  Stream<Resource<List<MishosItemDomain>>> call() {
    return repository.getAllMisho();
  }
}
