import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'utils/theme_data.dart';
import 'view/discover/discover_screen.dart';
import 'view/home/home_screen.dart';
import 'view/profile/profile_screen.dart';
import 'view/search/search_screen.dart';

const int homeIndex = 0;
const int searchIndex = 1;
const int discoverIndex = 2;
const int profileIndex = 3;

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedScreenIndex = homeIndex;

  final List<int> _history = [];

  final GlobalKey<NavigatorState> _homeKey = GlobalKey();
  final GlobalKey<NavigatorState> _searchKey = GlobalKey();
  final GlobalKey<NavigatorState> _discoverKey = GlobalKey();
  final GlobalKey<NavigatorState> _profileKey = GlobalKey();

  // Keep instances of screens to prevent rebuilding
  late final Map<int, Widget> _screens = {
    homeIndex: _buildNavigator(_homeKey, homeIndex, const HomeScreen()),
    searchIndex: _buildNavigator(_searchKey, searchIndex, const SearchScreen()),
    discoverIndex: _buildNavigator(_discoverKey, discoverIndex, const DiscoverScreen()),
    profileIndex: _buildNavigator(_profileKey, profileIndex, const ProfileScreen()),
  };

  late final map = {
    homeIndex: _homeKey,
    searchIndex: _searchKey,
    discoverIndex: _discoverKey,
    profileIndex: _profileKey,
  };

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // No async keyword here
        if (didPop) {
          return; // Already handled by Navigator
        }

        final NavigatorState? currentSelectedTabNavigatorState =
            map[selectedScreenIndex]?.currentState;

        if (currentSelectedTabNavigatorState?.canPop() == true) {
          currentSelectedTabNavigatorState!.pop();
        } else if (_history.isNotEmpty) {
          setState(() {
            selectedScreenIndex = _history.last;
            _history.removeLast();
          });
        } else {
          // Handle app exit (e.g., show a confirmation dialog)
          showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Exit'),
              content: const Text('Are you sure you want to exit?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            ),
          ).then((shouldExit) {
            // Use then to handle the result
            if (shouldExit == true) {
              SystemNavigator.pop();
            }
          });
        }
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            // Use Stack to keep all screens in memory
            Positioned.fill(
              child: Stack(
                children: [
                  // Add all screens to the tree but only show the selected one
                  for (final entry in _screens.entries)
                    AnimatedOpacity(
                      opacity: selectedScreenIndex == entry.key ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Visibility(
                        visible: selectedScreenIndex == entry.key,
                        maintainState: true,
                        child: entry.value,
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
                height: 60,
                width: MediaQuery.sizeOf(context).width * 0.9,
                bottom: 10 + MediaQuery.viewPaddingOf(context).bottom,
                child: SizedBox(
                  height: 40,
                  child: _ButtonNavigation(
                      onTap: (index) {
                        setState(() {
                          _history.remove(selectedScreenIndex);
                          _history.add(selectedScreenIndex);
                          selectedScreenIndex = index;
                        });
                      },
                      selectedIndex: selectedScreenIndex),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildNavigator(GlobalKey key, int index, Widget child) {
    return Navigator(
      key: key,
      onGenerateRoute: (settings) => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Add a fade transition for pages within each tab
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  @override
  void initState() {
    // cartRepository.count();
    super.initState();
  }
}

class _ButtonNavigation extends StatelessWidget {
  final Function(int index) onTap;
  final int selectedIndex;

  const _ButtonNavigation({required this.onTap, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                LightThemeColors.tertiary.withValues(alpha: 0.8),
                LightThemeColors.secondary.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              _ButtonNavigationItem(
                iconFileName: 'home.svg',
                activeIconFileName: 'home_selected.svg',
                isActive: selectedIndex == homeIndex,
                onTap: () => onTap(homeIndex),
              ),
              _ButtonNavigationItem(
                iconFileName: 'search.svg',
                activeIconFileName: 'search_selected.svg',
                isActive: selectedIndex == searchIndex,
                onTap: () => onTap(searchIndex),
              ),
              _ButtonNavigationItem(
                iconFileName: 'compass.svg',
                activeIconFileName: 'compass_selected.svg',
                isActive: selectedIndex == discoverIndex,
                onTap: () => onTap(discoverIndex),
              ),
              _ButtonNavigationItem(
                iconFileName: 'user.svg',
                activeIconFileName: 'user_selected.svg',
                isActive: selectedIndex == profileIndex,
                onTap: () => onTap(profileIndex),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _ButtonNavigationItem extends StatelessWidget {
  final String iconFileName;
  final String activeIconFileName;
  final bool isActive;
  final Function() onTap;

  const _ButtonNavigationItem({
    required this.iconFileName,
    required this.activeIconFileName,
    required this.onTap,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
          onTap: onTap,
          child: isActive
              ? SvgPicture.asset(
                  'assets/img/icons/navbar/$activeIconFileName',
                  width: 32,
                  height: 32,
                  color: Colors.white,
                )
              : SvgPicture.asset(
                  'assets/img/icons/navbar/$iconFileName',
                  width: 24,
                  height: 24,
                  color: Colors.white,
                )),
    );
  }
}
