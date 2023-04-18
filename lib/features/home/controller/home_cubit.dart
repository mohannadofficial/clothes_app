import 'dart:convert';

import 'package:ecommerce_app/core/enum.dart';
import 'package:ecommerce_app/core/network/local/cache_helper.dart';
import 'package:ecommerce_app/core/services.dart';
import 'package:ecommerce_app/features/auth/controller/auth_cubit.dart';
import 'package:ecommerce_app/features/home/controller/home_state.dart';
import 'package:ecommerce_app/features/home/home_screen.dart';
import 'package:ecommerce_app/features/home/like_screen.dart';
import 'package:ecommerce_app/features/home/order_screen.dart';
import 'package:ecommerce_app/features/home/repository/home_repository.dart';
import 'package:ecommerce_app/features/profile/profile_screen.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routemaster/routemaster.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;
  HomeCubit({required HomeRepository homeRepository})
      : _homeRepository = homeRepository,
        super(const HomeState());

  final _user = sl<AuthCubit>().state.userModel;

  List<Widget> screens = const [
    HomeScreen(),
    LikeScreen(),
    OrderScreen(),
    ProfileScreen(),
  ];

  void changeIndex(int index) {
    emit(state.copyWith(selectIndex: index));
  }

  void getCategories(String token) async {
    emit(state.copyWith(submissionStatus: SubmissionStatus.inProgress));
    final res = await _homeRepository.getCategories(token);
    res.fold(
      (l) {
        emit(state.copyWith(
            errorMessage: l.toString(),
            submissionStatus: SubmissionStatus.error));
      },
      (r) {
        emit(
          state.copyWith(
              categoriesModel: r, submissionStatus: SubmissionStatus.loaded),
        );
      },
    );
  }

  void loadLikeProduct() {
    List<String> likeModel = [];
    if (CacheHelper.getData(key: '${_user?.userId}like') != null) {
      (CacheHelper.getData(key: '${_user?.userId}like') as List<dynamic>)
          .forEach(((element) {
        likeModel.add(element);
      }));

      emit(state.copyWith(
        like: likeModel,
      ));
    }
  }

  void likeManage(ProductModel productModel) {
    List<String> likeModel = [];
    List<ProductModel> productModelTemp = [];
    for (var element in state.like) {
      likeModel.add(element);
    }
    for (var element in state.likeProductModel) {
      productModelTemp.add(element);
    }
    if (likeModel.contains(productModel.productId)) {
      likeModel.removeWhere(
        (element) => element == productModel.productId,
      );
      productModelTemp.removeWhere(
        (element) => element.productId == productModel.productId,
      );
    } else {
      likeModel.add(productModel.productId);
      productModelTemp.add(productModel);
    }
    emit(state.copyWith(like: likeModel, likeProductModel: productModelTemp));
  }

  void getProduct(String token) async {
    emit(state.copyWith(submissionStatus: SubmissionStatus.inProgress));
    final res = await _homeRepository.getProducts(token);

    res.fold(
      (l) {
        emit(
          state.copyWith(
            errorMessage: l.toString(),
            submissionStatus: SubmissionStatus.error,
          ),
        );
      },
      (r) {
        List<ProductModel> likeProductTemp = [];
        if (CacheHelper.getData(key: '${_user?.userId}like') != null) {
          (CacheHelper.getData(key: '${_user?.userId}like') as List<dynamic>)
              .forEach(((element) {
            if (r.isNotEmpty) {
              for (var elementModel in r) {
                if (elementModel.productId == element) {
                  likeProductTemp.add(elementModel);
                }
              }
            }
          }));
        }
        List<ProductModel> productCartTemp = [];
        if (CacheHelper.getData(key: '${_user?.userId}order') != null) {
          (CacheHelper.getData(key: '${_user?.userId}order') as List<dynamic>)
              .forEach(((element) {
            productCartTemp.add(ProductModel.fromJson(jsonDecode(element)));
          }));
        }
        emit(
          state.copyWith(
              productsModel: r,
              likeProductModel: likeProductTemp,
              productCartModel: productCartTemp,
              submissionStatus: SubmissionStatus.loaded),
        );
      },
    );
  }

  void cartItemNumber({required int num, bool isPlus = true}) {
    if (isPlus && num < 10) {
      emit(state.copyWith(numCartItem: state.numCartItem + 1));
    }
    if (!isPlus && num > 1) {
      emit(state.copyWith(numCartItem: state.numCartItem - 1));
    }
  }

  void loadProductCart(
      {required ProductModel productModel, required BuildContext context}) {
    emit(state.copyWith(
      productsModelScreen: productModel,
      numCartItem: 1,
    ));
    Routemaster.of(context).push('/product/');
  }

  void addToCart(ProductModel productModel) {
    List<ProductModel> productCartTemp = [];
    List<String> productCartTempString = [];
    productCartTemp.add(productModel);
    for (var element in state.productCartModel) {
      if (element.productId != productModel.productId) {
        productCartTemp.add(element);
      }
    }

    for (var element in productCartTemp) {
      productCartTempString.add(jsonEncode(element.toJson()));
    }
    CacheHelper.setData(
        key: '${_user?.userId}order', value: productCartTempString);
    emit(
      state.copyWith(
        productCartModel: productCartTemp,
      ),
    );
  }

  void addToOrder(
      {required int price,
      required int index,
      required int countItem,
      bool isPlus = true}) {
    List<ProductModel> productCartModelTemp = [];
    List<String> productCartModelTempString = [];
    if (isPlus && countItem < 10) {
      for (int i = 0; i < state.productCartModel.length; i++) {
        if (i == index) {
          productCartModelTemp.add(state.productCartModel[i]
              .copyWith(price: state.productCartModel[i].price + price));
        } else {
          productCartModelTemp.add(state.productCartModel[i]);
        }
      }

      productCartModelTemp.forEach(((element) {
        productCartModelTempString.add(jsonEncode(element.toJson()));
      }));

      CacheHelper.setData(
          key: '${_user?.userId}order', value: productCartModelTempString);
      emit(state.copyWith(productCartModel: productCartModelTemp));
    }

    if (!isPlus && countItem > 0) {
      for (int i = 0; i < state.productCartModel.length; i++) {
        if (countItem == 1) {
          if (i != index) {
            productCartModelTemp.add(state.productCartModel[i]);
          }
        } else {
          if (i == index) {
            productCartModelTemp.add(state.productCartModel[i]
                .copyWith(price: state.productCartModel[i].price - price));
          } else {
            productCartModelTemp.add(state.productCartModel[i]);
          }
        }
      }
      productCartModelTemp.forEach(((element) {
        productCartModelTempString.add(jsonEncode(element.toJson()));
      }));

      CacheHelper.setData(
          key: '${_user?.userId}order', value: productCartModelTempString);
      emit(state.copyWith(productCartModel: productCartModelTemp));
    }
  }

  void deleteCart() {
    CacheHelper.deleteData(key: '${_user?.userId}order');
    emit(state.copyWith(productCartModel: const []));
  }

  void deletelike() {
    CacheHelper.deleteData(key: '${_user?.userId}like');
    emit(state.copyWith(
      likeProductModel: const [],
      like: const [],
    ));
  }

  void selectItemFilter(String catergotyModel, bool value) {
    final List<String> selectTemp = [];
    for (var element in state.selectFilterCategoryModel) {
      selectTemp.add(element);
    }
    if (value && state.selectFilterCategoryModel.contains(catergotyModel)) {
      selectTemp.remove(catergotyModel);
      emit(state.copyWith(selectFilterCategoryModel: selectTemp));
    }
    if (!value) {
      selectTemp.add(catergotyModel);
      emit(state.copyWith(selectFilterCategoryModel: selectTemp));
    }
  }

  void applyItemFilter(BuildContext context) {
    emit(state.copyWith(filterCategoryModel: state.selectFilterCategoryModel));
    Routemaster.of(context).pop();
  }
}
