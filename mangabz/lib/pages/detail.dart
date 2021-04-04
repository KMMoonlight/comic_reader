import 'package:flutter/material.dart';
import 'package:mangabz/entity/detail_model.dart';
import 'package:mangabz/network/api.dart';
import 'package:mangabz/pages/read.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  final String targetUrl;
  DetailPage({Key key, this.targetUrl}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isSaved = false;
  DetailModel detailModel;

  @override
  void initState() {
    super.initState();
    checkSaveState();
  }

  void checkSaveState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList(widget.targetUrl);
    //说明没有存储到书架中
    if (list != null) {
      setState(() {
        isSaved = true;
      });
    }
  }

  void saveOrRemoveComic(bool save) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (save) {
      List<String> saveList = [];
      if (detailModel != null) {
        saveList.add(detailModel.detailTitle);
        saveList.add(detailModel.detailSubTitle);
        saveList.add(detailModel.detailContent);
        saveList.add(detailModel.detailImage);
        saveList.add(widget.targetUrl);
      }
      prefs.setStringList(widget.targetUrl, saveList);
      //并且将其存入 书架列表
      var shelfList = prefs.getStringList('book_shelf');
      if (shelfList == null) {
        shelfList = [];
      }
      shelfList.add(widget.targetUrl);
      prefs.setStringList('book_shelf', shelfList);
    } else {
      //删除
      var shelfList = prefs.getStringList('book_shelf');
      shelfList.remove(widget.targetUrl);
      prefs.setStringList('book_shelf', shelfList);
      prefs.remove(widget.targetUrl);
    }

    setState(() {
      isSaved = save;
    });
  }

  void dataGetCallback(DetailModel detailModel) {
    this.detailModel = detailModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('详情'),
        actions: [
          IconButton(
              icon: Icon(Icons.star,
                  color: isSaved ? Colors.yellow : Colors.grey),
              onPressed: () {
                // 保存到书架中
                saveOrRemoveComic(!isSaved);
              })
        ],
      ),
      body: DetailInfo(
          targetUrl: widget.targetUrl, dataGetCallback: dataGetCallback),
    );
  }
}

class DetailInfo extends StatefulWidget {
  final String targetUrl;
  final Function dataGetCallback;

  DetailInfo({this.targetUrl, this.dataGetCallback});

  @override
  _DetailInfoState createState() => _DetailInfoState();
}

class _DetailInfoState extends State<DetailInfo> {
  DetailModel detailModel;
  bool isReversed = false;

  @override
  void initState() {
    super.initState();
    getDetailData(widget.targetUrl).then((value) {
      setState(() {
        detailModel = DetailModel.formHtml(value);
        widget.dataGetCallback(detailModel);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return detailModel == null
        ? Container(
            child: Center(
              child: Text('加载中......'),
            ),
          )
        : Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  margin: EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(detailModel.detailImage,
                          height: 180, fit: BoxFit.fitHeight),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              detailModel.detailTitle,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              detailModel.detailSubTitle.trim(),
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Text(
                              detailModel.detailContent.trim(),
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 6,
                            )
                          ],
                        ),
                        width: 210,
                        padding: EdgeInsets.only(left: 10.0),
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: Color(0xFFB4B4B4),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        '章节',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: IconButton(
                          icon: Icon(isReversed
                              ? Icons.arrow_upward
                              : Icons.arrow_downward),
                          onPressed: () {
                            setState(() {
                              isReversed = !isReversed;
                            });
                          }),
                    )
                  ],
                ),
                Expanded(
                  child: Padding(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 5),
                      itemBuilder: (context, index) {
                        var currentChapter = detailModel.chapterModelList[
                            isReversed
                                ? detailModel.chapterModelList.length -
                                    1 -
                                    index
                                : index];
                        return Container(
                          child: Center(
                            child: ElevatedButton(
                              child: Text(
                                currentChapter.chapterTitle.trim(),
                                overflow: TextOverflow.ellipsis,
                              ),
                              onPressed: () {
                                //点击跳转阅读
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return WebViewFragment(
                                    targetUrl: currentChapter.chapterUrl,
                                    chapterName: currentChapter.chapterTitle,
                                  );
                                }));
                              },
                            ),
                          ),
                        );
                      },
                      itemCount: detailModel.chapterModelList.length,
                    ),
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                )
              ],
            ),
          );
  }
}
