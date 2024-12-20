class BaseUrl {
  static const url = String.fromEnvironment('BASE_URL', defaultValue: 'https://api-salesfast-gateway-uat.globalx.com.vn');
}

class PortalApi {
  static const login = "/auth/login";
  static const upload = "/booking/upload";
}