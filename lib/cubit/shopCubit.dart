import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Layouts/shopLayout.dart';
import 'states.dart';
import '../models/addressModels/addAddressModel.dart';
import '../models/addressModels/addressModel.dart';
import '../models/addressModels/update&Delete.dart';
import '../models/cartModels/addCartModel.dart';
import '../models/cartModels/cartModel.dart';
import '../models/categoriesModels/categoriesDetailsModel.dart';
import '../models/categoriesModels/categoriesModel.dart';
import '../models/favoritesModels/changeFavoritesModel.dart';
import '../models/favoritesModels/favoritesModel.dart';
import '../models/homeModels/productModel.dart';
import '../models/profileModels/faqsModels.dart';
import '../models/homeModels/homeModel.dart';
import '../models/cartModels/updateCartModel.dart';
import '../models/profileModels/logOutModel.dart';
import '../models/profileModels/userModel.dart';
import '../modules/CategoriesScreen.dart';
import '../modules/LoginScreen.dart';
import '../modules/cartScreen.dart';
import '../modules/homeScreen.dart';
import '../modules/myAccountScreen.dart';
import '../modules/profileScreen.dart';
import '../remoteNetwork/cacheHelper.dart';
import '../remoteNetwork/dioHelper.dart';
import '../remoteNetwork/endPoints.dart';
import '../shared/constants.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(InitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  Map<dynamic, dynamic> favorites = {};
  Map<dynamic, dynamic> cart = {};

  HomeModel? homeModel;
  void getHomeData() {
    emit(HomeLoadingState());
    DioHelper.getData(url: HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      print('Home ${homeModel!.status}');
      for (var element in homeModel!.data!.products) {
        favorites.addAll({element.id: element.inFavorites});
      }
      for (var element in homeModel!.data!.products) {
        cart.addAll({element.id: element.inCart});
      }
      emit(HomeSuccessState());
    }).catchError((error) {
      emit(HomeErrorState());
      print(error.toString());
    });
  }

  ProductDetailsModel? productDetailsModel;
  void getProductData(productId) {
    productDetailsModel = null;
    emit(ProductLoadingState());
    DioHelper.getData(url: 'products/$productId', token: token).then((value) {
      productDetailsModel = ProductDetailsModel.fromJson(value.data);
      print('Product Detail ${productDetailsModel!.status}');
      emit(ProductSuccessState());
    }).catchError((error) {
      emit(ProductErrorState());
      print(error.toString());
    });
  }

  CategoriesModel? categoriesModel;
  void getCategoryData() {
    emit(CategoriesLoadingState());
    DioHelper.getData(
      url: CATEGORIES,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      print('Categories ${categoriesModel!.status}');
      emit(CategoriesSuccessState());
    }).catchError((error) {
      emit(CategoriesErrorState());
      print(error.toString());
    });
  }

  CategoryDetailModel? categoriesDetailModel;
  void getCategoriesDetailData(int? categoryID) {
    emit(CategoryDetailsLoadingState());
    DioHelper.getData(url: CATEGORIES_DETAIL, query: {
      'category_id': '$categoryID',
    }).then((value) {
      categoriesDetailModel = CategoryDetailModel.fromJson(value.data);
      print('categories Detail ${categoriesDetailModel!.status}');
      emit(CategoryDetailsSuccessState());
    }).catchError((error) {
      emit(CategoryDetailsErrorState());
      print(error.toString());
    });
  }

  FavoritesModel? favoritesModel;
  void getFavoriteData() {
    emit(FavoritesLoadingState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      print('Favorites ${favoritesModel!.status}');
      emit(FavoritesSuccessState());
    }).catchError((error) {
      emit(FavoritesErrorState());
      print(error.toString());
    });
  }

  UserModel? userModel;
  void getProfileData() {
    emit(ProfileLoadingState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = UserModel.fromJson(value.data);
      print('Profile ${userModel!.status}');
      print(userModel!.data!.token);
      emit(ProfileSuccessState());
    }).catchError((error) {
      emit(ProfileErrorState());
      print(error.toString());
    });
  }

  void updateProfileData({
    required String email,
    required String name,
    required String phone,
  }) {
    emit(UpdateProfileLoadingState());
    DioHelper.putData(url: UPDATE_PROFILE, token: token, data: {
      'name': name,
      'phone': phone,
      'email': email,
    }).then((value) {
      userModel = UserModel.fromJson(value.data);
      print('Update Profile ${userModel!.status}');
      emit(UpdateProfileSuccessState(userModel!));
    }).catchError((error) {
      emit(UpdateProfileErrorState());
      print(error.toString());
    });
  }

  UserModel? passwordModel;
  void changePassword(
      {required context,
      required String currentPass,
      required String newPass}) {
    emit(ChangePassLoadingState());
    DioHelper.postData(url: 'change-password', token: token, data: {
      'current_password': currentPass,
      'new_password': newPass,
    }).then((value) {
      passwordModel = UserModel.fromJson(value.data);
      print('Change Password ${passwordModel!.status}');
      if (passwordModel!.status) {
        showToast(passwordModel!.message);
        pop(context);
      } else {
        showToast(passwordModel!.message);
      }
      emit(ChangePassSuccessState(userModel!));
    }).catchError((error) {
      emit(ChangePassErrorState());
      print(error.toString());
    });
  }

  ChangeToFavoritesModel? changeToFavoritesModel;
  void changeToFavorite(int? productID) {
    favorites[productID] = !favorites[productID];
    emit(ChangeFavoritesManuallySuccessState());

    emit(ChangeFavoritesLoadingState());
    DioHelper.postData(
        url: FAVORITES,
        token: token,
        data: {'product_id': productID}).then((value) {
      changeToFavoritesModel = ChangeToFavoritesModel.fromjson(value.data);
      print(changeToFavoritesModel!.status);
      if (changeToFavoritesModel!.status == false) {
        favorites[productID] = !favorites[productID];
      } else {
        getFavoriteData();
      }
      emit(ChangeFavoritesSuccessState(changeToFavoritesModel!));
    }).catchError((error) {
      favorites[productID] = !favorites[productID];
      emit(ChangeFavoritesErrorState());
      print(error.toString());
    });
  }

  /// CART API
  late AddCartModel addCartModel;
  void addToCart(int? productID) {
    emit(AddCartLoadingState());
    DioHelper.postData(url: CART, token: token, data: {'product_id': productID})
        .then((value) {
      addCartModel = AddCartModel.fromJson(value.data);
      print('AddCart ${addCartModel.status}');
      if (addCartModel.status) {
        getCartData();
        getHomeData();
      } else {
        showToast(addCartModel.message);
      }
      emit(AddCartSuccessState(addCartModel));
    }).catchError((error) {
      emit(AddCartErrorState());
      print(error.toString());
    });
  }

  late UpdateCartModel updateCartModel;
  void updateCartData(int? cartId, int? quantity) {
    emit(UpdateCartLoadingState());
    DioHelper.putData(
      url: 'carts/$cartId',
      data: {
        'quantity': '$quantity',
      },
      token: token,
    ).then((value) {
      updateCartModel = UpdateCartModel.fromJson(value.data);
      if (updateCartModel.status) {
        getCartData();
      } else {
        showToast(updateCartModel.message);
      }
      print('Update Cart ${updateCartModel.status}');
      emit(UpdateCartSuccessState());
    }).catchError((error) {
      emit(UpdateCartErrorState());
      print(error.toString());
    });
  }

  late CartModel cartModel;
  void getCartData() {
    emit(CartLoadingState());
    DioHelper.getData(
      url: CART,
      token: token,
    ).then((value) {
      cartModel = CartModel.fromJson(value.data);
      print('Get Cart ${cartModel.status}');
      emit(CartSuccessState());
    }).catchError((error) {
      emit(CartErrorState());
      print(error.toString());
    });
  }

  /// END OF CART API

  /// Address API
  AddAddressModel? addAddressModel;
  void addAddress({
    required String name,
    required String city,
    required String region,
    required String details,
    required String notes,
    double latitude = 30.0616863,
    double longitude = 31.3260088,
  }) {
    emit(AddAddressLoadingState());
    DioHelper.postData(url: 'addresses', token: token, data: {
      'name': name,
      'city': city,
      'region': region,
      'details': details,
      'notes': notes,
      'latitude': latitude,
      'longitude': longitude,
    }).then((value) {
      addAddressModel = AddAddressModel.fromJson(value.data);
      print('Add Address ${addAddressModel!.status}');
      if (addAddressModel!.status) {
        getAddresses();
      } else {
        showToast(addAddressModel!.message);
      }
      emit(AddAddressSuccessState(addAddressModel!));
    }).catchError((error) {
      emit(AddAddressErrorState());
      print(error.toString());
    });
  }

  late AddressModel addressModel;
  void getAddresses() {
    emit(AddressesLoadingState());
    DioHelper.getData(
      url: 'addresses',
      token: token,
    ).then((value) {
      addressModel = AddressModel.fromJson(value.data);
      print('Get Addresses ${addressModel.status}');
      emit(AddressesSuccessState());
    }).catchError((error) {
      emit(AddressesErrorState());
      print(error.toString());
    });
  }

  UpdateAddressModel? updateAddressModel;
  void updateAddress({
    required int? addressId,
    required String name,
    required String city,
    required String region,
    required String details,
    required String notes,
    double latitude = 30.0616863,
    double longitude = 31.3260088,
  }) {
    emit(UpdateAddressLoadingState());
    DioHelper.putData(url: 'addresses/$addressId', token: token, data: {
      'name': name,
      'city': city,
      'region': region,
      'details': details,
      'notes': notes,
      'latitude': latitude,
      'longitude': longitude,
    }).then((value) {
      updateAddressModel = UpdateAddressModel.fromJson(value.data);
      print('Update Address ${updateAddressModel!.status}');
      if (updateAddressModel!.status) {
        getAddresses();
      }
      emit(UpdateAddressSuccessState(updateAddressModel!));
    }).catchError((error) {
      emit(UpdateAddressErrorState());
      print(error.toString());
    });
  }

  UpdateAddressModel? deleteAddressModel;
  void deleteAddress({required addressId}) {
    emit(DeleteAddressLoadingState());
    DioHelper.deleteData(
      url: 'addresses/$addressId',
      token: token,
    ).then((value) {
      deleteAddressModel = UpdateAddressModel.fromJson(value.data);
      print('delete Address ${deleteAddressModel!.status}');
      if (deleteAddressModel!.status) {
        getAddresses();
      }
      emit(DeleteAddressSuccessState());
    }).catchError((error) {
      emit(DeleteAddressErrorState());
      print(error.toString());
    });
  }

  /// END OF ADDRESS API

  late FAQsModel faqsModel;
  void getFAQsData() {
    emit(FAQsLoadingState());
    DioHelper.getData(
      url: 'faqs',
    ).then((value) {
      faqsModel = FAQsModel.fromJson(value.data);
      print('Get FAQs ${faqsModel.status}');
      emit(FAQsSuccessState());
    }).catchError((error) {
      emit(FAQsErrorState());
      print(error.toString());
    });
  }

  Icon favoriteIcon = const Icon(
    Icons.favorite,
    color: Colors.red,
  );
  Icon unFavoriteIcon = const Icon(Icons.favorite_border_rounded);

  List<BottomNavigationBarItem> navBar = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.grid_view),
      label: 'Categories',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'My Account',
    ),
    BottomNavigationBarItem(
      icon: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          const Icon(Icons.shopping_cart_outlined),
          if (cartLength != 0)
            CircleAvatar(
              backgroundColor: Colors.green,
              radius: 6,
              child: Text(
                '$cartLength',
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
        ],
      ),
      label: 'Cart',
    ),
  ];

  int currentIndex = 0;
  changeBottomNav(index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  List<Widget> screens = [
    HomeScreen(),
    CategoriesScreen(),
    MyAccountScreen(),
    CartScreen()
  ];

  void getToken() {
    token = CacheHelper.getData('token');
    emit(GetTokenSuccessState());
  }

  bool inCart = false;
  Widget topSheet(model, context) {
    if (inCart) {
      return MaterialBanner(
          padding: EdgeInsets.zero,
          leading: const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 30,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model!.name}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'Added to Cart',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              )
            ],
          ),
          actions: [
            OutlinedButton(
                onPressed: () {
                  inCart = false;
                  emit(CloseTopSheet());
                },
                child: const Text('CONTINUE SHOPPING')),
            ElevatedButton(
              onPressed: () {
                navigateTo(context, ShopLayout());
                ShopCubit.get(context).currentIndex = 3;
              },
              child: const Text('CHECKOUT'),
            ),
          ]);
    } else {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    }
  }

  bool showCurrentPassword = false;
  IconData currentPasswordIcon = Icons.visibility;
  void changeCurrentPassIcon(context) {
    showCurrentPassword = !showCurrentPassword;
    if (showCurrentPassword) {
      currentPasswordIcon = Icons.visibility_off;
    } else {
      currentPasswordIcon = Icons.visibility;
    }
    emit(ChangeSuffixIconState());
  }

  bool showNewPassword = false;
  IconData newPasswordIcon = Icons.visibility;
  void changeNewPassIcon(context) {
    showNewPassword = !showNewPassword;
    if (showNewPassword) {
      newPasswordIcon = Icons.visibility_off;
    } else {
      newPasswordIcon = Icons.visibility;
    }
    emit(ChangeSuffixIconState());
  }

  // LogOutModel? logOutModel;
  // void signOut(context){
  //   emit(LogOutLoadingState());
  //   DioHelper.postData(
  //       url: 'logout',
  //       token: token,
  //      ).then((value) {
  //     logOutModel = LogOutModel.fromJson(value.data);
  //     if(logOutModel!.status)
  //       navigateAndKill(context, LoginScreen());
  //     else
  //       showToast(logOutModel!.message);
  //     emit(LogOutSuccessState(logOutModel!));
  //   }).catchError((error) {
  //     print(error.toString());
  //     emit(LogOutErrorState());
  //   });
  // }

}
