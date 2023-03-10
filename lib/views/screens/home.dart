import 'package:flutter/material.dart';
import 'package:wallpaper_app_flutter_pexelsapi/controller/api_operations.dart';
import 'package:wallpaper_app_flutter_pexelsapi/views/screens/full_screen.dart';
import 'package:wallpaper_app_flutter_pexelsapi/views/widgets/cat_block.dart';
import 'package:wallpaper_app_flutter_pexelsapi/views/widgets/custom_appbar.dart';
import 'package:wallpaper_app_flutter_pexelsapi/views/widgets/search_bar.dart';
import '../../models/category.dart';
import '../../models/photos.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Photos> trendingWallList;
  late List<CategoryModel> CatModList;
  bool isLoading = true;

  GetCatDetails() async {
    CatModList = await ApiOperations.getCategoriesList();
    print("GETTTING CAT MOD LIST");
    print(CatModList);
    setState(() {
      CatModList = CatModList;
    });
  }

  GetTrendingWallpapers() async {
    trendingWallList = await ApiOperations.getTrendingWallpapers();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    GetCatDetails();
    GetTrendingWallpapers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: CustomAppBar(
          word1: "CHITRA",
          word2: "APP",
        ),
      ),
      body:  isLoading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SearchBar(),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: CatModList.length,
                    itemBuilder: ((context, index) => CatBlock(
                      categoryImgSrc: CatModList[index].catImgUrl,
                      categoryName: CatModList[index].catName,
                    ))),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 700,
              child: RefreshIndicator(
                onRefresh: () async {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                child: GridView.builder(
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 400,
                        crossAxisCount: 2,
                        crossAxisSpacing: 13,
                        mainAxisSpacing: 10),
                    itemCount: trendingWallList.length,
                    itemBuilder: ((context, index) => GridTile(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullScreen(
                                      imgUrl:
                                      trendingWallList[index].imgSrc)));
                        },
                        child: Hero(
                          tag: trendingWallList[index].imgSrc,
                          child: Container(
                            height: 800,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.amberAccent,
                                borderRadius: BorderRadius.circular(20)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                  height: 800,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  trendingWallList[index].imgSrc),
                            ),
                          ),
                        ),
                      ),
                    ))),
              ),
            )
          ],
        ),
      ),
    );
  }
}