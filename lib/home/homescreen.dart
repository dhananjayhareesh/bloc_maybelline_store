import 'package:bloc_project/Favorite/Favourite.dart';
import 'package:bloc_project/api_service/api_service.dart';
import 'package:bloc_project/cart/cart.dart';
import 'package:bloc_project/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    homebloc.add(InitialfetchEvent());
    super.initState();
  }

  final HomeBloc homebloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homebloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeNavigateToWishlistPageActionButton) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => const FavouriteScreen()));
        } else if (state is HomeNavigateToCartPageActionButton) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => const CartScreen()));
        } else if (state is SnackbarOfFavourites) {
          snackbar('Added to Favourite', context);
        } else if (state is SnackbarOfCarts) {
          snackbar('Added to Cart', context);
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingState:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case HomeLoadedSuccessState:
            final value = state as HomeLoadedSuccessState;
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Maybelline Online Store',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontFamily: 'HASHI',
                    color: Color.fromARGB(255, 248, 248, 248),
                  ),
                ),
                backgroundColor: Color.fromARGB(255, 66, 40, 66),
                actions: [
                  IconButton(
                    onPressed: () {
                      homebloc.add(HomeWishlistButtonNavigateButton());
                    },
                    icon: Icon(Icons.favorite),
                  ),
                  IconButton(
                    onPressed: () {
                      homebloc.add(HomeCartButtonNavigateButton());
                    },
                    icon: Icon(Icons.shopping_cart),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: value.product.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final product = value.product[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  product.imageurl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rs: ${product.price}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              'Rating: ${product.rating} ★',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    homebloc.add(
                                      HomeProductWishlistButtonClickedEvent(
                                        data: product,
                                      ),
                                    );
                                  },
                                  icon: !favourites.contains(product.id)
                                      ? const Icon(Icons.favorite_border)
                                      : const Icon(Icons.favorite),
                                  color: Colors.red,
                                ),
                                IconButton(
                                  onPressed: () {
                                    homebloc.add(
                                      HomeProductCartButtonClickedEvent(
                                        data: product,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.shopping_cart),
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );

          case HomeErrorState:
            return const Scaffold(
              body: Center(
                child: Text(
                  'Error',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
        }

        return Container();
      },
    );
  }
}
