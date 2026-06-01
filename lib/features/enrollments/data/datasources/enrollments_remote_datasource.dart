import 'dart:developer' as dev;

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_response_mapper.dart';
import '../../../../core/network/base_remote_datasource.dart';
import '../../../../core/network/http_method.dart';
import '../models/enrollment_model.dart';

abstract class EnrollmentsRemoteDataSource {
  Future<EnrollmentModel?> getActive();
  Future<List<EnrollmentModel>> getMyEnrollments();
  Future<void> completeDay(String enrollmentId);
  Future<void> cancel(String enrollmentId);
  Future<void> reorderQueue(List<String> orderedIds);
}

class EnrollmentsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements EnrollmentsRemoteDataSource {

  @override
  Future<EnrollmentModel?> getActive() async {
    try {
      final res = await baseSendRequest(ApiConstants.enrollmentsActive, HttpMethod.get);
      if (res == null || res['data'] == null) return null;
      return ApiResponseMapper.single(res, EnrollmentModel.fromJson);
    } catch (e, st) {
      dev.log('getActive error: $e', stackTrace: st, name: 'Enrollments');
      return null;
    }
  }

  @override
  Future<List<EnrollmentModel>> getMyEnrollments() async {
    try {
      final res = await baseSendRequest(ApiConstants.myEnrollments, HttpMethod.get);
      final raw = res['data'];
      if (raw is List) {
        return raw
            .map((e) => EnrollmentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return ApiResponseMapper.paginated(res, EnrollmentModel.fromJson).items;
    } catch (e, st) {
      dev.log('getMyEnrollments error: $e', stackTrace: st, name: 'Enrollments');
      rethrow;
    }
  }

  @override
  Future<void> completeDay(String enrollmentId) => baseSendRequest(
        ApiConstants.enrollmentCompleteDay(enrollmentId),
        HttpMethod.post,
      );

  @override
  Future<void> cancel(String enrollmentId) => baseSendRequest(
        ApiConstants.enrollmentCancel(enrollmentId),
        HttpMethod.delete,
      );

  @override
  Future<void> reorderQueue(List<String> orderedIds) => baseSendRequest(
        ApiConstants.enrollmentQueueReorder,
        HttpMethod.put,
        data: {'orderedIds': orderedIds},
      );
}
