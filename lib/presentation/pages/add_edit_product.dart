import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rnh_pos/domain/entities/product.dart';
import 'package:rnh_pos/presentation/provider/add_edit_product_notifier.dart';
import 'package:rnh_pos/presentation/provider/product_notifier.dart';
import 'package:rnh_pos/presentation/widgets/custom_text_field.dart';

import '../../commont/state_enum.dart';
import '../../domain/entities/category.dart';
import '../widgets/custom_icon_button.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';

class AddEditProduct extends StatefulWidget {
  static const ROUTE_NAME = '/add-edit-product';

  final Product? product;

  const AddEditProduct({Key? key, required this.product}) : super(key: key);

  @override
  State<AddEditProduct> createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProduct> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AddEditProductNotifier>(
        context,
        listen: false,
      ).getCategories();
      Provider.of<AddEditProductNotifier>(
        context,
        listen: false,
      ).resetImageFile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final sellingPriceController = TextEditingController();
    final purchasePriceController = TextEditingController();
    final stockController = TextEditingController();

    if (widget.product != null) {
      nameController.text = widget.product!.name;
      sellingPriceController.text = widget.product!.sellingPrice.toString();
      purchasePriceController.text = widget.product!.purchasePrice.toString();
      stockController.text = widget.product!.stock.toString();
    }

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: const Color(0xFFEDE6DB),
              automaticallyImplyLeading: false,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(6),
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
                              asset: "assets/ic_back.svg",
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            Text(
                              widget.product == null
                                  ? "Tambah Produk"
                                  : "Update Produk",
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: const Color(0xFF1A3C40),
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              width: 30.0,
                              height: 30.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(top: 8.0)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: Stack(
                        children: [
                          Align(
                            alignment: AlignmentDirectional.center,
                            child: Consumer<AddEditProductNotifier>(
                              builder: (context, data, child) {
                                final product = widget.product;
                                final imageFile = data.imageFile;
                                if (imageFile != null) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.file(
                                      imageFile,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                } else {
                                  if (product != null && product.imageUrl != "") {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        product.imageUrl,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      height: 100,
                                      width: 100,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.0)),
                                        color: Color(0x40417D7A),
                                      ),
                                      child: Center(
                                        child: Text(
                                          product != null
                                              ? product.name
                                              .substring(0, 2)
                                              .toUpperCase()
                                              : "PR",
                                          style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              color: const Color(0xFF1A3C40),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.bottomEnd,
                            child: InkWell(
                              onTap: () async {
                                showDialog<ImageSource>(
                                  context: context,
                                  builder: (context) => Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Pilih Gambar",
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              color: const Color(0xFF1A3C40),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context,
                                                      ImageSource.gallery);
                                                },
                                                child: Column(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/ic_gallery.svg",
                                                      width: 36,
                                                      height: 36,
                                                    ),
                                                    const SizedBox(
                                                      height: 16.0,
                                                    ),
                                                    Text(
                                                      "Galeri",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        color: const Color(
                                                            0xFF1A3C40),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context,
                                                      ImageSource.camera);
                                                },
                                                child: Column(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/ic_camera_solid.svg",
                                                      width: 36,
                                                      height: 36,
                                                    ),
                                                    const SizedBox(
                                                      height: 16.0,
                                                    ),
                                                    Text(
                                                      "Kamera",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        color: const Color(
                                                            0xFF1A3C40),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ).then((value) async {
                                  if (value != null) {
                                    final pickedFile = await ImagePicker()
                                        .pickImage(source: value);
                                    if (pickedFile != null) {
                                      if (!mounted) return;
                                      Provider.of<AddEditProductNotifier>(
                                        context,
                                        listen: false,
                                      ).setImageFile(File(pickedFile.path));
                                    }
                                  }
                                });
                              },
                              child: Container(
                                height: 32.0,
                                width: 32.0,
                                padding: EdgeInsets.all(4.0),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1A3C40),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(
                                    8.0,
                                  )),
                                ),
                                child: SvgPicture.asset("assets/ic_camera.svg"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    CustomTextField(
                      controller: nameController,
                      hint: "Nama Produk",
                      inputType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    CustomTextField(
                      controller: purchasePriceController,
                      hint: "Harga Beli",
                      inputType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    CustomTextField(
                      controller: sellingPriceController,
                      hint: "Harga Jual",
                      inputType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Consumer<AddEditProductNotifier>(
                            builder: (context, data, child) {
                              final categories = [
                                const Category(id: "", name: "Default")
                              ];
                              categories.addAll(data.categories);
                              return DropdownButtonFormField(
                                value: widget.product != null
                                    ? widget.product?.categoryId
                                    : "",
                                items: categories
                                    .map((category) => DropdownMenuItem(
                                          value: category.id,
                                          child: Text(
                                            category.name,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: const Color(0xFF1A3C40),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    data.setCategoryId(val);
                                  }
                                },
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: const Color(0xFF1A3C40),
                                ),
                                icon:
                                    SvgPicture.asset("assets/ic_drop_down.svg"),
                                dropdownColor: const Color(0xFFEDE6DB),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      top: 16.0,
                                      bottom: 16.0,
                                      left: 16.0,
                                      right: 8.0),
                                  isDense: true,
                                  filled: true,
                                  fillColor: Color(0x40417D7A),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 16.0,
                        ),
                        InkWell(
                          onTap: () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                final controller = TextEditingController();
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Tambah Kategori',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            color: const Color(0xFF1A3C40),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        CustomTextField(
                                            controller: controller,
                                            hint: "Nama Kategori",
                                            inputType: TextInputType.text),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: SecondaryButton(
                                                text: "Batal",
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 16.0,
                                            ),
                                            Expanded(
                                              child: PrimaryButton(
                                                text: 'Tambah',
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(controller.text);
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ).then(
                              (value) async {
                                if (value != null) {
                                  showLoadingDialog();
                                  await Provider.of<AddEditProductNotifier>(
                                          context,
                                          listen: false)
                                      .addCategory(value);

                                  if (!mounted) return;
                                  final state =
                                      Provider.of<AddEditProductNotifier>(
                                    context,
                                    listen: false,
                                  ).state;
                                  if (state == RequestState.Loaded) {
                                    final message =
                                        Provider.of<AddEditProductNotifier>(
                                      context,
                                      listen: false,
                                    ).message;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(message)));
                                  } else if (state == RequestState.Error) {
                                    final message =
                                        Provider.of<AddEditProductNotifier>(
                                      context,
                                      listen: false,
                                    ).message;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(message)));
                                  }

                                  Provider.of<AddEditProductNotifier>(context,
                                          listen: false)
                                      .getCategories();
                                  Navigator.of(context).pop();
                                }
                              },
                            );
                          },
                          child: Container(
                            height: 50.0,
                            width: 50.0,
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  16.0,
                                ),
                              ),
                              color: const Color(0xFF1A3C40),
                            ),
                            child: SvgPicture.asset(
                              "assets/ic_plus.svg",
                              color: const Color(0xFFEDE6DB),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    CustomTextField(
                      controller: stockController,
                      hint: "Stok",
                      inputType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    PrimaryButton(
                      text: "Simpan",
                      onPressed: () async {
                        final name = nameController.text;
                        final purchasePrice =
                            int.parse(purchasePriceController.text);
                        final sellingPrice =
                            int.parse(sellingPriceController.text);
                        final categoryId = Provider.of<AddEditProductNotifier>(
                                context,
                                listen: false)
                            .categoryId;
                        final stock = int.parse(stockController.text);
                        final imageFile = Provider.of<AddEditProductNotifier>(
                                context,
                                listen: false)
                            .imageFile;

                        final product = widget.product;
                        if (name == product?.name &&
                            purchasePrice == product?.purchasePrice &&
                            sellingPrice == product?.sellingPrice &&
                            categoryId == product?.categoryId &&
                            stock == product?.stock &&
                            imageFile == null) {
                          Navigator.of(context).pop();
                          return;
                        } else {
                          showLoadingDialog();

                          if (widget.product != null) {
                            await Provider.of<AddEditProductNotifier>(
                              context,
                              listen: false,
                            ).updateProduct(
                              product!.id,
                              name,
                              product.imageUrl,
                              purchasePrice,
                              sellingPrice,
                              stock,
                            );
                          } else {
                            await Provider.of<AddEditProductNotifier>(
                              context,
                              listen: false,
                            ).addProduct(
                              name,
                              "",
                              purchasePrice,
                              sellingPrice,
                              stock,
                            );
                          }
                        }

                        if (!mounted) return;

                        final state = Provider.of<AddEditProductNotifier>(
                                context,
                                listen: false)
                            .state;
                        if (state == RequestState.Loaded) {
                          Navigator.pop(context);
                          final message = Provider.of<AddEditProductNotifier>(
                                  context,
                                  listen: false)
                              .message;
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(message)));
                          Provider.of<ProductNotifier>(context, listen: false)
                              .getProducts();
                        } else if (state == RequestState.Error) {
                          Navigator.pop(context);
                          final message = Provider.of<AddEditProductNotifier>(
                                  context,
                                  listen: false)
                              .message;
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(message)));
                        }

                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                color: Colors.white,
              ),
              height: 120,
              width: 120,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
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
                        color: const Color(0xFF1A3C40),
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
