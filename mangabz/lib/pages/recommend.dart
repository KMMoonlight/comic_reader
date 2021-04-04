import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mangabz/network/api.dart';
import 'package:mangabz/entity/recommend_model.dart';
import 'package:mangabz/pages/detail.dart';

class RecommendPage extends StatefulWidget {
  @override
  _RecommendPageState createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: RecommendList(),
    );
  }
}

class RecommendList extends StatefulWidget {
  @override
  _RecommendListState createState() => _RecommendListState();
}

class _RecommendListState extends State<RecommendList> {
  RecommendComic recommendComic;

  @override
  void initState() {
    super.initState();
    //获取数据

    if (recommendComic == null) {
      getRecommendData().then((value) {
        setState(() {
          recommendComic = RecommendComic.fromHtml(value);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: recommendComic == null
          ? Center(
              child: Text('正在加载......'),
            )
          : ListView(
              scrollDirection: Axis.vertical,
              children: [
                ComicCardTitle(title: '人气推荐'),
                ComicCard(comicModelList: recommendComic.list[0]),
                ComicCardTitle(title: '热度排行'),
                ComicCard(comicModelList: recommendComic.list[1]),
                ComicCardTitle(title: '上升最快'),
                ComicCard(comicModelList: recommendComic.list[2]),
              ],
            ),
    );
  }
}

class ComicCardTitle extends StatelessWidget {
  final String title;

  ComicCardTitle({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          Text(title, style: TextStyle(fontSize: 20, color: Colors.grey[400])),
      margin: EdgeInsets.fromLTRB(20.0, 10.0, 0, 5.0),
    );
  }
}

class ComicCard extends StatelessWidget {
  final List<ComicModel> comicModelList;

  ComicCard({this.comicModelList});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var currentModel = comicModelList[index];
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  FadeInImage(
                    placeholder: AssetImage('assets/images/placeholder.jpg'),
                    image: NetworkImage(
                      currentModel.comicImage,
                    ),
                  ),
                  Text(currentModel.comicName)
                ],
              ),
            ),
            onTap: () {
              // jump to detail page
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (buildContext) {
                return DetailPage(targetUrl: currentModel.comicTargetUrl);
              }));
            },
          );
        },
        itemCount: comicModelList.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
      ),
      height: 290,
    );
  }
}
