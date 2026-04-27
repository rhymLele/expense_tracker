import 'package:get_it/get_it.dart';

/// Base cho DI của từng feature.
/// Mỗi feature kế thừa và override các method cần thiết.
/// service_locator.dart chỉ cần thêm vào danh sách [_features].
abstract class BaseFeatureDI {
  void register(GetIt sl) {
    datasources(sl);
    repositories(sl);
    usecases(sl);
    blocs(sl);
    viewModels(sl);
  }

  void datasources(GetIt sl) {}
  void repositories(GetIt sl) {}
  void usecases(GetIt sl) {}
  void blocs(GetIt sl) {}
  void viewModels(GetIt sl) {}
}
