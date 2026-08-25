import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';

class DrawerModuleItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isCompleted;
  final bool isUnlocked;
  final VoidCallback? onLocked;

  const DrawerModuleItemTile({
    super.key,
    required this.item,
    required this.isCompleted,
    this.isUnlocked = true,
    this.onLocked,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isCompleted
              ? AppColors.sageLight
              : AppColors.warmCream.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Icon(
            item['icon'] as IconData,
            color:
                isCompleted ? AppColors.primaryGreen : AppColors.warmTerracotta,
            size: 20,
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryDark.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'S${item['slide']}',
              style: AppTextStyles.tagText.copyWith(
                color: AppColors.primaryDark,
                fontSize: 10,
              ),
            ),
          ),
          Expanded(
            child: Text(
              item['title'] as String,
              style: AppTextStyles.bodyBold.copyWith(
                fontSize: 13,
                color: AppColors.primaryDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      subtitle: Text(
        item['subtitle'] as String,
        style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: isCompleted
          ? const Icon(Icons.check_circle_rounded,
              color: AppColors.successGreen, size: 20)
          : Icon(
              isUnlocked ? Icons.chevron_right_rounded : Icons.lock_rounded,
              color: AppColors.textLight,
              size: 20,
            ),
      onTap: () {
        if (!isUnlocked) {
          onLocked?.call();
          return;
        }
        Navigator.pop(context);
        context.go(item['route'] as String);
      },
    );
  }
}
