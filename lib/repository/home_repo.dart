import 'package:http/http.dart' as http;

class HomeRepository {
  Future<void> updateWaterState(int wellWater, int waterBoard) async {
    if (wellWater == 1 && waterBoard == 0) {
      final response = await http.get(Uri.parse('http://192.168.4.1/well/on'));
      if (response.statusCode == 200) {
        print('Successful');
      } else {
        print('Failed!');
      }
    } else {
      if (wellWater == 0 && waterBoard == 1) {
        final response =
            await http.get(Uri.parse('http://192.168.4.1/well/off'));
        if (response.statusCode == 200) {
          print('Successful');
        } else {
          print('Failed!');
        }
      } else if (waterBoard == 0 && wellWater == 0) {
        final response =
            await http.get(Uri.parse('http://192.168.4.1/all/off'));
        if (response.statusCode == 200) {
          print('Successful');
        } else {
          print('Failed!');
        }
      }
    }
  }
}
