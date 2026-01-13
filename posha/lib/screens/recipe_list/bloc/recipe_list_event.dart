import 'package:equatable/equatable.dart';

/// Recipe List Events
abstract class RecipeListEvent extends Equatable {
  const RecipeListEvent();

  @override
  List<Object> get props => [];
}

/// Initial event to load recipes
class RecipeListInitialized extends RecipeListEvent {
  const RecipeListInitialized();
}

/// Search recipes by name
class RecipeListSearchChanged extends RecipeListEvent {
  final String query;

  const RecipeListSearchChanged(this.query);

  @override
  List<Object> get props => [query];
}

/// Filter by category
class RecipeListCategoryFilterChanged extends RecipeListEvent {
  final String? category;

  const RecipeListCategoryFilterChanged(this.category);

  @override
  List<Object> get props => [category ?? ''];
}

/// Filter by area
class RecipeListAreaFilterChanged extends RecipeListEvent {
  final String? area;

  const RecipeListAreaFilterChanged(this.area);

  @override
  List<Object> get props => [area ?? ''];
}

/// Clear all filters
class RecipeListFiltersCleared extends RecipeListEvent {
  const RecipeListFiltersCleared();
}

/// Toggle view mode (grid/list)
class RecipeListViewModeToggled extends RecipeListEvent {
  const RecipeListViewModeToggled();
}

/// Sort recipes
class RecipeListSortChanged extends RecipeListEvent {
  final RecipeListSortType sortType;

  const RecipeListSortChanged(this.sortType);

  @override
  List<Object> get props => [sortType];
}

/// Refresh recipes
class RecipeListRefreshed extends RecipeListEvent {
  const RecipeListRefreshed();
}

/// Toggle filters visibility
class RecipeListFiltersToggled extends RecipeListEvent {
  const RecipeListFiltersToggled();
}

/// Open filter panel
class RecipeListFilterPanelOpened extends RecipeListEvent {
  const RecipeListFilterPanelOpened();
}

/// Close filter panel
class RecipeListFilterPanelClosed extends RecipeListEvent {
  const RecipeListFilterPanelClosed();
}

/// Enum for sort types
enum RecipeListSortType { none, nameAsc, nameDesc }
