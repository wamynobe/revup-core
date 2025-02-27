import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../shared/const.dart';
import '../../../infrastructure/infrastructure.dart';
import '../../../models/store_failure.dart';
import '../../models/app_user.dart';
import '../models/repair_category.dart';

class RepairCategoryRepository extends Store<RepairCategory> {
  RepairCategoryRepository(super.store, AppUser provider)
      : id = provider.maybeMap(
          provider: (p) => p.uuid,
          orElse: () => throw const FormatException(),
        );

  final String id;

  CollectionReference<Map<String, dynamic>> get categories => store
      .collection(kPathUserCollection)
      .doc(id)
      .collection(kPathProviderCategoryDocument);

  DocumentReference<Map<String, dynamic>> category(String id) =>
      categories.doc(id);

  @override
  CollectionReference<Map<String, dynamic>> collection() => categories;

  @override
  DocumentReference<Map<String, dynamic>> doc(String id) => category(id);

  @override
  Future<Either<StoreFailure, RepairCategory>> get(String id) =>
      auxGet(id, RepairCategory.fromJson);

  @override
  String getId(RepairCategory data) => data.name;

  @override
  FutureOr<Either<StoreFailure, Unit>> update(
    RepairCategory newData,
    IList<String> fields,
  ) =>
      auxUpdate(newData, fields, nil());
}
