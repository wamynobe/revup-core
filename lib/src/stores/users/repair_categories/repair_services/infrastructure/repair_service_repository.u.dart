import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../../shared/const.dart';
import '../../../../infrastructure/infrastructure.dart';
import '../../../../models/store_failure.dart';
import '../../../users.dart';

class RepairServiceRepository extends Store<RepairService> {
  RepairServiceRepository(
    super.store,
    RepairCategory category,
    AppUser user,
  )   : categoryName = category.name,
        uid = user.maybeMap(
          provider: (value) => value.uuid,
          orElse: () => throw const FormatException(),
        );

  final String categoryName;
  final String uid;
  CollectionReference<Map<String, dynamic>> get services => store
      .collection(kPathUserCollection)
      .doc(uid)
      .collection(kPathProviderCategoryDocument)
      .doc(categoryName)
      .collection(kPathProviderCategoryServiceDocument);

  DocumentReference<Map<String, dynamic>> service(String id) =>
      services.doc(id);
  @override
  CollectionReference<Map<String, dynamic>> collection() => services;

  @override
  DocumentReference<Map<String, dynamic>> doc(String id) => service(id);

  @override
  Future<Either<StoreFailure, RepairService>> get(String id) =>
      auxGet(id, RepairService.fromJson);

  @override
  String getId(RepairService data) => data.name;

  @override
  FutureOr<Either<StoreFailure, Unit>> update(
    RepairService newData,
    IList<String> fields,
  ) =>
      auxUpdate(newData, fields, nil());
}
