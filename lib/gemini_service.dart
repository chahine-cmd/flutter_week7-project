import 'package:google_generative_ai/google_generative_ai.dart';

//----------------------------------
// Gemini AI Recommendation Service
//----------------------------------

class GeminiService {

  static const String apiKey = 'AQ.Ab8RN6LC54Swuh2ppx4Y6NObeg1SuO65BW4UdOQKRGnTdv0okQ';

    
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
        const Duration(seconds: 20),
      );

      return response.text ?? 'No recommendation available.';

      /*} catch (e) {
          print('Gemini Error: $e');

          return 'Gemini Error:\n\n$e'; */
        

    } catch (e) {
        print('Gemini Error: $e');

        return '''
      Our Pizza Bot is taking a quick break!

      Please try again in a few moments.

      In the meantime, why not build your own pizza using our customization options?


      ''';
    }
  }
}