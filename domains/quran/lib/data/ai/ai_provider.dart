abstract class AiProvider {
  String get id;
  Future<String> generateText(
      {required String prompt, String? systemInstruction});
}
