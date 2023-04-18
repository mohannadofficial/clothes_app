import 'package:ecommerce_app/core/common/big_text.dart';
import 'package:ecommerce_app/core/common/click_button.dart';
import 'package:ecommerce_app/core/services.dart';
import 'package:ecommerce_app/core/utils/colors.dart';
import 'package:ecommerce_app/features/home/controller/home_cubit.dart';
import 'package:ecommerce_app/features/home/controller/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routemaster/routemaster.dart';

class SearchDialog extends StatelessWidget {
  const SearchDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Container(
          height: height / 2,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.categoriesModel.length,
                  primary: false,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final categoryModelFilterName =
                        state.categoriesModel[index];
                    return CheckboxListTile(
                      title: BigText(
                        text: categoryModelFilterName.title,
                        size: 16,
                      ),
                      value: state.selectFilterCategoryModel
                          .contains(categoryModelFilterName.categoryId),
                      onChanged: (value) {
                        sl<HomeCubit>().selectItemFilter(
                            categoryModelFilterName.categoryId, !value!);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Routemaster.of(context).pop(),
                    child: ClickButton(
                      sizeWidth: width / 4,
                      text: 'Deny',
                      backgroundColor: AppColors.coverTap,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      sl<HomeCubit>().applyItemFilter(context);
                    },
                    child: ClickButton(
                      sizeWidth: width / 4,
                      text: 'Apply',
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
