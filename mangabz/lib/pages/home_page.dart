import 'package:flutter/material.dart';
import 'package:mangabz/entity/search_model.dart';
import 'detail.dart';
import 'recommend.dart';
import 'book_shelf.dart';
import 'package:mangabz/network/api.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: HomeMainFragment(),
    );
  }
}

class HomeMainFragment extends StatefulWidget {
  @override
  _HomeMainFragmentState createState() => _HomeMainFragmentState();
}

class _HomeMainFragmentState extends State<HomeMainFragment> {
  int _currentIndex = 0;
  final List<Widget> _containerList = [RecommendPage(), BookShelf()];

  final pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comic'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                //Show Search
                showSearch(context: context, delegate: CustomSearchDelegate());
              })
        ],
      ),
      body: SafeArea(
          child: PageView(
        children: _containerList,
        controller: pageController,
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        physics: NeverScrollableScrollPhysics(),
      )),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.recommend), label: '推荐'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: '书架')
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          pageController.jumpToPage(index);
        },
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  SearchModel searchModel;

  @override
  List<Widget> buildActions(BuildContext context) {
    // 输入框后面的控件， 一般输入框不为空时， 显示一个清空按钮
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
            searchModel = null;
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // 搜索框前面的控件 通常是一个返回按钮
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, '');
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // 返回搜索后的结果，一般是一个ListView

    return searchModel == null
        ? FutureBuilder(
            future: getSearchData(query),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  {
                    return ListView(
                      children: [],
                    );
                  }
                case ConnectionState.waiting:
                case ConnectionState.active:
                  {
                    return Container(
                      child: Center(
                        child: Text('正在搜索...QAQ'),
                      ),
                    );
                  }
                case ConnectionState.done:
                  {
                    searchModel = SearchModel.fromHTML(snapshot.data);
                    return SearchResultCard(searchModel: searchModel);
                  }

                default:
                  {
                    return Text('');
                  }
              }
            },
          )
        : SearchResultCard(searchModel: searchModel);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //输入建议
    if (query == '') {
      searchModel = null;
    }
    return Text('');
  }
}

class SearchResultCard extends StatelessWidget {
  final searchModel;

  const SearchResultCard({Key key, this.searchModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (buildContext, index) {
        var currentComicModel = searchModel.comicModelList[index];
        return GestureDetector(
          child: Container(
            height: 180,
            margin: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Image.network(currentComicModel.comicImage,
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
                          currentComicModel.comicTitle,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          softWrap: true,
                          maxLines: 4,
                        ),
                        padding: EdgeInsets.only(right: 10.0),
                      ),
                      Container(
                        child: Text(
                          currentComicModel.comicAuthor,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          softWrap: true,
                          maxLines: 3,
                        ),
                        padding: EdgeInsets.only(right: 10.0),
                      ),
                      Container(
                        child: Text(
                          currentComicModel.comicSubTitle,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          softWrap: true,
                          maxLines: 3,
                        ),
                        padding: EdgeInsets.only(right: 10.0),
                      ),
                      Container(
                        child: Text(
                          currentComicModel.comicContent,
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
              return DetailPage(targetUrl: currentComicModel.comicTargetUrl);
            }));
          },
        );
      },
      itemCount: searchModel.comicModelList.length,
    );
  }
}
