import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class LoadSkeleton extends StatefulWidget {
  final int itemCount;
  final double? height;

  const LoadSkeleton({super.key, this.itemCount = 6, this.height});

  @override
  State<LoadSkeleton> createState() => _LoadSkeletonState();
}

class _LoadSkeletonState extends State<LoadSkeleton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.itemCount,
        (index) => Padding(
          padding: const EdgeInsets.all(16),
          child: SkeletonItem(
            child: SkeletonAvatar(
              style: SkeletonAvatarStyle(
                width: double.infinity,
                height: widget.height ?? 60,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
