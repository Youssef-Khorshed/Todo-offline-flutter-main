import 'package:flutter/material.dart';
import 'package:todo/core/constant/app_colors.dart';
import 'package:todo/core/constant/app_image.dart';
import 'package:todo/core/constant/app_route.dart';
import 'package:todo/features/todo/presentation/widgets/todo_page/icon_bottom_gradent.dart';

class MainBottomBar extends StatelessWidget {
  const MainBottomBar({Key? key, this.onTapDone, this.onTapAdd})
      : super(key: key);
  final void Function()? onTapDone;
  final void Function()? onTapAdd;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconBottomGradent(
              onTap: onTapDone,
              topGrandient: AppColors.iconDoneBgGrandentTop,
              bottomGrandient: AppColors.iconDoneBgGrandentDown,
              iconData: Icons.done),
          const SizedBox(
            width: 46,
          ),
          _centerIcon(context: context),
          const SizedBox(
            width: 46,
          ),
          IconBottomGradent(
              onTap: onTapAdd,
              topGrandient: AppColors.iconAddBgGrandentTop,
              bottomGrandient: AppColors.iconAddBgGrandentDown,
              iconData: Icons.add)
        ],
      ),
    );
  }

  Widget _centerIcon({required BuildContext context}) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(AppRoute.done),
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
                color: AppColors.other.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 4))
          ],
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SizedBox(
            height: 28,
            width: 28,
            child: Image.asset(AppImages.main),
          ),
        ),
      ),
    );
  }
}
