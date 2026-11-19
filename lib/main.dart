//---------------------------------
// Imports
//---------------------------------

import 'gemini_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'package:flutter/material.dart';

//-----------------------------------
// Application Entry Point
// Firebase Initialization
// Provider Setup
//------------------------------------

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MainApp(),
    ),
  );
}
/*
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MainApp(),

    ),
  );
}
*/

//--------------------------------------------
// Main Application Widget
//--------------------------------------------

class MainApp extends StatelessWidget {
  const MainApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenuScreen(),
    );
  }
}
 
// -------------------------------------------------------------------------
// SCREEN 1 - Menu Screen
// Pizza Selection and Cart Counter
// -------------------------------------------------------------------------
 
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
 
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  bool isLoadingRecommendation = false; //AI recomm loading state

  /*List<String> currentOrders = [];*/
  
  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<CartProvider>(context);

    final ButtonStyle pizzaButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      minimumSize: const Size(220, 50),
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Pizza Shop 🍕'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Choose Your Pizza',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                
              children: [
          
                const Icon(
                  Icons.shopping_cart,
                  color: Colors.blue,
                  size: 40,
                ),

                const SizedBox(width: 10),
              
                Text(
                  '${cartProvider.orders.length} ${cartProvider.orders.length == 1 ? "Item" : "Items"}', //cart counter display
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

                  // changed currentOrders.length to cartProvider.orders.length

        const SizedBox(height: 20),

            /*
            Text(
              currentOrder.isEmpty ? 'Cart is Empty' : currentOrder,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 20),
            */

// ---------------------------------------------
// Gemini AI Recommendation
// ---------------------------------------------
        
        ElevatedButton(
          onPressed: isLoadingRecommendation
            ? null
            : () async {

              setState(() {
                isLoadingRecommendation = true;
              });

              try {
                final recommendation =
                await GeminiService.getPizzaRecommendation();

              if (!context.mounted) return;

              
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('🤖 AI Recommendation'),
                  content: Text(recommendation),
                  actions: [
                    TextButton(
                      onPressed: () {
                        final cartProvider = 
                          Provider.of<CartProvider>(context, listen: false);
                          
                          cartProvider.addOrder(
                            'Pepperoni\n'
                            'Size: Large\n'
                            'Crust: Thin Crust\n'
                            'Toppings: Extra Cheese, Mushrooms',
                          );

                          Navigator.pop(context);
                      },

                         child: const Text('Add To Cart'),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const CustomizeScreen(
                                pizzaName: 'Pepperoni',
                              ),
                            ),
                          );
                      },
                      child: const Text('Customize Instead'),
                    ), 
                   
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            } catch (e) {

              if (!context.mounted) return;

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: Text(e.toString()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            } finally {

              if (context.mounted) {
                setState(() {
                  isLoadingRecommendation = false;
                });
              }
            }
         },

          child: isLoadingRecommendation
            ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : const Text('🤖 Get AI Recommendation'),

        ),

const SizedBox(height: 20),



        /*
        ElevatedButton(
          onPressed: isLoadingRecommendation
            ? null
            : () async {
              
              setState(() {
                isLoadingRecommendation = true;
              });

              final recommendation =
                await GeminiService.getPizzaRecommendation();

              if (!context.mounted) return;

              setState(() {
                isLoadingRecommendation = false;
              });

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('🤖 AI Recommendation'),
                  content: Text(recommendation),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
            ),
          );
        },

        child: isLoadingRecommendation
          ? const SizedBox(
         width: 20,
         height: 20,
         child: CircularProgressIndicator(
          strokeWidth: 2,
          ),
          )

          : const Text('🤖 Get AI Recommendation'),

        ),
               // Testing button
              ElevatedButton(
                onPressed: () async {
                  
                  showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                      title: Text('Test'),
                      content: Text('AI button pressed'),
                    ),
                  );
                },
                child: const Text('🤖 Get AI Recommendation'),
              ),
              
              
              ElevatedButton(
                onPressed: () async {
                  final recommendation =
                  await GeminiService.getPizzaRecommendation();

                  if (!context.mounted) return;

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('🤖 AI Recommendation'),
                      content: Text(recommendation),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },

                child: const Text('🤖 Get AI Recommendation'),
              ),
              


              const SizedBox(height: 20),
              */


            // --------------------------------------------------------------------
            // Pizza button - Margherita
            // ------------------------------------------------------------------
            
             ElevatedButton(
              style: pizzaButtonStyle,
              onPressed: () async {
                final order = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomizeScreen(
                      pizzaName: 'Margherita',
                    ),
                  ),
                );

                if (order != null) {
                  final cartProvider = 
                    Provider.of<CartProvider>(context, listen: false);
                  
                  cartProvider.addOrder(order);              
                }
              },
              child: const Text('🍕 Margherita'),
            ),

            const SizedBox(height: 20),

            // --------------------------------------------------------------------
            // Pizza button - Pepperoni
            // ------------------------------------------------------------------

            ElevatedButton(
              style: pizzaButtonStyle,
              onPressed: () async {
                final order = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomizeScreen(
                      pizzaName: 'Pepperoni',
                    ),
                  ),
                );

                if (order != null) {
                  final cartProvider = 
                    Provider.of<CartProvider>(context, listen: false);
                  
                  cartProvider.addOrder(order);              
                }
              },
              child: const Text('🍕 Pepperoni'),
            ),

            const SizedBox(height: 20),

            // --------------------------------------------------------------------
            // Pizza button - Veggie
            // ------------------------------------------------------------------

            ElevatedButton(
              style: pizzaButtonStyle,
              onPressed: () async {
                final order = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomizeScreen(
                      pizzaName: 'Veggie',
                    ),
                  ),
                );

                if (order != null) {
                  final cartProvider = 
                    Provider.of<CartProvider>(context, listen: false);
                  
                  cartProvider.addOrder(order);              
                }
              },
              child: const Text('🍕 Veggie'),
            ),

            const SizedBox(height: 20),


            //--------------------------------------------------------
            // Navigation to Cart Screen
            //---------------------------------------------------------

            ElevatedButton(
            onPressed: () {
            
              final cartProvider =
                Provider.of<CartProvider>(context, listen: false);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(
                    orders: cartProvider.orders,
                    clearCart: () {
                      cartProvider.clearCart();
                    },
                  ),
                ),
              );
            },

              /*
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(
                      orders: currentOrders,
                      clearCart: () {
                        setState(() {
                          currentOrders.clear();
                        });
                      },
                    ),
                  ),
                );
              }, */
              child: const Text('View Cart'),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------------
// SCREEN 2 - Customize
// -------------------------------------------------------------------------

class CustomizeScreen extends StatefulWidget {
  final String pizzaName;
 
  const CustomizeScreen({
    super.key,
    required this.pizzaName,
  });

  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

 class _CustomizeScreenState extends State<CustomizeScreen> {
  String selectedSize = 'Medium';
  String selectedCrust = 'Thin Crust';

  List<String> selectedToppings = [];

  Widget buildToppingChip(String topping) {
    return SizedBox(
      width: 120,
      child: ChoiceChip(
        label: Center(
          child: Text(topping),
        ),
        selected: selectedToppings.contains(topping),
        onSelected: (selected) {
          setState(() {
            if (selected) {
              selectedToppings.add(topping);
            } else {
              selectedToppings.remove(topping);
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize Pizza'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.pizzaName,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Choose Size',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Row(
              children: [
                Radio<String>(
                  value: 'Small',
                  groupValue: selectedSize,
                  onChanged: (value) {
                    setState(() {
                      selectedSize = value!;
                    });
                  },
                ),
                const Text('Small'),

                Radio<String>(
                  value: 'Medium',

                  groupValue: selectedSize,
                  onChanged: (value) {
                    setState(() {
                      selectedSize = value!;
                    });
                  },
                ),
                const Text('Medium'),

                Radio<String>(
                  value: 'Large',
                  groupValue: selectedSize,
                  onChanged: (value) {
                    setState(() {
                      selectedSize = value!;
                    });
                  },
                ),
                const Text('Large'),
              ],
            ),

            const SizedBox(height: 10),

             const Text(
              'Choose Crust',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            RadioListTile<String>(
              title: const Text('Thin Crust'),
              value: 'Thin Crust',
              groupValue: selectedCrust,
              onChanged: (value) {
                setState(() {
                  selectedCrust = value!;
                });
              },
            ),

            RadioListTile<String>(
              title: const Text('Thick Crust'),
              value: 'Thick Crust',
              groupValue: selectedCrust,
              onChanged: (value) {
                setState(() {
                  selectedCrust = value!;
                });
              },
            ),

            RadioListTile<String>(
              title: const Text('Cheese Stuffed Crust'),
              value: 'Cheese Stuffed Crust',
              groupValue: selectedCrust,
              onChanged: (value) {
                setState(() {
                  selectedCrust = value!;
                });
              },
            ),

            const Text(
              'Choose Toppings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                buildToppingChip('Extra Cheese'),
                buildToppingChip('Olive'),
                buildToppingChip('Mushrooms'),
                buildToppingChip('Peppers'),
                buildToppingChip('Pineapple'),
              ],
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String order =
                        '${widget.pizzaName}\n'
                        'Size: $selectedSize\n'
                        'Crust: $selectedCrust\n'
                        'Toppings: ${selectedToppings.join(", ")}';

                    Navigator.pop(
                      context,
                      order,
                    );
                  },
                  child: const Text('Add To Cart'),
                ),

                const SizedBox(width: 15),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------------
// Screen 3 - Cart
// Cart Review & Checkout
// -------------------------------------------------------------------------

class CartScreen extends StatelessWidget {
  final List<String> orders;
  final VoidCallback clearCart;

   const CartScreen({
    super.key,
    required this.orders,
    required this.clearCart,
  });

  @override
  Widget build(BuildContext context) {

    final cartProvider =
      Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /*
              Text(
                order.isEmpty
                    ? 'Cart is Empty'
                    : order,
                textAlign: TextAlign.center,
              ),
              */
              Expanded(
                child: cartProvider.orders.isEmpty
                  ? const Text('Cart is Empty')
                  : ListView.builder(
                    itemCount:cartProvider.orders.length,

                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartProvider.orders[index],
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton.icon(
                      onPressed: () {
                        Provider.of<CartProvider>(
                          context,
                          listen: false,
                        ).removeOrder(index);
                      },
                      icon: const Icon(Icons.cancel),
                      label: const Text('Remove Item'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
),
              
              const SizedBox(height: 30),

              //------------------------------
              // Firestore Order Submission
              // Save Orders to cloud database
              //------------------------------

              ElevatedButton(
                onPressed: () async {

                  // Save completed order to Firebase Firestore

                  await FirebaseFirestore.instance.collection('orders').add({
                    'orders': orders,
                    'timestamp': Timestamp.now(),
                  });

                  clearCart();
                  
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConfirmationScreen(),
                    ),
                  );
                },

                child: const Text('Place Order'),
              ),
                
              ElevatedButton(
                onPressed: () {

                  Provider.of<CartProvider>(
                    context,
                    listen: false,
                  ).clearCart();

                },
                child: const Text('Clear Cart'),
              ),

             const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// -------------------------------------------------------------------------
// Screen 4 - Confirmation
// -------------------------------------------------------------------------

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [

            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),

            const SizedBox(height: 20),

            const Text('Order Placed Successfully!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text('Thank you for your order.',
            ),
            
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                  );
              },
              child: const Text('Back to Home'),
            ),

          
          ],
        ),
      ),
    );
  }
}
//Git push
//git init
//git add .
//git commit -m "Initial commit"
//git remote add origin https://github.com/yourusername/yourrepo.git
//git branch -M main
//git push -u origin main