import 'package:flutter/widgets.dart';
import 'package:language_parser_desktop/services/service_manager.dart';

class ServiceProvider extends InheritedWidget {
  final ServiceManager _serviceManager;

  const ServiceProvider(this._serviceManager, {super.key, required super.child});

  static ServiceProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ServiceProvider>();
  }

  ServiceManager get serviceManager => _serviceManager;

  @override
  bool updateShouldNotify(ServiceProvider oldWidget) {
    return _serviceManager != oldWidget._serviceManager;
  }
}
