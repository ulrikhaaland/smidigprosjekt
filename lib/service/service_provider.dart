import 'package:smidigprosjekt/service/instance_style_service.dart';
import 'package:smidigprosjekt/style/app_style.dart';

import 'screen_service.dart';

class ServiceProvider {
  static final ServiceProvider _instance = ServiceProvider._();

  static ServiceProvider get instance => _instance;

  ServiceProvider._();

  ScreenService screenService;
  InstanceStyleService instanceStyleService;
}
