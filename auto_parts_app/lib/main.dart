import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartModel()),
      ],
      child: MaterialApp(
        title: 'Auto Parts Store',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const PartsHomePage(),
      ),
    );
  }
}

class Part {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final String brand;
  final String model;
  final int year;
  final String group;

  Part({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.brand,
    required this.model,
    required this.year,
    required this.group,
  });

  factory Part.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Part(
      id: doc.id,
      name: data['name'],
      price: (data['price'] as num).toDouble(),
      imageUrl: data['imageUrl'],
      description: data['description'] ?? '',
      brand: data['brand'],
      model: data['model'],
      year: data['year'],
      group: data['group'],
    );
  }
}

class CartItem {
  final Part part;
  int quantity;
  CartItem({required this.part, this.quantity = 1});
}

class CartModel extends ChangeNotifier {
  final List<CartItem> items = [];

  void add(Part part) {
    final existing = items.firstWhere(
      (element) => element.part.id == part.id,
      orElse: () => CartItem(part: part, quantity: 0),
    );
    if (existing.quantity == 0) {
      items.add(existing);
    }
    existing.quantity += 1;
    notifyListeners();
  }

  void remove(Part part) {
    items.removeWhere((element) => element.part.id == part.id);
    notifyListeners();
  }

  double get total =>
      items.fold(0, (sum, item) => sum + item.part.price * item.quantity);
}

class PartsHomePage extends StatefulWidget {
  const PartsHomePage({Key? key}) : super(key: key);
  @override
  State<PartsHomePage> createState() => _PartsHomePageState();
}

class _PartsHomePageState extends State<PartsHomePage> {
  String? brand;
  String? model;
  String? group;
  RangeValues yearRange = const RangeValues(2000, 2023);

  @override
  Widget build(BuildContext context) {
    final partsStream = FirebaseFirestore.instance
        .collection('parts')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto Parts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          FilterSection(
            onChanged: (b, m, g, r) => setState(() {
              brand = b;
              model = m;
              group = g;
              yearRange = r;
            }),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: partsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final parts = snapshot.data!.docs
                    .map((doc) => Part.fromDoc(doc))
                    .where((part) {
                      final inYearRange = part.year >= yearRange.start && part.year <= yearRange.end;
                      final matchesBrand = brand == null || part.brand == brand;
                      final matchesModel = model == null || part.model == model;
                      final matchesGroup = group == null || part.group == group;
                      return inYearRange && matchesBrand && matchesModel && matchesGroup;
                    }).toList();
                return ListView.builder(
                  itemCount: parts.length,
                  itemBuilder: (context, index) {
                    final part = parts[index];
                    return ListTile(
                      leading: Image.network(part.imageUrl, width: 60),
                      title: Text(part.name),
                      subtitle: Text(part.description),
                      trailing: Text('\$${part.price.toStringAsFixed(2)}'),
                      onTap: () => context.read<CartModel>().add(part),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.chat),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChatScreen()),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Menu')),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Admin Panel'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminPanel()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterSection extends StatefulWidget {
  final Function(String?, String?, String?, RangeValues) onChanged;
  const FilterSection({Key? key, required this.onChanged}) : super(key: key);
  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  String? brand;
  String? model;
  String? group;
  RangeValues yearRange = const RangeValues(2000, 2023);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          DropdownButton<String>(
            hint: const Text('Brand'),
            value: brand,
            items: const [
              DropdownMenuItem(value: 'Hyundai', child: Text('Hyundai')),
              DropdownMenuItem(value: 'Kia', child: Text('Kia')),
              DropdownMenuItem(value: 'Toyota', child: Text('Toyota')),
            ],
            onChanged: (v) => setState(() {
              brand = v;
              widget.onChanged(brand, model, group, yearRange);
            }),
          ),
          DropdownButton<String>(
            hint: const Text('Model'),
            value: model,
            items: const [
              DropdownMenuItem(value: 'Sonata', child: Text('Sonata')),
              DropdownMenuItem(value: 'Elantra', child: Text('Elantra')),
              DropdownMenuItem(value: 'Corolla', child: Text('Corolla')),
            ],
            onChanged: (v) => setState(() {
              model = v;
              widget.onChanged(brand, model, group, yearRange);
            }),
          ),
          DropdownButton<String>(
            hint: const Text('Part Group'),
            value: group,
            items: const [
              DropdownMenuItem(value: 'Engine', child: Text('Engine')),
              DropdownMenuItem(value: 'Brakes', child: Text('Brakes')),
              DropdownMenuItem(value: 'Steering', child: Text('Steering')),
              DropdownMenuItem(value: 'Electrical', child: Text('Electrical')),
            ],
            onChanged: (v) => setState(() {
              group = v;
              widget.onChanged(brand, model, group, yearRange);
            }),
          ),
          RangeSlider(
            values: yearRange,
            min: 1990,
            max: DateTime.now().year.toDouble(),
            divisions: 30,
            labels: RangeLabels(
              yearRange.start.round().toString(),
              yearRange.end.round().toString(),
            ),
            onChanged: (v) => setState(() {
              yearRange = v;
              widget.onChanged(brand, model, group, yearRange);
            }),
          ),
        ],
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return ListTile(
                  title: Text(item.part.name),
                  trailing: Text('x${item.quantity}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Total: \$${cart.total.toStringAsFixed(2)}'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (FirebaseAuth.instance.currentUser == null) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PhoneAuthScreen()),
                );
              }
              // Add checkout logic here
            },
            child: const Text('Checkout'),
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Stream<QuerySnapshot> get messages => FirebaseFirestore.instance
      .collection('messages')
      .orderBy('timestamp')
      .snapshots();

  Future<void> sendMessage(String text, [XFile? image]) async {
    String? imageUrl;
    if (image != null) {
      final ref = FirebaseStorage.instance
          .ref('chat_images/${DateTime.now().millisecondsSinceEpoch}');
      await ref.putData(await image.readAsBytes());
      imageUrl = await ref.getDownloadURL();
    }
    await FirebaseFirestore.instance.collection('messages').add({
      'text': text,
      'imageUrl': imageUrl,
      'sender': FirebaseAuth.instance.currentUser?.uid ?? 'anon',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Support')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messages,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final docs = snapshot.data!.docs;
                return ListView(
                  children: docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      title: data['imageUrl'] != null
                          ? Image.network(data['imageUrl'])
                          : Text(data['text'] ?? ''),
                      subtitle: Text(data['sender'] ?? ''),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(hintText: 'Message'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: () async {
                  final image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) await sendMessage('', image);
                },
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  final text = _controller.text;
                  if (text.isNotEmpty) {
                    sendMessage(text);
                    _controller.clear();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);
  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String? verificationId;

  Future<void> verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      verificationCompleted: (cred) async {
        await FirebaseAuth.instance.signInWithCredential(cred);
        Navigator.pop(context);
      },
      verificationFailed: (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Error')),
        );
      },
      codeSent: (id, _) => setState(() => verificationId = id),
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<void> signInWithOtp() async {
    final cred = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: otpController.text,
    );
    await FirebaseAuth.instance.signInWithCredential(cred);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Login')),
      body: Column(
        children: [
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(hintText: '+123456789'),
          ),
          ElevatedButton(
            onPressed: verifyPhone,
            child: const Text('Send OTP'),
          ),
          if (verificationId != null) ...[
            TextField(
              controller: otpController,
              decoration: const InputDecoration(hintText: 'OTP'),
            ),
            ElevatedButton(
              onPressed: signInWithOtp,
              child: const Text('Verify'),
            ),
          ],
        ],
      ),
    );
  }
}

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);
  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? brand;
  String? model;
  int? year;
  String? group;
  XFile? image;
  final ImagePicker _picker = ImagePicker();

  Future<void> addProduct() async {
    if (!_formKey.currentState!.validate() || image == null) return;
    final ref = FirebaseStorage.instance
        .ref('product_images/${DateTime.now().millisecondsSinceEpoch}');
    await ref.putData(await image!.readAsBytes());
    final url = await ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('parts').add({
      'name': nameController.text,
      'price': double.parse(priceController.text),
      'description': descriptionController.text,
      'brand': brand,
      'model': model,
      'year': year,
      'group': group,
      'imageUrl': url,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product added')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            DropdownButtonFormField<String>(
              value: brand,
              hint: const Text('Brand'),
              items: const [
                DropdownMenuItem(value: 'Hyundai', child: Text('Hyundai')),
                DropdownMenuItem(value: 'Kia', child: Text('Kia')),
                DropdownMenuItem(value: 'Toyota', child: Text('Toyota')),
              ],
              onChanged: (v) => setState(() => brand = v),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Model'),
              onChanged: (v) => model = v,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Year'),
              keyboardType: TextInputType.number,
              onChanged: (v) => year = int.tryParse(v),
            ),
            DropdownButtonFormField<String>(
              value: group,
              hint: const Text('Group'),
              items: const [
                DropdownMenuItem(value: 'Engine', child: Text('Engine')),
                DropdownMenuItem(value: 'Brakes', child: Text('Brakes')),
                DropdownMenuItem(value: 'Steering', child: Text('Steering')),
                DropdownMenuItem(value: 'Electrical', child: Text('Electrical')),
              ],
              onChanged: (v) => setState(() => group = v),
            ),
            ElevatedButton(
              onPressed: () async {
                final picked =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (picked != null) setState(() => image = picked);
              },
              child: const Text('Select Image'),
            ),
            ElevatedButton(
              onPressed: addProduct,
              child: const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
