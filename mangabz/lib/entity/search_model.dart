import 'package:html/parser.dart' show parse;


class SearchModel {
  
  List<SearchComicModel> comicModelList = [];

  SearchModel.fromHTML(String html) {
    
    var document = parse(html);
    
    var searchResults = document.getElementsByClassName('manga-item');

    comicModelList.clear();

    searchResults.forEach((element) {
      var targetUrl = element.attributes['href'];
      var image = element.getElementsByTagName('img')[0].attributes['src'];
      var infos = element.getElementsByTagName('p');
      var title = infos[0] != null ? infos[0].text : '';
      var author = infos[1] != null ? infos[1].text : '';
      var subTitle = infos[2] != null ? infos[2].text : '';
      var content = infos[3] != null ? infos[3].text : '';

      comicModelList.add(SearchComicModel(comicTitle: title, comicImage: image,
          comicTargetUrl: targetUrl, comicAuthor: author,
        comicContent: content, comicSubTitle: subTitle
      ));
    });
    
  }

}

class SearchComicModel {

  String comicTitle;

  String comicImage;

  String comicTargetUrl;

  String comicAuthor;

  String comicSubTitle;

  String comicContent;

  SearchComicModel({this.comicTitle, this.comicImage, this.comicTargetUrl, this.comicAuthor, this.comicSubTitle, this.comicContent});

}