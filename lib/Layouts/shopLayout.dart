import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/shopCubit.dart';
import '../cubit/states.dart';
import '../modules/LoginScreen.dart';
import '../modules/SearchScreen.dart';
import '../remoteNetwork/cacheHelper.dart';
import '../shared/constants.dart';

class ShopLayout extends StatelessWidget {
  bool showBottomSheet = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is HomeSuccessState) {
          int cartLen = ShopCubit.get(context).cartModel.data!.cartItems.length;
        }
      },
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 10,
            title: Row(
              children: [
                const Image(
                  image: AssetImage('assets/images/Shop Logo.jpeg'),
                  width: 40,
                  height: 40,
                ),
                RichText(
                    text: const TextSpan(children: [
                  TextSpan(
                      text: 'E',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'SHOP',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                ])),
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    navigateTo(context, SearchScreen(ShopCubit.get(context)));
                  },
                  icon: const Icon(Icons.search)),
            ],
          ),
          bottomSheet: showBottomSheet
              ? ShopCubit.get(context).cartModel.data!.cartItems.isNotEmpty
                  ? Container(
                      width: double.infinity,
                      height: 60,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: ElevatedButton(
                        onPressed: () {},
                        //shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        child: const Text(
                          'Check Out',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    )
              : const SizedBox(
                  width: 0,
                  height: 0,
                ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: cubit.navBar,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              if (index == 3) {
                showBottomSheet = true;
              } else if (ShopCubit.get(context)
                  .cartModel
                  .data!
                  .cartItems
                  .isEmpty) {
                showBottomSheet = false;
              } else {
                showBottomSheet = false;
              }
              return cubit.changeBottomNav(index);
            },
          ),
        );
      },
    );
  }
}
