enum APIPath {
  login,
  refreshToken,
  profile,
  updateProfile,
  register,
  events,
  eventsById,
  gallery,
  galleryById,
  teams,
  featuredEvent,
  notification,
  popup
}

// const String imageUrl = "http://192.168.1.73:3000";

class APIPathHelper {
  // static const String baseUrlDev = 'https://nafausa-server.onrender.com/api';
  static const String baseUrlProd = 'https://appserver.nafausa.org/api';
  static const String baseUrlDev = 'http://localhost:3000/api';
  static const String imageUrlProd = "https://appserver.nafausa.org";
  static const String imageUrlDev = "http://localhost:3000";
  // static const String baseUrlProd = 'https://nafausa-server.onrender.com/api';

  static String authAPIs(APIPath path, {String? keyword, String? id}) {
    switch (path) {
      case APIPath.login:
        return '/auth/login';
      case APIPath.register:
        return '/auth/register';
      default:
        return '/';
    }
  }

  static String profileAPIs(APIPath path, {String? keyword, String? id}) {
    switch (path) {
      case APIPath.profile:
        return '/member/profile';
      case APIPath.updateProfile:
        return '/member/profile/$id';
      default:
        return '/';
    }
  }

  static String galleryAPIs(APIPath path, {String? keyword, String? id}) {
    switch (path) {
      case APIPath.gallery:
        return '/gallery/all';
      case APIPath.galleryById:
        return '/gallery/$id';
      default:
        return '/';
    }
  }

  static String teamsAPIs(APIPath path, {String? keyword, String? id}) {
    switch (path) {
      case APIPath.teams:
        return '/teams';
      default:
        return '/';
    }
  }

  static String eventAPIs(APIPath path, {String? keyword, String? id}) {
    switch (path) {
      case APIPath.featuredEvent:
        return '/events/featured';
      case APIPath.events:
        return '/events/all';
      case APIPath.eventsById:
        return '/events/$id';
      case APIPath.popup:
        return '/events/banner/popup';
      default:
        return '/';
    }
  }

  static String notificationAPIs(APIPath path, {String? keyword, String? id}) {
    switch (path) {
      case APIPath.notification:
        return '/notification/all';
      default:
        return '/';
    }
  }

  static String _buildQueryParams(Map<String, String?> params) {
    final queryParams = params.entries
        .where((entry) => entry.value != null)
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');

    return queryParams;
  }
}
