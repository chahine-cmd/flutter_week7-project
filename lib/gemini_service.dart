import 'package:google_generative_ai/google_generative_ai.dart';

//----------------------------------
// Gemini AI Recommendation Service
//----------------------------------

class GeminiService {

  static const String apiKey = 'AQ.Ab8RN6JlY1MooSJHKQk_JwFTiLvlZyB7MV1gsmOHR-zV-E9sGg';

  static Future<String> getPizzaRecommendation() async {
    try {
      final model = GenerativeModel(
        model: 'gemini-3.8-flash',
        apiKey: apiKey,
      );

      final prompt = '''
      A customer is visiting a pizza shop.
      Recommend:
      1. A pizza
      2. A size
      3. A crust
      4. Two toppings
      5. A drink
      6. A side item
      Keep the response short and friendly.
      ''';

      /*
          'Recommend a pizza for a customer in a pizza shop. '
          'Include size, crust, and toppings in 2 sentences.';
      */

      final response = await model.generateContent([Content.text(prompt)]).timeout(
        const Duration(seconds: 10),
      );

      return response.text ?? 'No recommendation available.';
    } catch (e) {
       print('Gemini Error: $e');

       return 'AI service is temporarily unavailable or taking too long to respond.\n\n'
        'Smart Pizza Recommendation\n\n'
        '🍕 Pizza: Large Pepperoni\n\n'
        '🥖 Crust: Thin Crust\n\n'
        '🧀 Toppings:\n'
        '• Extra Cheese\n'
        '• Mushrooms\n\n'
        '🥤 Drink:\n'
        '• Coca-Cola\n\n'
        '🍟 Side:\n'
        '• Garlic Bread';
    }
  }
}