import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'detail.dart';

class BookShelf extends StatefulWidget {
  @override
  _BookShelfState createState() => _BookShelfState();
}

//with AutomaticKeepAliveClientMixin
class _BookShelfState extends State<BookShelf> {
  // @override
  // bool get wantKeepAlive => false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() {
    // monitor network fetch
    getBookShelfList();
    // if failed,use refreshFailed()
  }

  List<List<String>> bookList = [];

  @override
  void initState() {
    super.initState();
    //获取数据
    getBookShelfList();
  }

  void getBookShelfList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tempList = prefs.getStringList('book_shelf');

    if (tempList == null) {
      tempList = [];
    }

    bookList = [];

    setState(() {
      tempList.forEach((element) {
        var bookData = prefs.getStringList(element);
        bookList.add(bookData);
      });
      _refreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    return SmartRefresher(
      enablePullDown: true,
      header: WaterDropHeader(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: ListView.builder(
        itemBuilder: (buildContext, index) {
          var currentComicModel = bookList[index];
          return GestureDetector(
            child: Container(
              height: 180,
              margin: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Image.network(currentComicModel[3],
                      height: 180, fit: BoxFit.fitHeight),
                  Container(
                    padding: EdgeInsets.only(left: 20.0),
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            currentComicModel[0],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                            softWrap: true,
                            maxLines: 4,
                          ),
                          padding: EdgeInsets.only(right: 10.0),
                        ),
                        Container(
                          child: Text(
                            currentComicModel[1],
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            softWrap: true,
                            maxLines: 3,
                          ),
                          padding: EdgeInsets.only(right: 10.0),
                        ),
                        Container(
                          child: Text(
                            currentComicModel[2],
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            softWrap: true,
                            maxLines: 5,
                          ),
                          padding: EdgeInsets.only(right: 10.0),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              //跳转到详情界面
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (buildContext) {
                return DetailPage(targetUrl: currentComicModel[4]);
              }));
            },
          );
        },
        itemCount: bookList.length,
      ),
    );
  }
}
