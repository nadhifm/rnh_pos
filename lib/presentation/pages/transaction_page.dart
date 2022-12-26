import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rnh_pos/presentation/pages/confirmation_transaction_page.dart';
import 'package:rnh_pos/presentation/provider/transaction_notifier.dart';
import 'package:rnh_pos/presentation/provider/transaction_notifier.dart';
import 'package:rnh_pos/presentation/widgets/custom_text_field.dart';
import 'package:rnh_pos/presentation/widgets/custom_tab.dart';
import 'package:rnh_pos/presentation/widgets/minus_plus_quantity.dart';
import 'package:rnh_pos/presentation/widgets/product_widget.dart';
import '../../commont/state_enum.dart';
import '../../domain/entities/category.dart';
import '../widgets/custom_icon_button.dart';
import '../widgets/primary_button.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TransactionNotifier>(context, listen: false).getCategories();
      Provider.of<TransactionNotifier>(context, listen: false).getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return SafeArea(
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: const Color(0xFFEDE6DB),
                automaticallyImplyLeading: false,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(131),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomIconButton(
                                height: 30.0,
                                width: 30.0,
                                asset: "assets/ic_drawer.svg",
                                onTap: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              ),
                              Text(
                                "Transaksi",
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: const Color(0xFF1A3C40),
                                    fontWeight: FontWeight.w600),
                              ),
                              Container(
                                width: 30.0,
                                height: 30.0,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: CustomTextField(
                            controller: controller,
                            hint: "Cari Produk",
                            inputType: TextInputType.text,
                            asset: "assets/ic_search.svg",
                            onChanged: (value) {
                              Provider.of<TransactionNotifier>(context, listen: false).searchProduct(value);
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Consumer<TransactionNotifier>(
                          builder: (context, data, child) {
                            final state = data.getCategoriesState;
                            if (state == RequestState.Loaded) {
                              final categories = [
                                const Category(id: "", name: "Semua")
                              ];
                              categories.addAll(data.categories);
                              return SizedBox(
                                height: 37,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (_, index) {
                                    final category = categories[index];
                                    return CustomTab(
                                      selectedTab: data.selectedTab,
                                      category: category,
                                      onTap: () {
                                        data.setSelectedTab(category.id, controller.text);
                                      },
                                    );
                                  },
                                  itemCount: categories.length,
                                ),
                              );
                            } else {
                              return const SizedBox(
                                height: 37,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Consumer<TransactionNotifier>(
                builder: (context, data, child) {
                  final state = data.getProductsState;
                  if (state == RequestState.Loading) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF1A3C40),
                        ),
                      ),
                    );
                  } else if (state == RequestState.Loaded) {
                    final products = data.filteredProducts;
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final product = products[index];
                          final indexCart = data.checkCart(product.id);
                          return ProductWidget(
                            product: products[index],
                            action: MinusPlusQuantity(
                              minusOnTap: () {
                                data.minusQuantity(product.id);
                              },
                              plusOnTap: () {
                                data.plusQuantity(product.id);
                              },
                              quantity: indexCart == -1 ? 0 : data.carts[indexCart].quantity,
                            ),
                          );
                        },
                        childCount: products.length,
                      ),
                    );
                  } else {
                    return const SliverToBoxAdapter(
                      child: SizedBox(
                        width: 200,
                        height: 200,
                      ),
                    );
                  }
                },
              ),
              const SliverPadding(padding: EdgeInsets.symmetric(vertical: 50)),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PrimaryButton(
                  text: "Lanjutkan",
                  onPressed: () {
                    final cartsSize = Provider.of<TransactionNotifier>(context, listen: false).carts.length;
                    if (cartsSize > 0) {
                      Navigator.pushNamed(
                          context, ConfirmationTransactionPage.ROUTE_NAME);
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Pilih Produk Terlebih Dahulu")));
                    }
                  },
                )),
          ),
        ],
      ),
    );
  }
}
