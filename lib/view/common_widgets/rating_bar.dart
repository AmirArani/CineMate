import 'package:flutter/material.dart';

class RatingBar extends StatefulWidget {
  /// Default constructor for [RatingBar].
  const RatingBar({
    super.key,
    this.onRatingChanged,
    this.initialRating = 0.0,
    this.maxRating = 5,
    this.alignment = Alignment.centerLeft,
    this.direction = Axis.horizontal,
    this.size = 24,
  }) : _readOnly = false;

  /// Creates read only rating bar.
  const RatingBar.readOnly({
    super.key,
    this.maxRating = 5,
    this.onRatingChanged,
    this.alignment = Alignment.centerLeft,
    this.direction = Axis.horizontal,
    this.initialRating = 0.0,
    this.size = 24,
  }) : _readOnly = true;

  /// Max rating value.
  final int maxRating;

  /// Callback for rating changes.
  final void Function(double)? onRatingChanged;

  /// Initial rating value.
  final double initialRating;

  /// Alignment of the rating bar.
  final Alignment alignment;

  /// Direction of the rating bar.
  final Axis direction;

  /// Size of the rating bar.
  final double size;

  /// If true, the rating bar is read only.
  final bool _readOnly;

  @override
  State<RatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  double? _currentRating;

  @override
  void initState() {
    super.initState();

    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) => _buildRatingBar();

  Widget _buildRatingBar() => Align(
        alignment: widget.alignment,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            widget.maxRating,
            (index) {
              final iconPosition = index + 1;
              return _buildIcon(iconPosition);
            },
          ),
        ),
      );

  Widget _buildIcon(int position) {
    return GestureDetector(
      child: _buildIconView(position),
      onTap: () {
        if (widget.onRatingChanged != null) {
          setState(() => _currentRating = position.toDouble());
          final currentRating = _currentRating;
          if (currentRating == null) return;
          widget.onRatingChanged!.call(currentRating);
        }
      },
    );
  }

  Widget _buildIconView(int position) {
    final halfFilledIcon = Icons.star_half_rounded;

    IconData iconData;
    Color color;
    double rating;

    if (widget._readOnly) {
      rating = widget.initialRating;
    } else {
      final currentRating = _currentRating;
      if (currentRating == null) throw AssertionError('rating can\'t null');
      rating = currentRating;
    }
    if (position > rating + 0.5) {
      iconData = Icons.star_outline_rounded;
      color = Colors.grey;
    } else if (position == rating + 0.5) {
      iconData = halfFilledIcon;
      color = Colors.amber;
    } else {
      iconData = Icons.star_rounded;
      color = Colors.amber;
    }
    return Icon(iconData, color: color, size: widget.size);
  }
}
