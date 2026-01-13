/// API Constants for TheMealDB
class ApiConstants {
  ApiConstants._(); // Private constructor to prevent instantiation

  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Endpoints
  static const String searchByName = '/search.php';
  static const String filterByArea = '/filter.php';
  static const String lookupById = '/lookup.php';
  static const String categories = '/categories.php';
  static const String listAreas = '/list.php';
  static const String filterByCategory = '/filter.php';

  // Query Parameters
  static const String paramSearch = 's';
  static const String paramArea = 'a';
  static const String paramId = 'i';
  static const String paramCategory = 'c';
  static const String paramList = 'list';
}
