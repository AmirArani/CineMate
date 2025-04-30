import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/theme_data.dart';

Shimmer defShim({required Widget child}) {
  return Shimmer.fromColors(
    baseColor: LightThemeColors.tertiary.withValues(alpha: .2),
    highlightColor: LightThemeColors.secondary.withValues(alpha: .1),
    child: child,
  );
}

Shimmer defBoxShim(
    {required double height, required double? width, EdgeInsets? margin, double radius = 12}) {
  return defShim(
      child: Container(
    width: width,
    height: height,
    margin: margin ?? const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      color: Colors.grey,
    ),
  ));
}

Container defBox(
    {required double width, required double height, EdgeInsets? margins, double radius = 12}) {
  return Container(
    width: width,
    height: height,
    margin: margins ?? const EdgeInsets.all(0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      color: Colors.grey,
    ),
  );
}

class ReviewItemShimmer extends StatelessWidget {
  const ReviewItemShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                height: 48,
                width: 48,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 20,
              width: 83,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Container(
          height: 20,
          width: 300,
          margin: const EdgeInsets.only(left: 15),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.grey,
          ),
        ),
        Container(
          height: 20,
          width: 110,
          margin: const EdgeInsets.only(left: 15),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.grey,
          ),
        ),
        Container(
          height: 20,
          width: 200,
          margin: const EdgeInsets.only(left: 15),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.grey,
          ),
        ),
        Container(
          height: 20,
          width: 200,
          margin: const EdgeInsets.only(left: 15),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(160)), color: Colors.grey),
        ),
        const SizedBox(height: 12),
        const Divider(),
      ],
    );
  }
}

class ReviewListShimmer extends StatelessWidget {
  const ReviewListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: defShim(
        child: const Column(
          children: [
            ReviewItemShimmer(),
            ReviewItemShimmer(),
            ReviewItemShimmer(),
          ],
        ),
      ),
    );
  }
}

class VerticalListShimmer extends StatelessWidget {
  const VerticalListShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
        return defBoxShim(
          height: 165,
          width: 100,
          margin: const EdgeInsets.fromLTRB(8, 16, 8, 0),
        );
      },
    );
  }
}

class PersonItemShimmer extends StatelessWidget {
  const PersonItemShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        defBox(
          width: 66.72,
          height: 100,
          radius: 34,
          margins: const EdgeInsets.fromLTRB(9, 0, 9, 0),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            defBox(width: 100, height: 20),
            const SizedBox(height: 10),
            defBox(width: 150, height: 18),
          ],
        )
      ],
    );
  }
}

class GenresShimmer extends StatelessWidget {
  const GenresShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      clipBehavior: Clip.hardEdge,
      spacing: 5,
      runSpacing: 5,
      children: [
        defShim(
            child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xff858585),
          ),
          child: const Text(
            '                       ',
            style: TextStyle(color: Colors.white, fontSize: 15),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        )),
        defShim(
            child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xff858585),
          ),
          child: const Text(
            '               ',
            style: TextStyle(color: Colors.white, fontSize: 15),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        )),
        defShim(
            child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xff858585),
          ),
          child: const Text(
            '            ',
            style: TextStyle(color: Colors.white, fontSize: 15),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        )),
        defShim(
            child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xff858585),
          ),
          child: const Text(
            '                      ',
            style: TextStyle(color: Colors.white, fontSize: 15),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        )),
        // defBoxShim(width: 50, height: 25, radius: 5),
        // defBoxShim(width: 120, height: 25, radius: 5),
        // defBoxShim(width: 80, height: 25, radius: 5),
      ],
    );
  }
}

class HorizontalListShimmer extends StatelessWidget {
  const HorizontalListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    var singleHMovieShimmer = Container(
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: LightThemeColors.background,
      ),
      height: 215,
      width: 112,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 27),
            child: Shimmer(
              gradient: LinearGradient(
                colors: [
                  LightThemeColors.tertiary.withValues(alpha: 0.3),
                  LightThemeColors.secondary.withValues(alpha: 0.2)
                ],
              ),
              child: Row(
                children: [
                  singleHMovieShimmer,
                  singleHMovieShimmer,
                  singleHMovieShimmer,
                  singleHMovieShimmer,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KnowForShimmer extends StatelessWidget {
  const KnowForShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) => defBoxShim(
            height: 215, width: 112, margin: const EdgeInsets.fromLTRB(8, 0, 8, 5), radius: 14),
      ),
    );
  }
}

class SingleRowGenresShimmer extends StatelessWidget {
  const SingleRowGenresShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var singleGenreShimmer = Container(
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: LightThemeColors.background,
      ),
      height: 30,
      width: 80,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 27),
          child: Shimmer(
            gradient: LinearGradient(
              colors: [
                LightThemeColors.tertiary.withValues(alpha: 0.3),
                LightThemeColors.secondary.withValues(alpha: 0.2)
              ],
            ),
            child: Row(
              children: [
                singleGenreShimmer,
                singleGenreShimmer,
                singleGenreShimmer,
                singleGenreShimmer,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ArtistShimmer extends StatelessWidget {
  const ArtistShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    var singleArtistShimmer = Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(9, 0, 9, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(33.36),
            color: LightThemeColors.background,
          ),
          height: 100,
          width: 66.72,
        ),
        // const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: LightThemeColors.background,
          ),
          height: 30,
          width: 67,
        ),
      ],
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 27),
            child: Shimmer(
              gradient: LinearGradient(
                colors: [
                  LightThemeColors.tertiary.withValues(alpha: 0.3),
                  LightThemeColors.secondary.withValues(alpha: 0.2)
                ],
              ),
              child: Row(
                children: [
                  singleArtistShimmer,
                  singleArtistShimmer,
                  singleArtistShimmer,
                  singleArtistShimmer,
                  singleArtistShimmer,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
