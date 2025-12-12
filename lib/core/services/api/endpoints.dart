// ignore_for_file: file_names
abstract class Endpoints {
  static const String baseUrl = 'https://api.beeplayer1.com/';
  static const String login = 'auth/customer/login';
  static String getIptvCategories(String playlistId) =>
      "customers/iptv/categories?playlist_id=$playlistId";
  static String getIptvChannels(String categoryId, String playlistId) =>
      "customers/iptv/channels?category_id=$categoryId&playlist_id=$playlistId";
  static String getMovieCategories(String playlistId) =>
      "customers/iptv/vod/categories?playlist_id=$playlistId";
  static String getMovieItems(String categoryId, String playlistId) =>
      "customers/iptv/vod/content?category_id=$categoryId&playlist_id=$playlistId";
  static String getSeriesCategories(String playlistId) =>
      "customers/iptv/series/categories?playlist_id=$playlistId";
  static String getSeriesItem(String categoryId, String playlistId) =>
      "customers/iptv/series/content?category_id=$categoryId&playlist_id=$playlistId";
  static String getSeriesDetail(String seriesId, String playlistId) =>
      "customers/iptv/series/$seriesId/episodes?playlist_id=$playlistId";
  static String getEposideStream(
    String seriesId,
    String playlistId,
    String eposideId,
  ) =>
      "customers/iptv/series/$seriesId/episodes/$eposideId/stream?playlist_id=$playlistId";

  static String changePassword = "customers/change-password";
  static String getPlaylists = "customers/playlists";
  static String convertUrl(String url) => 'api/stream/hls?url=$url';
}


