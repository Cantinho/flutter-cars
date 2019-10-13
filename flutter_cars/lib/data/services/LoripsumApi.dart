import 'package:http/http.dart' as http;

class LoripsumApi{

  // This is a fake cache for loripsum. Must be removed later.
  static String loripsum;

  static Future<String> getLoripsum() async {
    var url = 'https://loripsum.net/api';
    print("GET > $url");
    if(loripsum != null) {
      return loripsum;
    }
    var response = await http.get(url);
    String text = response.body;
    loripsum = text;
    text = text.replaceAll("<p>", "");
    text = text.replaceAll("</p>", "");

    return text;
  }
}