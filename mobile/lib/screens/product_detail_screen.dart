import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eshopcoffe/models/product/product_model.dart';
import 'package:eshopcoffe/services/baskets_service.dart';
import 'package:eshopcoffe/services/catalog_service.dart';
import 'package:eshopcoffe/widgets/circular_progress_widget.dart';
import 'package:eshopcoffe/widgets/app_bar_widget.dart';
import 'package:eshopcoffe/blocs/authentication/authentication_cubit.dart';
import 'package:eshopcoffe/utils/snack_bar_helper.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  final bool showCart;

  const ProductDetailScreen(this.productId, this.showCart, {super.key});

  @override
  ProductDetailScreenState createState() => ProductDetailScreenState();
}

class ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFfafafa),
      appBar: appBarWidget(context, 'ProductDetailScreen'),
      body: FutureBuilder(
        future: getDetailData(widget.productId),
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CircularProgressWidget();
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              else {
                return createDetailView(context, snapshot);
              }
          }
        }
      ),
      bottomNavigationBar: BottomNavBar(widget.productId, widget.showCart),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final String productId;
  final bool showCart;

  const BottomNavBar(this.productId, this.showCart, {super.key});

  @override
  Widget build(BuildContext context) {
    onAddToBasketButtonPressed() async {
      var needToSignIn = context.read<AuthenticationCubit>().state == null;
      if (needToSignIn) {
        SnackBarHelper.failure(context, 'Por favor, realize login primeiro.');
        return;
      }

      await BasketsService()
        .addToBasket(productId, 1)
        .then((response) async
      {
        SnackBarHelper.success(context, 'Produto adicionado ao seu carrinho com sucesso.');
      },
      onError: (error) {
        SnackBarHelper.failure(context, error.toString());
      });
    }

    if (showCart) {
      return Container(
        padding: const EdgeInsets.only(left: 20, right: 10),
        child: Row(
          children: [
            const Icon(
              Icons.favorite_border,
              color: Color(0x0ffe5e5e)
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF74AA50),
                elevation: 0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)
                    ),
                    side: BorderSide(color: Color(0xFFfef2f2))
                )
              ),
              onPressed: () async => onAddToBasketButtonPressed(),
              child: Text(
                'Adicionar ao carrinho'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white
                )
              ),
            )
          ],
        )
      );
    }

    return Container(
        padding: const EdgeInsets.only(left: 20, right: 10),
        child: Row(
          children: const [
            Icon(
                Icons.favorite_border,
                color: Color(0x0ffe5e5e)
            ),
            Spacer()
          ],
        )
    );
  }
}

Widget createDetailView(BuildContext context, AsyncSnapshot snapshot) {
  ProductModel productModel = snapshot.data;
  return DetailScreen(productModel);
}

class DetailScreen extends StatefulWidget {
  final ProductModel product;

  const DetailScreen(this.product, {super.key});

  @override
  DetailScreenState createState() => DetailScreenState();
}

class DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    var isAvailable = widget.product.isAvailable();
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.network(
            widget.product.imageUrl,
            width: 500,
            height: 500,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              var expectedBytes = loadingProgress.expectedTotalBytes;
              return Center(
                child: CircularProgressIndicator(
                  value: expectedBytes != null ?
                    loadingProgress.cumulativeBytesLoaded / expectedBytes : null
                )
              );
            }
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: const Color(0xFFFFFFFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "SKU".toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF656565)
                  )
                ),
                Text(
                  widget.product.id,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF74AA50)
                  )
                )
              ],
            )
          ),
          Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
              color: const Color(0xFFFFFFFF),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "Nome".toUpperCase(),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF656565)
                      )
                  ),
                  Flexible(
                      child: Text(
                          widget.product.name,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF74AA50)
                          )
                      )
                  )
                ],
              )
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: const Color(0xFFFFFFFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Preço".toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF656565)
                  )
                ),
                Text(
                  isAvailable ? widget.product.currencyText() : 'Indisponível',
                  style: TextStyle(
                      color: (isAvailable)
                          ? const Color(0xFF77AF4D)
                          : const Color(0xFF454A3E),
                      fontFamily: 'Roboto-Light.ttf',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                  )
                )
              ],
            )
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: const Color(0x0fffffff),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Descrição".toUpperCase(),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF656565)
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  widget.product.description,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff4c4c4c)
                  ),
                )
              ],
            )
          )
        ],
      )
    );
  }
}

Future<ProductModel> getDetailData(String productId) async {
  return await CatalogService().getDetails(productId);
}