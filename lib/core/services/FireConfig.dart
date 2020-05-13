import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';

class FireConfig {
  FireConfig(this.remoteConfig);

  static FireConfig get instance => GetIt.I.get<FireConfig>();

  final RemoteConfig remoteConfig;
  int get copyBook1 => remoteConfig.getInt('copy_book_1');

  static Future<FireConfig> initialize() async {
    var config = await RemoteConfig.instance;
    final defaults = <String, dynamic>{'copy_book_1': 0};
    await config.setDefaults(defaults);
    await config.fetch(expiration: const Duration(seconds: 0));
    await config.activateFetched();
    return FireConfig(config);
  }
}
