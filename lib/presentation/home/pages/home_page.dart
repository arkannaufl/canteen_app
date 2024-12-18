import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/pages/login_page.dart';
import '../bloc/logout/logout_bloc.dart';

part '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  final indexValue = ValueNotifier(0);

  void onCategoryTap(int index) {
    searchController.clear();
    indexValue.value = index;

    String category = 'all';
    switch (index) {
      case 0:
        category = 'all';
        break;
      case 1:
        category = 'drink';
        break;
      case 2:
        category = 'food';
        break;
      case 3:
        category = 'snack';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView(
        children: [
          Row(
            children: [
              const AppTile(text: 'Catalog'),
              const Spacer(),
              BlocConsumer<LogoutBloc, LogoutState>(
                listener: (context, state) {
                  if (state is LogoutSuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  }

                  if (state is LogoutFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return IconButton(
                    onPressed: () {
                      context.read<LogoutBloc>().add(LogoutButtonPressed());
                    },
                    icon: const Icon(Icons.logout),
                    color: Color(0xFF0F172A), // Set default color
                  );
                },
              ),
            ],
          ),
          const SpaceHeight(18.0),
          CustomTextField(
            controller: searchController,
            hintText: 'Search..',
            prefixIcon: Assets.icons.search.svg(
              colorFilter: const ColorFilter.mode(Color(0xFF0F172A), BlendMode.srcIn),
            ),
          ),
          const SpaceHeight(24.0),
          ValueListenableBuilder(
            valueListenable: indexValue,
            builder: (context, index, _) => Row(
              children: [
                MenuButton(
                  iconPath: Assets.icons.allCategories.svg(
                    width: 32.0,
                    height: 32.0,
                    colorFilter: ColorFilter.mode(
                      index == 0 ? Colors.white : Color(0xFF0F172A),
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'All',
                  isActive: index == 0,
                  onPressed: () => onCategoryTap(0),
                ),
                const SpaceWidth(10.0),
                MenuButton(
                  iconPath: Assets.icons.drink.svg(
                    colorFilter: ColorFilter.mode(
                      index == 1 ? Colors.white : Color(0xFF0F172A),
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Drink',
                  isActive: index == 1,
                  onPressed: () => onCategoryTap(1),
                ),
                const SpaceWidth(10.0),
                MenuButton(
                  iconPath: Assets.icons.food.svg(
                    colorFilter: ColorFilter.mode(
                      index == 2 ? Colors.white : Color(0xFF0F172A),
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Food',
                  isActive: index == 2,
                  onPressed: () => onCategoryTap(2),
                ),
                const SpaceWidth(10.0),
                MenuButton(
                  iconPath: Assets.icons.snack.svg(
                    colorFilter: ColorFilter.mode(
                      index == 3 ? Colors.white : Color(0xFF0F172A),
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Snack',
                  isActive: index == 3,
                  onPressed: () => onCategoryTap(3),
                ),
              ],
            ),
          ),
          const SpaceHeight(24.0),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 25.0,
              crossAxisSpacing: 25.0,
              childAspectRatio: 0.8,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) => const ProductCard(),
          ),
          const SizedBox(height: 30,)
        ],
      ),
    );
  }
}
