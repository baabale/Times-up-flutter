import 'package:parental_control/common_widgets/show_logger.dart';
import 'package:parental_control/services/app_usage_local_service.dart';

abstract class AppService {
  Future<void> getAppUsageService();
}

class AppUsageService implements AppService {
  List<AppUsageInfo> _info = <AppUsageInfo>[];

  List<AppUsageInfo> get info => _info;

  @override
  Future<void> getAppUsageService() async {
    try {
      var endDate = DateTime.now();
      var startDate = endDate.subtract(Duration(hours: 1));
      var infoList =
          await AppUsage.getAppUsage(startDate, endDate, useMock: false);
      _info = infoList;
    } on AppUsageException catch (exception) {
      JHLogger.$.e(exception);
    }
  }
}
