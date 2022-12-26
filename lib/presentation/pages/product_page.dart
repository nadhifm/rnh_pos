import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rnh_pos/presentation/pages/add_edit_product.dart';
import 'package:rnh_pos/presentation/provider/product_notifier.dart';
import 'package:rnh_pos/presentation/widgets/custom_icon_button.dart';

import '../../commont/state_enum.dart';
import '../../domain/entities/category.dart';
import '../widgets/custom_tab.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/edit_delete.dart';
import '../widgets/primary_button.dart';
import '../widgets/product_widget.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProductNotifier>(context, listen: false).getCategories();
      Provider.of<ProductNotifier>(context, listen: false).getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
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
                                "Produk",
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
                              Provider.of<ProductNotifier>(context, listen: false).searchProduct(value);
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Consumer<ProductNotifier>(
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
              Consumer<ProductNotifier>(
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
                          return ProductWidget(
                            product: product,
                            action: EditDelete(
                              editOnTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AddEditProduct.ROUTE_NAME,
                                  arguments: product,
                                );
                              },
                              deleteOnTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Material(
                                      color: Colors.transparent,
                                      child: Center(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16.0)),
                                            color: Colors.white,
                                          ),
                                          height: 120,
                                          width: 120,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              const CircularProgressIndicator(
                                                color: Color(0xFF1A3C40),
                                              ),
                                              const SizedBox(
                                                height: 16.0,
                                              ),
                                              Text(
                                                "Loading",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    color:
                                                    const Color(0xFF1A3C40),
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );

                                await Provider.of<ProductNotifier>(context,
                                    listen: false)
                                    .deleteProduct(product.id);

                                if (!mounted) return;

                                final state = Provider.of<ProductNotifier>(
                                  context,
                                  listen: false,
                                ).deleteProductState;
                                if (state == RequestState.Loaded) {
                                  final message = Provider.of<ProductNotifier>(
                                    context,
                                    listen: false,
                                  ).message;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)));
                                  Provider.of<ProductNotifier>(context,
                                      listen: false)
                                      .getProducts();
                                } else if (state == RequestState.Error) {
                                  final message = Provider.of<ProductNotifier>(
                                    context,
                                    listen: false,
                                  ).message;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)));
                                }

                                Navigator.pop(context);
                              },
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
                padding: EdgeInsets.all(16.0),
                child: PrimaryButton(
                  text: "Tambah Produk",
                  onPressed: () {
                    Navigator.pushNamed(context, AddEditProduct.ROUTE_NAME);
                  },
                )),
          ),
        ],
      ),
    );
  }
}
