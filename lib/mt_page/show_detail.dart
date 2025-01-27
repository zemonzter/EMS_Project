import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowDetail extends StatefulWidget {
  final String id;
  final String name;
  final String image;
  final String stock;
  final String unit;
  final String url;

  const ShowDetail({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.stock,
    required this.unit,
    required this.url,
  });

  @override
  State<ShowDetail> createState() => _ShowDetailState();
}

class _ShowDetailState extends State<ShowDetail> {
  int _quantity = 1;

  Future<void> _launchUrl() async {
    if (widget.url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No more details available!'),
        ),
      );
      return;
    }

    if (!await launchUrl(Uri.parse(widget.url))) {
      throw Exception('Could not launch ${widget.url}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.image,
                    width: 400,
                    height: 350,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                widget.name,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text('คงเหลือ: ${widget.stock} ${widget.unit}'),
              const Divider(thickness: 1.0),
              const SizedBox(height: 8.0),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text('จำนวน:'),
              //     Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         IconButton(
              //           icon: const Icon(Icons.remove),
              //           onPressed: _decrementQuantity,
              //           disabledColor: Colors.grey,
              //         ),
              //         Text('$_quantity'),
              //         IconButton(
              //           icon: const Icon(Icons.add),
              //           onPressed: _incrementQuantity,
              //           disabledColor: Colors.grey,
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     foregroundColor: Colors.white,
                  //     backgroundColor: Colors.green,
                  //   ),
                  //   onPressed: () {
                  //     // Handle adding to cart logic
                  //     print('Added $_quantity ${widget.name} to cart!');
                  //   },
                  //   child: const Text('หยิบใส่ตะกร้า'),
                  // ),
                  OutlinedButton(
                    onPressed: _launchUrl,
                    child: const Text('View More'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _incrementQuantity() {
    if (_quantity < int.parse(widget.stock)) {
      setState(() {
        _quantity++;
      });
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }
}
