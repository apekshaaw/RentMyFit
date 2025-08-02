import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/app/service_locator.dart';
import 'package:rent_my_fit/app/theme_notifier.dart';
import 'package:rent_my_fit/features/auth/presentation/view/login_view.dart';
import 'package:rent_my_fit/features/cart/presentation/view model/cart_event.dart';
import 'package:rent_my_fit/features/cart/presentation/view model/cart_view_model.dart';
import 'package:rent_my_fit/features/cart/presentation/view/cart_view.dart';
import 'package:rent_my_fit/features/home/data/models/product_model.dart';
import 'package:rent_my_fit/features/home/presentation/view/add_product_view.dart';
import 'package:rent_my_fit/features/home/presentation/view/product_detail_view.dart';
import 'package:rent_my_fit/features/home/presentation/view_model/product_view_model.dart';
import 'package:rent_my_fit/features/profile/presentation/view/profile_view.dart';
import 'package:rent_my_fit/features/wishlist/presentation/view/wishlist_view.dart';

// ✅ Import your sensor services
import 'package:rent_my_fit/sensors/shake_service.dart';
import 'package:rent_my_fit/sensors/proximity_service.dart';

class DashboardView extends StatelessWidget {
  final bool isAdmin;

  const DashboardView({Key? key, required this.isAdmin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductViewModel>(
          create: (_) => sl<ProductViewModel>()
            ..fetchProducts()
            ..fetchWishlist(),
        ),
        BlocProvider<CartViewModel>(
          create: (_) => sl<CartViewModel>()..add(LoadCart()),
        ),
      ],
      child: DashboardContent(isAdmin: isAdmin),
    );
  }
}

class DashboardContent extends StatefulWidget {
  final bool isAdmin;

  const DashboardContent({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  int _selectedIndex = 0;
  String? profileImageUrl; // Track profile image if updated

  @override
  void initState() {
    super.initState();

    // ✅ Start Shake Listener
    ShakeService().start();
    ShakeService().onShake.listen((_) {
      _showLogoutDialog(context);
    });

    // ✅ Start Proximity Listener
    ProximityService().start();
    ProximityService().onProximity.listen((isNear) {
      if (isNear) {
        themeNotifier.toggleTheme();
      }
    });

    // TODO: Load your profile image from Hive, API, or local storage
    // Example: profileImageUrl = await UserLocalDataSource().getProfileImage();
  }

  @override
  void dispose() {
    ShakeService().dispose();
    ProximityService().dispose();
    super.dispose();
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFFab1d79)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              Future.delayed(const Duration(milliseconds: 100), () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginView()),
                  (_) => false,
                );
              });
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _buildHomeTab(),
      const WishlistView(),
      BlocProvider.value(
        value: context.read<CartViewModel>()..add(LoadCart()),
        child: const CartView(),
      ),
    ];

    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              title: const Text('DASHBOARD'),
              backgroundColor: const Color(0xFFab1d79),
              centerTitle: true,
              automaticallyImplyLeading: false,
              actions: [
                // 🌙 / ☀️ Theme toggle button
                IconButton(
                  icon: ValueListenableBuilder<ThemeMode>(
                    valueListenable: themeNotifier,
                    builder: (_, mode, __) {
                      return Icon(
                        mode == ThemeMode.dark
                            ? Icons.wb_sunny_outlined
                            : Icons.nights_stay_outlined,
                        color: Colors.white,
                      );
                    },
                  ),
                  onPressed: () => themeNotifier.toggleTheme(),
                ),

                // ✅ Dynamic profile button with fallback icon
                IconButton(
                  icon: profileImageUrl != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(profileImageUrl!),
                          radius: 15,
                        )
                      : const Icon(Icons.person_outline, color: Colors.white),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfileView()),
                    );
                    // Reload image after returning from profile page
                    setState(() {
                      // profileImageUrl = reload from storage if updated
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () => _showLogoutDialog(context),
                ),
              ],
            )
          : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: tabs,
      ),
      floatingActionButton: widget.isAdmin && _selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: const Color(0xFFab1d79),
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddProductView()),
                );
              },
            )
          : null,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [BoxShadow(color: Color(0x80123456), blurRadius: 10)],
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xFFab1d79),
            unselectedItemColor: Colors.black,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (index) {
              if (index == 3) {
                Navigator.of(context).pushNamed('/profile');
              } else {
                setState(() => _selectedIndex = index);
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 30),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border, size: 30),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined, size: 30),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 30),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return BlocBuilder<ProductViewModel, List<ProductModel>>(
      builder: (context, products) {
        final viewModel = context.read<ProductViewModel>();
        final wishlistIds = viewModel.wishlistIds;

        if (products.isEmpty) {
          return const Center(child: Text('No products available.'));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              final isFavorite = wishlistIds.contains(product.id);
              return _buildProductCard(product, isFavorite, viewModel, context);
            },
          ),
        );
      },
    );
  }

  Widget _buildProductCard(
    ProductModel product,
    bool isFavorite,
    ProductViewModel viewModel,
    BuildContext context,
  ) {
    return StatefulBuilder(
      builder: (context, setState) => Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFFF3F3F3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.network(
                      product.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${product.price}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailView(product: product),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFab1d79),
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            minimumSize: const Size(100, 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'View Details',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () async {
                await viewModel.toggleWishlist(product.id);
                await viewModel.fetchWishlist();
                setState(() {});
                final updatedFavorite = viewModel.isInWishlist(product.id);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      updatedFavorite
                          ? 'Added to wishlist'
                          : 'Removed from wishlist',
                    ),
                    backgroundColor:
                        updatedFavorite ? Colors.green : Colors.red,
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              child: Icon(
                viewModel.isInWishlist(product.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: viewModel.isInWishlist(product.id)
                    ? const Color(0xFFab1d79)
                    : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}