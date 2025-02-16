import 'package:flutmisho/domain/models/all_items_domain.dart';
import 'package:flutmisho/utils/resource.dart';

abstract class UserRepository {
  Stream<Resource<List<MishosItemDomain>>> getAllMisho();
}
