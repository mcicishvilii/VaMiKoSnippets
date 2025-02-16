import 'dart:async';
import 'package:flutmisho/domain/models/all_items_domain.dart';
import 'package:flutmisho/domain/usecase/items_use_case.dart';
import 'package:flutmisho/utils/resource.dart';
import 'package:flutter/foundation.dart';

class MishoViewModel extends ChangeNotifier {
  final MishoUseCaseAll useCase;

  Resource<List<MishosItemDomain>> _mishosUser = Loading(false);
  Resource<List<MishosItemDomain>> get mishosUser => _mishosUser;

  StreamSubscription? _subscription;

  MishoViewModel({required this.useCase}) {
    getAllUsers();
  }

  void getAllUsers() {
    _subscription?.cancel();
    _mishosUser = Loading(true);
    notifyListeners();

    _subscription = useCase().listen((resource) {
      _mishosUser = resource;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
