import 'request.dart';


//获取推荐数据
Future<String> getRecommendData() async{
  var response = await DioClient.getInstance().get('/');
  return response.data.toString();
}


//获取搜索数据
Future<String> getSearchData(String keyword) async {
  var response = await DioClient.getPhoneInstance().get('/search?title=$keyword');
  return response.data.toString();
}


//获取详情数据
Future<String> getDetailData(String url) async {
  var response = await DioClient.getPhoneInstance().get(url);
  return response.data.toString();
}