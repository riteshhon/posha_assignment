/// App Strings Constants
/// Centralized string constants for the entire application
class AppStrings {
  AppStrings._(); // Private constructor to prevent instantiation

  // ============================================================================
  // App & Navigation
  // ============================================================================
  static const String appName = 'Posha';
  static const String recipes = 'Recipes';
  static const String favourites = 'Favourites';
  static const String recipeDetails = 'Recipe Details';
  static const String favouriteRecipes = 'Favourite Recipes';

  // ============================================================================
  // Common Actions
  // ============================================================================
  static const String retry = 'Retry';
  static const String clear = 'Clear';
  static const String clearAll = 'Clear All';
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String sort = 'Sort';
  static const String all = 'All';
  static const String apply = 'Apply';
  static const String cancel = 'Cancel';
  static const String close = 'Close';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String add = 'Add';
  static const String remove = 'Remove';
  static const String refresh = 'Refresh';

  // ============================================================================
  // Error Messages
  // ============================================================================
  static const String error = 'Error';
  static const String errorLoadingRecipes = 'Failed to load recipes';
  static const String errorLoadingRecipe = 'Failed to load recipe';
  static const String errorLoadingCategories = 'Failed to load categories';
  static const String errorLoadingAreas = 'Failed to load areas';
  static const String errorSearchingRecipes = 'Error searching recipes';
  static const String errorFilteringByArea = 'Error filtering by area';
  static const String errorFilteringByCategory = 'Error filtering by category';
  static const String errorGettingRecipe = 'Error getting recipe';
  static const String errorGettingCategories = 'Error getting categories';
  static const String errorGettingAreas = 'Error getting areas';
  static const String errorGettingFullRecipes = 'Error getting full recipes';
  static const String errorLoadingFavoriteRecipes =
      'Error loading favorite recipes';
  static const String repositoryNotProvided = 'Repository not provided';
  static const String pageNotFound = 'Page not found';

  // ============================================================================
  // Loading Messages
  // ============================================================================
  static const String loadingRecipe = 'Loading recipe...';
  static const String loadingRecipes = 'Loading recipes...';
  static const String applyingFilters = 'Applying filters...';
  static const String loading = 'Loading...';

  // ============================================================================
  // Empty States
  // ============================================================================
  static const String noRecipesFound = 'No recipes found';
  static const String tryAdjustingSearchOrFilters =
      'Try adjusting your search or filters';
  static const String noFavoritesYet = 'No Favorites Yet';
  static const String startAddingRecipesToFavorites =
      'Start adding recipes to your favorites\nby tapping the heart icon';
  static const String noIngredientsAvailable = 'No ingredients available';
  static const String noInstructionsAvailable = 'No instructions available';

  // ============================================================================
  // Recipe Details
  // ============================================================================
  static const String overview = 'Overview';
  static const String ingredients = 'Ingredients';
  static const String instructions = 'Instructions';
  static const String recipeInfo = 'Recipe Info';
  static const String videoTutorial = 'Video Tutorial';
  static const String category = 'Category';
  static const String cuisine = 'Cuisine';
  static const String items = 'items';
  static const String itemsNeeded = 'items needed';

  // ============================================================================
  // Filter & Sort
  // ============================================================================
  static const String filterByCategory = 'Filter by Category';
  static const String filterByArea = 'Filter by Area';
  static const String sortByName = 'Sort by Name';
  static const String sortAZ = 'A-Z';
  static const String sortZA = 'Z-A';
  static const String sortNone = 'None';
  static const String activeFilters = 'Active Filters';
  static const String noActiveFilters = 'No active filters';

  // ============================================================================
  // Favorites
  // ============================================================================
  static const String addToFavorites = 'Add to favorites';
  static const String removeFromFavorites = 'Remove from favorites';
  static const String favorite = 'Favorite';
  static const String unfavorite = 'Unfavorite';

  // ============================================================================
  // Search
  // ============================================================================
  static const String searchRecipes = 'Search recipes';
  static const String searchHint = 'Search by recipe name...';
  static const String clearSearch = 'Clear search';

  // ============================================================================
  // View Modes
  // ============================================================================
  static const String gridView = 'Grid View';
  static const String listView = 'List View';

  // ============================================================================
  // Tooltips
  // ============================================================================
  static const String tooltipToggleView = 'Toggle view mode';
  static const String tooltipSort = 'Sort recipes';
  static const String tooltipFilter = 'Filter recipes';
  static const String tooltipClearFilters = 'Clear all filters';
  static const String tooltipFavorite = 'Add to favorites';
  static const String tooltipUnfavorite = 'Remove from favorites';
  static const String tooltipZoomImage = 'Tap to zoom image';
}
