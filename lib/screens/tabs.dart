import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_internals/providers/favorites_provider.dart';
import 'package:flutter_internals/providers/filters_provider.dart';
import 'package:flutter_internals/screens/categories.dart';
import 'package:flutter_internals/screens/filters.dart';
import 'package:flutter_internals/screens/meals.dart';
import 'package:flutter_internals/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.luctoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;
  // final List<Meal> _favoriteMeals = [];
  // Map<Filter, bool> _selectedFilters = kInitialFilters;

  // void _showInfoMethod(String message) {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text(message),
  //   ));
  // }

  void _setScreen(String identifier) {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(
              // currentFilter: _selectedFilters,
              ),
        ),
      );
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => const TabsScreen()));
    }
  }

  // void _toggleMealFavoriteStatus(Meal meal) {
  //   final isExisting = _favoriteMeals.contains(meal);

  //   if (isExisting) {
  //     setState(() {
  //       _favoriteMeals.remove(meal);
  //     });
  //     _showInfoMethod('Meal removed from the favorites tab!');
  //   } else {
  //     setState(() {
  //       _favoriteMeals.add(meal);
  //       _showInfoMethod('Meal added to the favorites tab!');
  //     });
  //   }
  // }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filteredMealsProvider);

    Widget activePage = CategoriesScreen(
      // onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
    );
    var activePagetitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favortiteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(
        meals: favortiteMeals,
        // onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePagetitle = 'Favorities';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePagetitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorities'),
        ],
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
    );
  }
}
