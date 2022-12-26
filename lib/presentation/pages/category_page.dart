import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rnh_pos/domain/entities/category.dart';
import 'package:rnh_pos/presentation/provider/category_notifier.dart';
import 'package:rnh_pos/presentation/widgets/custom_icon_button.dart';
import 'package:rnh_pos/presentation/widgets/primary_button.dart';
import 'package:rnh_pos/presentation/widgets/secondary_button.dart';

import '../../commont/state_enum.dart';
import '../widgets/category_widget.dart';
import '../widgets/custom_text_field.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CategoryNotifier>(context, listen: false).getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
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
                preferredSize: const Size.fromHeight(75),
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
                              "Kategori",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: const Color(0xFF1A3C40),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
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
                          controller: searchController,
                          hint: "Cari Kategori",
                          inputType: TextInputType.text,
                          asset: "assets/ic_search.svg",
                          onChanged: (value) {
                            Provider.of<CategoryNotifier>(context, listen: false)
                                .searchCategory(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Consumer<CategoryNotifier>(builder: (context, data, child) {
              final state = data.getCategoriesState;
              if (state == RequestState.Loading) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF1A3C40),
                    ),
                  ),
                );
              } else if (state == RequestState.Loaded) {
                final categories = data.filteredCategories;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final category = categories[index];
                      return CategoryWidget(
                        category: category,
                        editOnTap: () {
                          addEditCategory(category);
                        },
                        deleteOnTap: () async {
                          showLoadingDialog();
                          await Provider.of<CategoryNotifier>(context,
                                  listen: false)
                              .deleteCategory(category.id);

                          if (!mounted) return;
                          final state = Provider.of<CategoryNotifier>(
                            context,
                            listen: false,
                          ).state;
                          if (state == RequestState.Loaded) {
                            final message = Provider.of<CategoryNotifier>(
                              context,
                              listen: false,
                            ).message;
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(message)));
                          } else if (state == RequestState.Error) {
                            final message = Provider.of<CategoryNotifier>(
                              context,
                              listen: false,
                            ).message;
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(message)));
                          }

                          Provider.of<CategoryNotifier>(context, listen: false)
                              .getCategories();
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    childCount: categories.length,
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
            }),
            const SliverPadding(padding: EdgeInsets.symmetric(vertical: 40.0))
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PrimaryButton(
                text: "Tambah Kategori",
                onPressed: () {
                  addEditCategory(null);
                },
              )),
        ),
      ],
    ));
  }

  void addEditCategory(Category? category) async {
    await showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        if (category != null) {
          controller.text = category.name;
        }
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  category == null ? 'Tambah Kategori' : "Update Kategori",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: const Color(0xFF1A3C40),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: controller,
                  hint: "Nama Kategori",
                  inputType: TextInputType.text,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 130,
                      child: SecondaryButton(
                        text: "Batal",
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 130,
                      child: PrimaryButton(
                        text: category == null ? 'Tambah' : "Update",
                        onPressed: () {
                          Navigator.of(context).pop(controller.text);
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
          if (category != null) {
            if (value == category.name) return;
            showLoadingDialog();
            await Provider.of<CategoryNotifier>(context, listen: false)
                .updateCategory(category.id, value);
          } else {
            showLoadingDialog();
            await Provider.of<CategoryNotifier>(context, listen: false)
                .addCategory(value);
          }

          if (!mounted) return;
          final state = Provider.of<CategoryNotifier>(
            context,
            listen: false,
          ).state;
          if (state == RequestState.Loaded) {
            final message = Provider.of<CategoryNotifier>(
              context,
              listen: false,
            ).message;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
          } else if (state == RequestState.Error) {
            final message = Provider.of<CategoryNotifier>(
              context,
              listen: false,
            ).message;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
          }

          Provider.of<CategoryNotifier>(context, listen: false).getCategories();
          Navigator.of(context).pop();
        }
      },
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
