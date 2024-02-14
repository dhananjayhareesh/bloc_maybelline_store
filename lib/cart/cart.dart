import 'package:bloc_project/cart/bloc/cart_bloc.dart';
import 'package:bloc_project/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<ProductModel> carts = [];

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cartBloc = CartBloc();

  @override
  void initState() {
    cartBloc.add(CartinitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      bloc: cartBloc,
      listenWhen: (previous, current) => current is cartActionState,
      buildWhen: (previous, current) => current is! cartActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case CartSuccessstate:
            final value = state as CartSuccessstate;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 66, 40, 66),
                centerTitle: true,
                title: const Text(
                  'Carts',
                  style: TextStyle(
                      fontFamily: 'HASHI', fontWeight: FontWeight.w900),
                ),
              ),
              body: ListView.builder(
                itemCount: value.products.length,
                itemBuilder: (ctx, index) {
                  final data = value.products[index];
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                data.imageurl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'HASHI',
                                      fontSize: 16,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Rs: ${data.price}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Rating: ${data.rating} ★',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () {
                                cartBloc.add(CartRemoveEvent(product: data));
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          default:
            return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 45, 44, 44),
                centerTitle: true,
                title: const Text(
                  'Carts',
                  style: TextStyle(
                      fontFamily: 'HASHI', fontWeight: FontWeight.w900),
                ),
              ),
              body: const Center(
                child: Text('Error'),
              ),
            );
        }
      },
    );
  }
}
