import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/shopCubit.dart';
import '../cubit/states.dart';
import '../models/addressModels/addressModel.dart';
import 'add&UpdateAddress.dart';
import '../shared/constants.dart';

import 'SearchScreen.dart';

class AddressesScreen extends StatelessWidget {
  TextEditingController cityController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          bottomSheet: Container(
            width: double.infinity,
            height: 70,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: MaterialButton(
              onPressed: () {
                navigateTo(
                    context,
                    UpdateAddressScreen(
                      isEdit: false,
                    ));
              },
              color: Colors.deepOrange,
              //shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              child: const Text(
                'ADD A NEW ADDRESS',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          body: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => ShopCubit.get(context)
                                .addressModel
                                .data!
                                .data!
                                .isEmpty
                            ? Container()
                            : addressItem(
                                ShopCubit.get(context)
                                    .addressModel
                                    .data!
                                    .data![index],
                                context),
                        separatorBuilder: (context, index) => myDivider(),
                        itemCount: ShopCubit.get(context)
                            .addressModel
                            .data!
                            .data!
                            .length),
                    Container(
                      color: Colors.white,
                      height: 70,
                      width: double.infinity,
                    )
                  ],
                ),
              ),
              // Container(
              //   width: double.infinity,
              //   height: 70,
              //   color: Colors.white,
              //   padding: EdgeInsets.symmetric(vertical: 10 ,horizontal: 15),
              //   child: MaterialButton(
              //     onPressed: (){
              //       navigateTo(context, UpdateAddressScreen(isEdit: false,));
              //       },
              //     color: Colors.deepOrange,
              //     //shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              //     child: Text('ADD A NEW ADDRESS',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
              //   ),
              // )
            ],
          ),
        );
      },
    );
    // Container(
    //                   width: double.infinity,
    //                   height: 70,
    //                   color: Colors.white,
    //                   padding: EdgeInsets.symmetric(vertical: 10 ,horizontal: 15),
    //                   child: MaterialButton(
    //                     onPressed: (){},
    //                     color: Colors.deepOrange,
    //                     //shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    //                     child: Text('Add Address',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,letterSpacing: 2),),
    //                   ),
    //                 )
  }

  Widget addressItem(AddressData model, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.green,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                '${model.name}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                  onPressed: () {
                    ShopCubit.get(context).deleteAddress(addressId: model.id);
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.delete_outline,
                        size: 17,
                      ),
                      Text('Delete')
                    ],
                  )),
              Container(
                height: 20,
                width: 1,
                color: Colors.grey[300],
              ),
              TextButton(
                  onPressed: () {
                    navigateTo(
                        context,
                        UpdateAddressScreen(
                          isEdit: true,
                          addressId: model.id,
                          name: model.name,
                          city: model.city,
                          region: model.region,
                          details: model.details,
                          notes: model.notes,
                        ));
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.edit,
                        size: 17,
                        color: Colors.grey,
                      ),
                      Text(
                        'Edit',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  )),
            ],
          ),
        ),
        myDivider(),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'City',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Region',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Details',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Notes',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${model.city}',
                      style: const TextStyle(
                        fontSize: 15,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('${model.region}',
                      style: const TextStyle(
                        fontSize: 15,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('${model.details}',
                      style: const TextStyle(
                        fontSize: 15,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('${model.notes}',
                      style: const TextStyle(
                        fontSize: 15,
                      )),
                  //
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
