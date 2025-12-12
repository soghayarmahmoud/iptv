import 'package:get/get.dart' as g;
import 'package:iptv/core/services/cache_helper.dart';
import 'package:iptv/core/services/favorite_service.dart';
import 'package:iptv/core/services/history_service.dart';
import 'package:iptv/core/services/secure_storage.dart';
import 'package:iptv/featuers/start/presentation/views/start_view.dart';

class LogoutService {
  static Future<void> forceLogout() async {
    // Clear all stored tokens and data
    await deleteToken();
    await deletePlaylistId();
    await deleteCustomId();
    
    // Clear favorites and history
    final favoriteService = FavoriteService(CacheHelper.instance);
    final historyService = HistoryService(CacheHelper.instance);
    await favoriteService.clearFavorites();
    await historyService.clearHistory();
    
    // Navigate to login screen
    g.Get.offAll(
      () => const StartView(),
      transition: g.Transition.fade,
      duration: const Duration(milliseconds: 400),
    );
  }
  

}
