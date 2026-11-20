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
import 'theme.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
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

/*
    final ButtonStyle pizzaButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      minimumSize: const Size(220, 50),
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
*/
    return Scaffold(
      appBar: AppBar(
        title: const Text('🍕 Smart Pizza Shop 🍕'),
        actions: [

          Row(children: [
            IconButton(
              icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
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
          ),

            const SizedBox(width: 5),

            Text('${cartProvider.orders.length}',
            ),

            const SizedBox(width: 15),
          ],
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(

        
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text('Choose Your Pizza',
              style: Theme.of(context)
              .textTheme
              .headlineMedium,
              ),
            
            const SizedBox(height: 20),

          /*  Row(
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
        */

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
           /* style: pizzaButtonStyle,*/
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
          /*  style: pizzaButtonStyle,*/
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
          /*  style: pizzaButtonStyle,*/
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

/*
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
              
                child: const Text('View Cart'),
              ),
              */
            ],
          ),
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
  String selectedSize = 'Small';
  String selectedCrust = 'Thin Crust';
  String selectedDrink = 'No Drink';
  List<String> selectedSides = [];
  List<String> selectedToppings = [];

  /*Widget buildToppingChip(String topping) {
    return SizedBox(
      width: 120,
      child: ChoiceChip(
        label: Center(
          child: Text(topping),
        ), 

       Widget buildToppingChip(String topping) {
        return Center(
          child: SizedBox(
            width: 120,
            child: ChoiceChip(
              label: Center(
                child: Text(
                  topping,
                  textAlign: TextAlign.center,
                ),
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
      ),
    );
  } */

        Widget buildToppingChip(String topping) {
          return ChoiceChip(
            label: SizedBox(
              width: double.infinity,
              child: Text(
                topping,
                textAlign: TextAlign.center,
              ),
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
          );
        }

        

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize Pizza'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 26,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Selected Pizza: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:widget.pizzaName,
                      style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                  
                  ],
                ),
              ),

          
/*            Text(
              widget.pizzaName,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
*/

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.straighten,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Choose Size',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),


            /*
            const Text(
              'Choose Size',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            */

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

            const SizedBox(height: 20),

//------------------ Choose Crust ------------------
               Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.bakery_dining,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Choose Crust',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

             /*const Text(
              'Choose Crust',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ), */

            Row(
              children: [
                
                Radio<String>(
                  value: 'Thin Crust',
                  groupValue: selectedCrust,
                  onChanged: (value) {
                    setState(() {
                      selectedCrust = value!;
                    });
                  },
                ),
                const Text('Thin'),

                Radio<String>(
                  value: 'Thick Crust',
                  groupValue: selectedCrust,
                  onChanged: (value) {
                    setState(() {
                      selectedCrust = value!;
                    });
                  },
                ),
                const Text('Thick'),

                Radio<String>(
                  value: 'Cheese Stuffed Crust',
                  groupValue: selectedCrust,
                  onChanged: (value) {
                    setState(() {
                      selectedCrust = value!;
                    });
                  },
                ),
                const Text('Stuffed'),

              ],
            ),

            /*
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

            */

            const SizedBox(height: 20),
//------------------ Choose Toppings -----------

            Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.restaurant,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Choose Toppings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            
            
            
           /* const Text(
              'Choose Toppings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ), */

            const SizedBox(height: 10),
            
            /*Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                buildToppingChip('Extra Cheese'),
                buildToppingChip('Olive'),
                buildToppingChip('Mushrooms'),
                buildToppingChip('Peppers'),
                buildToppingChip('Pineapple'),
                buildToppingChip('Onions'),
                buildToppingChip('Jalapenos'),
                buildToppingChip('Chicken'),
                buildToppingChip('Beef'),
              ],
            ), */

            SizedBox(
              height: 180,
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.5,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisExtent: 50,
                children: [
                  buildToppingChip('Extra Cheese'),
                  buildToppingChip('Olive'),
                  buildToppingChip('Mushrooms'),
                  buildToppingChip('Peppers'),
                  buildToppingChip('Pineapple'),
                  buildToppingChip('Onions'),
                  buildToppingChip('Jalapenos'),
                  buildToppingChip('Chicken'),
                  buildToppingChip('Beef'),
                ],
              ),
            ),

            const SizedBox(height: 20),

//----------------------- Drinks ----------------------

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_drink,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Choose Drink',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
        
            
            
            
           /* const Text(
              'Choose Drink',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ), */

              RadioListTile<String>(
              title: const Text('No Drink'),
              value: 'No Drink',
              groupValue: selectedDrink,
              onChanged: (value) {
                setState(() {
                selectedDrink = value!;
                });
              },
            ),

            RadioListTile<String>(
              title: const Text('Pepsi'),
              value: 'Pepsi',
              groupValue: selectedDrink,
              onChanged: (value) {
                setState(() {
                selectedDrink = value!;
                });
              },
            ),
            
            RadioListTile<String>(
              title: const Text('Fanta'),
              value: 'Fanta',
              groupValue: selectedDrink,
              onChanged: (value) {
                setState(() {
                selectedDrink = value!;
                });
              },
            ),

            RadioListTile<String>(
              title: const Text('Sprite'),
              value: 'Sprite',
              groupValue: selectedDrink,
              onChanged: (value) {
                setState(() {
                  selectedDrink = value!;
                });
              },
            ),

            RadioListTile<String>(
              title: const Text('Water'),
              value: 'Water',
              groupValue: selectedDrink,
              onChanged: (value) {
                setState(() {
                  selectedDrink = value!;
                });
              },
            ),

            const SizedBox(height: 20),

//------------------------ End of Drinks -----------------------

//---------------------- Sides ----------------

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lunch_dining,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Choose Sides',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

          /*  const Text(
              'Choose Sides',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ), */

            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Garlic Bread'),
              value: selectedSides.contains('Garlic Bread'),
              onChanged: (selected) {
                setState(() {
                  if (selected!) {
                    selectedSides.add('Garlic Bread');
                  } else {
                    selectedSides.remove('Garlic Bread');
                  }
                });
              },
            ),

            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('French Fries'),
              value: selectedSides.contains('French Fries'),
              onChanged: (selected) {
                setState(() {
                  if (selected!) {
                    selectedSides.add('French Fries');
                  } else {
                    selectedSides.remove('French Fries');
                  }
                });
              },
            ),

            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Chicken Wings'),
              value: selectedSides.contains('Chicken Wings'),
              onChanged: (selected) {
                setState(() {
                  if (selected!) {
                    selectedSides.add('Chicken Wings');
                  } else {
                    selectedSides.remove('Chicken Wings');
                  }
                });
              },
            ),

            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              controlAffinity: ListTileControlAffinity.leading, //moved checkbox to the left
              title: const Text('Mozzarella Sticks'),
              value: selectedSides.contains('Mozzarella Sticks'),
              onChanged: (selected) {
                setState(() {
                  if (selected!) {
                    selectedSides.add('Mozzarella Sticks');
                  } else {
                    selectedSides.remove('Mozzarella Sticks');
                  }
                });
              },
            ),
/*
            const Text(
              'Choose Side',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            RadioListTile<String>(
              title: const Text('Garlic Bread'),
              value: 'Garlic Bread',
              groupValue: selectedSide,
              onChanged: (value) {
                setState(() {
                  selectedSide = value!;
                });
              },
            ),

            RadioListTile<String>(
              title: const Text('French Fries'),
              value: 'French Fries',
              groupValue: selectedSide,
              onChanged: (value) {
                setState(() {
                  selectedSide = value!;
                });
              },
            ),

            RadioListTile<String>(
              title: const Text('Chicken Wings'),
              value: 'Chicken Wings',
              groupValue: selectedSide,
              onChanged: (value) {
                setState(() {
                  selectedSide = value!;
                });
              },
            ),
            
            RadioListTile<String>(
              title: const Text('Mozzarella Sticks'),
              value: 'Mozzarella Sticks',
              groupValue: selectedSide,
              onChanged: (value) {
                setState(() {
                  selectedSide = value!;
                });
              },
            ),

            */

// ----------------- End of Sides ------------------

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(140, 40),
                  ),
                  onPressed: () {
                    String order =
                        '${widget.pizzaName}\n'
                        'Size: $selectedSize\n'
                        'Crust: $selectedCrust\n'
                        'Toppings: ${selectedToppings.join(", ")}\n'
                        'Drink: $selectedDrink\n'
                        'Sides: ${selectedSides.join(",")}';

                    Navigator.pop(
                      context,
                      order,
                    );
                  },
                  child: const Text('Add To Cart'),
                ),

                const SizedBox(width: 15),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 40),
                  ),
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
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(
                'Order Summary',
                style: Theme.of(context).textTheme.headlineMedium,               
                ),
            
              const SizedBox(height: 20),

             
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

              const SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

//----------------------------------------------------------------
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(120, 40),
                    ),
                    
                    onPressed: () {

                      Provider.of<CartProvider>(
                        context,
                        listen: false,
                      ).clearCart();

                    },
                    child: const Text('Clear Cart'),
                  ),

                  //--------------------------------------------------------
                  const SizedBox(width: 10),

                  ElevatedButton(
                    style:ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 40),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Back'),

                    //---------------------------------------------------------------
                  ),
                ],
              ),
              ],             
            ),
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
      body: SafeArea(
        child: Center(
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