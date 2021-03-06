import 'package:buk/widgets/feed/sub/image_viewer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

List<Widget> imageSliders(
        List<dynamic> imgList, BuildContext context, String itemName) =>
    imgList
        .map((item) => Container(
              margin: const EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => ViewableImage(
                                item,
                                '$itemName${imgList.indexOf(item)}',
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'Image for $itemName${imgList.indexOf(item)}',
                          child: Image.network(item,
                              fit: BoxFit.cover, width: 1000.0),
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ),
                      ),
                    ],
                  )),
            ))
        .toList();

class ItemCarousel extends StatelessWidget {
  const ItemCarousel(
      {Key? key,
      required this.images,
      required this.title,
      this.loading = false})
      : super(key: key);

  final bool loading;
  final List<dynamic> images;
  final String title;

  @override
  Widget build(BuildContext context) {
    return images.isEmpty
        ? Container()
        : Container(
            child: loading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                            width: 500, height: 200, color: Colors.grey[300])),
                  )
                : CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                      autoPlay: false,
                      enableInfiniteScroll: false,
                    ),
                    items: imageSliders(images, context, title),
                  ),
          );
  }
}
