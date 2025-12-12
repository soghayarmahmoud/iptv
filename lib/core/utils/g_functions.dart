import 'dart:ui';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iptv/core/services/cache_helper.dart';
import 'package:iptv/core/services/favorite_service.dart';
import 'package:iptv/core/services/history_service.dart';

bool isDeviceLanguageArabic() {
    try {
      final deviceLocale = PlatformDispatcher.instance.locale;
      return deviceLocale.languageCode == 'ar';
    } catch (e) {
      // Default to Arabic if detection fails
      return true;
    }
  }
  Future<void> cleanAllStorage()async {
   await FlutterSecureStorage().deleteAll();

    // Clear favorites and history
    final favoriteService = FavoriteService(CacheHelper.instance);
    final historyService = HistoryService(CacheHelper.instance);
    await favoriteService.clearFavorites();
    await historyService.clearHistory();
}
