import 'package:financial_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key, this.title, this.description, this.body, this.toolbarSize = 32});

  final String? title;
  final String? description;
  final Widget? body;
  final double toolbarSize;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, left: 16, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title != null
                ? Text(
                    title!,
                    maxLines: 1,
                    style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 20),
                  )
                : const SizedBox.shrink(),

            if (description != null) ...[
              const SizedBox(height: 4),
              Text(description!, style: TextStyle(color: AppColors.grey, fontSize: 16)),
            ],
            if (body != null) ...[const SizedBox(height: 12), body!],
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + toolbarSize);
}
