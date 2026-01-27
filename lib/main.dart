import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; // 引用你之前配置好的文件

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const LoveMenuApp());
}

class LoveMenuApp extends StatelessWidget {
  const LoveMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YYH & YY Private Kitchen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
      ),
      home: const MainOrderPage(),
    );
  }
}

class MainOrderPage extends StatefulWidget {
  const MainOrderPage({super.key});

  @override
  State<MainOrderPage> createState() => _MainOrderPageState();
}

class _MainOrderPageState extends State<MainOrderPage> {
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'YY 的专属点餐台',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () {
              // 这里以后可以跳转管理端
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // 1. 左侧专业分类栏
          NavigationRail(
            selectedIndex: _selectedCategoryIndex,
            onDestinationSelected: (index) =>
                setState(() => _selectedCategoryIndex = index),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.wb_sunny),
                label: Text('早起惊喜'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.restaurant),
                label: Text('主厨招牌'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.icecream),
                label: Text('甜蜜饭后'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // 2. 右侧实时菜品列表
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // 从 Firebase 实时获取对应分类的菜品
              stream: FirebaseFirestore.instance
                  .collection('dishes')
                  .where('categoryIndex', isEqualTo: _selectedCategoryIndex)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Center(child: Text('加载失败'));
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final dishes = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: dishes.length,
                  itemBuilder: (context, index) {
                    var dish = dishes[index].data() as Map<String, dynamic>;
                    return DishCard(
                      name: dish['name'] ?? '未知菜名',
                      price: dish['price']?.toString() ?? '520',
                      imageUrl:
                          dish['imageUrl'] ?? 'https://via.placeholder.com/150',
                      rating: dish['rating']?.toDouble() ?? 5.0,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 菜品卡片组件
class DishCard extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;
  final double rating;

  const DishCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Text('$rating 分'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '¥ $price',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // 点菜逻辑
              },
              child: const Text('点它'),
            ),
          ],
        ),
      ),
    );
  }
}
