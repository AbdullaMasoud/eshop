import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import '../cubit/shopCubit.dart';
import '../cubit/states.dart';
import '../models/categoriesModels/categoriesDetailsModel.dart';
import 'productScreen.dart';
import '../shared/constants.dart';

import 'SearchScreen.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String? categoryName;
  const CategoryProductsScreen(this.categoryName);
  @override
  Widget build(BuildContext context) {
    // return BlocProvider(
    //     create:(context) => DetailsCubit(),
    //   child:
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Row(
              children: const [
                Image(
                  image: AssetImage('assets/images/ShopLogo.png'),
                  width: 50,
                  height: 50,
                ),
                Text('ESHOP'),
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
          body: state is CategoryDetailsLoadingState
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ShopCubit.get(context)
                      .categoriesDetailModel!
                      .data
                      .productData
                      .isEmpty
                  ? const Center(
                      child: Text(
                        'Coming Soon',
                        style: TextStyle(fontSize: 50),
                      ),
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        color: Colors.grey[300],
                        child: Column(
                          children: [
                            Container(
                                width: double.infinity,
                                color: Colors.white,
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  '$categoryName',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                            separator(0, 1),
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 2,
                              childAspectRatio: 0.6,
                              mainAxisSpacing: 2,
                              children: List.generate(
                                  ShopCubit.get(context)
                                      .categoriesDetailModel!
                                      .data
                                      .productData
                                      .length,
                                  (index) => ShopCubit.get(context)
                                          .categoriesDetailModel!
                                          .data
                                          .productData
                                          .isEmpty
                                      ? const Center(
                                          child: Text(
                                            'Coming Soon',
                                            style: TextStyle(fontSize: 50),
                                          ),
                                        )
                                      : productItemBuilder(
                                          ShopCubit.get(context)
                                              .categoriesDetailModel!
                                              .data
                                              .productData[index],
                                          context)),
                            ),
                          ],
                        ),
                      ),
                    ),
        );
      },
    );
  }

  Widget productItemBuilder(ProductData model, context) {
    return InkWell(
      onTap: () {
        ShopCubit.get(context).getProductData(model.id);
        navigateTo(context, ProductScreen());
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsetsDirectional.only(start: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(alignment: AlignmentDirectional.bottomStart, children: [
              Image(
                image: NetworkImage('${model.image}'),
                height: 150,
                width: 150,
              ),
              if (model.discount != 0)
                Container(
                    color: defaultColor,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'Discount',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ))
            ]),
            separator(0, 10),
            Text(
              '${model.name}',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'EGP',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${model.price}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  separator(0, 5),
                  if (model.discount != 0)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'EGP',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          '${model.oldPrice}',
                          style: const TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey),
                        ),
                        separator(7, 0),
                        Text(
                          '${model.discount}' '% OFF',
                          style:
                              const TextStyle(color: Colors.red, fontSize: 11),
                        )
                      ],
                    ),
                ]),
                const Spacer(),
                // IconButton(
                //   onPressed: ()
                //   {
                //     ShopCubit.get(context).changeToFavorite(model.id);
                //     print(model.id);
                //   },
                //   icon: Conditional.single(
                //     context: context,
                //     conditionBuilder:(context) => ShopCubit.get(context).favorites[model.id],
                //     widgetBuilder:(context) => ShopCubit.get(context).favoriteIcon,
                //     fallbackBuilder: (context) => ShopCubit.get(context).unFavoriteIcon,
                //   ),
                //   padding: EdgeInsets.all(0),
                //   iconSize: 20,
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
