import 'package:flutmisho/data/service/items_service.dart';
import 'package:flutmisho/domain/models/all_items_domain.dart';
import 'package:flutmisho/domain/repository/all_items_repository.dart';
import 'package:flutmisho/utils/resource.dart';

class UserRepositoryImpl implements UserRepository {
  final MishosService service;

  UserRepositoryImpl(this.service);

  @override
  Stream<Resource<List<MishosItemDomain>>> getAllMisho() async* {
    yield Loading(true);
    try {
      final items = await service.fetchAll();
      final domainItems = items.map((item) => item.toDomain()).toList();
      yield Success(domainItems);
    } catch (e) {
      yield Error(e.toString());
    }
  }
}
