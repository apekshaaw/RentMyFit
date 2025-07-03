import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_my_fit/features/auth/presentation/view/login_view.dart';
import '../view_model/dashboard_event.dart';
import '../view_model/dashboard_state.dart';
import '../view_model/dashboard_view_model.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardViewModel()..add(LoadDashboard()),
      child: const DashboardContent(),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardViewModel, DashboardState>(
      builder: (context, state) {
        int currentIndex = 0;
        if (state is DashboardLoaded) {
          currentIndex = state.currentIndex;
        }

        final List<Widget> screens = [
          _buildHomePage(),
          const Center(child: Text("Wishlist")),
          const Center(child: Text("Profile")),
        ];

        return Scaffold(
          appBar: AppBar(
  title: const Text('DASHBOARD'),
  backgroundColor: const Color(0xFFab1d79),
  centerTitle: true,
  automaticallyImplyLeading: false,
  actions: [
    IconButton(
      icon: const Icon(Icons.logout, color: Colors.white),
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginView()),
          (route) => false,
        );
      },
    ),
  ],
),


          body: screens[currentIndex],
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(color: Color(0x80123456), blurRadius: 10),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                selectedItemColor: const Color(0xFFab1d79),
                unselectedItemColor: Colors.black,
                backgroundColor: Colors.transparent,
                elevation: 0,
                onTap: (index) {
                  context.read<DashboardViewModel>().add(ChangeTab(index));
                },
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
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
                    icon: Icon(Icons.person_outline, size: 30),
                    label: '',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHomePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Popular',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFFab1d79),
                ),
              ),
              Text('Shoes', style: TextStyle(fontSize: 16, color: Colors.grey)),
              Text('Womens', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
          const Divider(color: Color(0xFFab1d79), thickness: 2, endIndent: 260),
          const SizedBox(height: 20),

          // Filter & Sort
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'FILTER & SORT',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Icon(Icons.grid_view),
                  SizedBox(width: 10),
                  Icon(Icons.list),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Grid Products
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    final items = [
                      {
                        "title": "Striped Shirt Dress ZW Collection",
                        "price": "\$05.00 USD",
                        "image": "assets/images/dress.png"
                      },
                      {
                        "title": "Rhinestone Slingback High Heels",
                        "price": "\$05.00 USD",
                        "image": "assets/images/heels.png"
                      },
                      {
                        "title": "Laila Medium Signature Logo Satchel",
                        "price": "\$20.00 USD",
                        "image": "assets/images/bag.png"
                      },
                      {
                        "title": "DiorCannage R1U",
                        "price": "\$30.00 USD",
                        "image": "assets/images/sunglasses.png"
                      },
                    ];
                    final item = items[index];
                    return _buildProductCard(
                        item["title"]!, item["price"]!, item["image"]!);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(String title, String price, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFFF3F3F3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.asset(
                  imagePath,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.favorite_border),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFab1d79),
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
