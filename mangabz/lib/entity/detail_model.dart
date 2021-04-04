import 'package:html/parser.dart' show parse;

class DetailModel {
  String detailTitle;

  String detailSubTitle;

  String detailContent;

  String detailImage;

  List<DetailChapterModel> chapterModelList;

  DetailModel.formHtml(String html) {
    var document = parse(html);
    detailTitle = document.getElementsByClassName('detail-main-title')[0].text;
    detailSubTitle =
        document.getElementsByClassName('detail-main-subtitle')[0].text;
    detailContent =
        document.getElementsByClassName('detail-main-content')[0].text;
    detailImage =
        document.getElementsByClassName('detail-bar-img')[0].attributes['src'];

    var chapters = document.getElementsByClassName('detail-list-item');

    chapterModelList = [];

    chapters.forEach((element) {
      var chapterElement = element.getElementsByTagName('a')[0];
      chapterModelList.add(DetailChapterModel(
          chapterTitle: chapterElement.text,
          chapterUrl: chapterElement.attributes['href']));
    });
  }
}

class DetailChapterModel {
  String chapterTitle;

  String chapterUrl;

  DetailChapterModel({this.chapterTitle, this.chapterUrl});
}
