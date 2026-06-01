import '../../../../core/network/api_constants.dart';
import '../../../../core/network/base_remote_datasource.dart';
import '../../../../core/network/http_method.dart';

abstract class OnboardingRemoteDataSource {
  Future<void> completeTour(String tourType);
}

class OnboardingRemoteDataSourceImpl extends BaseRemoteDataSource
    implements OnboardingRemoteDataSource {
  @override
  Future<void> completeTour(String tourType) => baseSendRequest(
        ApiConstants.updateOnboarding,
        HttpMethod.patch,
        data: {'tourType': tourType},
      );
}
