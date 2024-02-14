import 'package:bloc_project/Favorite/bloc/favourite_bloc.dart';
import 'package:bloc_project/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<ProductModel> favourites = [];

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final favBloc = FavouriteBloc();

  @override
  void initState() {
    favBloc.add(FavInitializeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavouriteBloc, FavouriteState>(
      bloc: favBloc,
      listenWhen: (previous, current) => current is FavActionState,
      buildWhen: (previous, current) => current is! FavActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case FavSuccessState:
            final value = state as FavSuccessState;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 45, 44, 44),
                centerTitle: true,
                title: const Text(
                  'Favourites',
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
                                favBloc.add(FavdeleteEvent(product: data));
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
        }
        return Scaffold(
          appBar: AppBar(),
          body: const Center(
            child: Text('Error'),
          ),
        );
      },
    );
  }
}
