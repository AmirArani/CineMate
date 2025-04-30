import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../gen/assets.gen.dart';
import '../../utils/routes/route_data.dart';
import '../../utils/theme_data.dart';
import '../common_widgets/shimmers.dart';
import 'bloc/profile_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Scaffold(
            body: (state is ProfileLoggedOutState)
                ? LoggedOutView()
                : (state is ProfileLoggedInState)
                    ? LoggedInView(state: state)
                    : SizedBox() //TODO: add failed View

            );
      },
    );
  }
}

class LoggedOutView extends StatelessWidget {
  const LoggedOutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Spacer(),
        Assets.img.loginIllustration.image(height: 300, isAntiAlias: true),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            'Log in to create and edit your movie lists, track your favorites, and explore more personalized features!',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500, color: LightThemeColors.primary),
          ),
        ),
        SizedBox(height: 18),
        ElevatedButton.icon(
          onPressed: () => BlocProvider.of<ProfileBloc>(context).add(LoginBtnPressedEvent()),
          label: Text(
            "Login",
            style: TextStyle(color: LightThemeColors.onPrimary),
          ),
          icon: Assets.img.icons.profile.login
              .svg(theme: SvgTheme(currentColor: LightThemeColors.onPrimary)),
          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(LightThemeColors.primary)),
        ),
        Spacer(),
      ],
    );
  }
}

class LoggedInView extends StatelessWidget {
  final ProfileLoggedInState state;

  const LoggedInView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final bool loading = state.account == null;
    final bool failed = state.loadingAccountFailed;

    return failed
        ? LoggedInFailedView()
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  flex: 1,
                  child: _TopPortion(
                    path: loading ? '' : state.account!.avatarPath ?? '',
                    hash: loading ? '' : state.account!.gravatarHash ?? '',
                  )),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      loading
                          ? defBoxShim(height: 28, width: 100, margin: EdgeInsets.zero)
                          : Text(
                              state.account!.name ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                      const SizedBox(height: 4),
                      loading
                          ? defBoxShim(height: 20, width: 150, margin: EdgeInsets.zero)
                          : Text('${state.account!.userName} (${state.account!.id})'),
                      Spacer(),
                      loading
                          ? _buildItemShimmer()
                          : ProfileListItem(
                              title: 'Favorites',
                              icon: Assets.img.icons.profile.favorites,
                              onTap: () => FavoritesScreenRouteData().push(context)),
                      loading
                          ? _buildItemShimmer()
                          : ProfileListItem(
                              title: 'WatchList',
                              icon: Assets.img.icons.profile.bookmark,
                              onTap: () => WatchListScreenRouteData().push(context)),
                      loading
                          ? _buildItemShimmer()
                          : ProfileListItem(
                              title: 'Ratings',
                              icon: Assets.img.icons.profile.star,
                              onTap: () => RatingScreenRouteData().push(context),
                            ),
                      loading
                          ? _buildItemShimmer()
                          : ProfileListItem(
                              title: 'Lists',
                              icon: Assets.img.icons.profile.list,
                              onTap: () => ListsScreenRouteData().push(context),
                            ),
                      loading
                          ? _buildItemShimmer()
                          : ProfileListItem(
                              title: 'Recommendations',
                              icon: Assets.img.icons.person.sparkles,
                              onTap: () => RecommendationsScreenRouteData().push(context),
                            ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: Row(
                          spacing: 12,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: ProfileListItem(
                                  title: 'Edit Profile',
                                  icon: Assets.img.icons.profile.userEdit,
                                  small: true,
                                  onTap: () async => await launchUrl(
                                      Uri.parse("https://www.themoviedb.org/settings/profile"),
                                      mode: LaunchMode.inAppBrowserView)),
                            ),
                            Expanded(
                              child: ProfileListItem(
                                  title: 'Setting',
                                  icon: Assets.img.icons.profile.settings,
                                  small: true,
                                  onTap: () async => await launchUrl(
                                      Uri.parse("https://www.themoviedb.org/settings/account"),
                                      mode: LaunchMode.inAppBrowserView)),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      _LogoutBtn(),
                      SizedBox(height: 12),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Powered by '),
                          GestureDetector(
                              onTap: () async => await launchUrl(
                                  Uri.parse("https://www.themoviedb.org/"),
                                  mode: LaunchMode.inAppBrowserView),
                              child: Assets.img.icons.tmdbLong.image(width: 160)),
                        ],
                      ),
                      Spacer(flex: 4),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  Shimmer _buildItemShimmer() {
    return defShim(
      child: ProfileListItem(
        title: '',
        icon: Assets.img.icons.profile.favorites,
        onTap: () {},
      ),
    );
  }
}

class ProfileListItem extends StatelessWidget {
  final String title;
  final SvgGenImage icon;
  final Function onTap;
  final bool small;

  const ProfileListItem(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap,
      this.small = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: small ? 0 : 12, vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(14)),
          boxShadow: [
            BoxShadow(
                color: Color(0x0601B4E4), blurRadius: 3, spreadRadius: 0, offset: Offset(0, 4))
          ],
        ),
        child: Row(
          spacing: 8,
          mainAxisAlignment: small ? MainAxisAlignment.center : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon.svg(theme: SvgTheme(currentColor: LightThemeColors.gray)),
            Text(
              title,
              style:
                  TextStyle(fontSize: 16, fontWeight: small ? FontWeight.normal : FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}

class LoggedInFailedView extends StatelessWidget {
  const LoggedInFailedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Assets.img.errorState2.image(width: 200, height: 200, isAntiAlias: true),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            'Loading your profile failed. Please check your internet connection and try again or sign-out',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500, color: LightThemeColors.primary),
          ),
        ),
        Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: () => BlocProvider.of<ProfileBloc>(context).add(ProfileLoadEvent()),
              label: Text(
                "Retry",
                style: TextStyle(),
              ),
              icon: Assets.img.icons.profile.reload.svg(),
              style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(LightThemeColors.primary)),
            ),
            _LogoutBtn(),
          ],
        ),
        Spacer(),
      ],
    );
  }
}

class _LogoutBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to Logout?'),
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
          BlocProvider.of<ProfileBloc>(context).add(LogoutBtnPressedEvent());
        }
      }),
      label: Text(
        "Logout",
        style: TextStyle(color: Colors.red.shade900),
      ),
      icon: Assets.img.icons.profile.logout.svg(theme: SvgTheme(currentColor: Colors.red.shade900)),
      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red.shade100)),
    );
  }
}

class _Gravatar extends StatelessWidget {
  final String hash;

  const _Gravatar({required this.hash});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: LightThemeColors.gray.withValues(alpha: 0.5),
          )
        ],
      ),
      child: CachedNetworkImage(
        height: 150,
        width: 150,
        imageUrl: "https://www.gravatar.com/avatar/$hash?s=200&d=identicon",
        fadeInCurve: Curves.easeIn,
        placeholder: (context, url) =>
            defBoxShim(height: 150, width: 150, margin: EdgeInsets.zero, radius: 150),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade300,
          child: const Center(child: Icon(Icons.error)),
        ),
      ),
    );
  }
}

class _TopPortion extends StatelessWidget {
  final String path;
  final String hash;

  const _TopPortion({required this.path, required this.hash});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [LightThemeColors.secondary, LightThemeColors.tertiary]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: LightThemeColors.gray.withValues(alpha: 0.5),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: CachedNetworkImage(
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                  imageUrl: 'https://image.tmdb.org/t/p/original$path',
                  fadeInCurve: Curves.easeIn,
                  placeholder: (context, url) => _Gravatar(hash: hash),
                  errorWidget: (context, url, error) => _Gravatar(hash: hash),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
