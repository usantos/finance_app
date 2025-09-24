import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class LoadSkeleton extends StatefulWidget {
  final int itemCount;

  const LoadSkeleton({super.key, this.itemCount = 6});

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
          padding: const EdgeInsets.only(bottom: 16),
          child: SkeletonItem(
            child: SkeletonAvatar(
              style: SkeletonAvatarStyle(
                width: double.infinity,
                height: index == 0 ? 80 : 60,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
