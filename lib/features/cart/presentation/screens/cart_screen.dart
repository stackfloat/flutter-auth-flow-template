import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';
import 'package:furniture_ecommerce_app/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:furniture_ecommerce_app/features/cart/presentation/widgets/cart_summary_section.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<_CartItemUiModel> _items = const [
    _CartItemUiModel(
      id: '1',
      title: 'Atelier Ottoman Takumi Series',
      price: 39.70,
      colorName: 'Green',
      color: Color(0xFF1C5C4A),
      quantity: 1,
      imagePath: 'assets/images/products/product_5.jpeg',
    ),
    _CartItemUiModel(
      id: '3',
      title: 'Chair Side End Table',
      price: 48.40,
      colorName: 'Grey',
      color: Color(0xFF707070),
      quantity: 1,
      imagePath: 'assets/images/products/product_2.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final subtotal = _items.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    const shippingFee = 9.90;
    const estimateTax = 6.50;
    final total = subtotal + shippingFee + estimateTax;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
              itemCount: _items.length,
              separatorBuilder: (_, _) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final item = _items[index];
                return CartItemCard(
                  title: item.title,
                  price: item.price,
                  colorName: item.colorName,
                  color: item.color,
                  quantity: item.quantity,
                  imagePath: item.imagePath,
                  onDelete: () => _removeItem(item.id),
                  onDecrease: () => _updateQuantity(item.id, item.quantity - 1),
                  onIncrease: () => _updateQuantity(item.id, item.quantity + 1),
                );
              },
            ),
          ),
          CartSummarySection(
            subtotal: subtotal,
            shippingFee: shippingFee,
            estimateTax: estimateTax,
            total: total,
            onCheckout: () {},
          ),
        ],
      ),
    );
  }

  void _removeItem(String itemId) {
    setState(() {
      _items = _items.where((item) => item.id != itemId).toList();
    });
  }

  void _updateQuantity(String itemId, int quantity) {
    if (quantity < 1) return;
    setState(() {
      _items = _items
          .map(
            (item) =>
                item.id == itemId ? item.copyWith(quantity: quantity) : item,
          )
          .toList();
    });
  }
}

class _CartItemUiModel {
  final String id;
  final String title;
  final double price;
  final String colorName;
  final Color color;
  final int quantity;
  final String imagePath;

  const _CartItemUiModel({
    required this.id,
    required this.title,
    required this.price,
    required this.colorName,
    required this.color,
    required this.quantity,
    required this.imagePath,
  });

  _CartItemUiModel copyWith({int? quantity}) {
    return _CartItemUiModel(
      id: id,
      title: title,
      price: price,
      colorName: colorName,
      color: color,
      quantity: quantity ?? this.quantity,
      imagePath: imagePath,
    );
  }
}
