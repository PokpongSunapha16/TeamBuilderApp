import 'package:get/get.dart';
import '../controllers/team_controller.dart';
import '../services/api_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    Get.put<TeamController>(TeamController(), permanent: true);
  }
}
