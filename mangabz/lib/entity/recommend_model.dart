import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:html/dom_parsing.dart';

class RecommendComic {

  List<List<ComicModel>> list = [];

  RecommendComic.fromHtml(String html) {
    // Parse HTML to Element Object
    var document = parse(html);

    // Create Recommend List
    List<ComicModel> recommendList = [];
    var recommendDOMList = document.getElementsByClassName('index-manga-item');
    recommendDOMList.forEach((element) {
      // targetUrl and imageUrl
      fillList(element, recommendList);
    });

    // Create Rank List
    List<ComicModel> rankList = [];
    var rankDomList = document.getElementsByClassName('rank-list')[0].getElementsByClassName('list');
    rankDomList.forEach((element) {
      fillList(element, rankList);
    });

    // Create
    List<ComicModel> hotList = [];
    var hotDomList = document.getElementsByClassName('carousel-right-item');
    hotDomList.forEach((element) {
      fillList(element, hotList);
    });

    list.clear();
    list.add(recommendList);
    list.add(rankList);
    list.add(hotList);
  }


  void fillList(Element element, List<ComicModel> modelList) {
    var targetImg = element.getElementsByTagName('a')[0];
    String targetUrl = targetImg.attributes['href'];
    String imgUrl = targetImg.getElementsByTagName('img')[0].attributes['src'];
    String title = element.getElementsByTagName('p')[0].getElementsByTagName('a')[0].text;
    modelList.add(ComicModel(comicName: title, comicImage: imgUrl, comicTargetUrl: targetUrl));
  }


}

class ComicModel {

  //漫画名称
  String comicName;

  //漫画封面
  String comicImage;

  //漫画详情链接
  String comicTargetUrl;


  ComicModel({this.comicName, this.comicImage, this.comicTargetUrl});

}