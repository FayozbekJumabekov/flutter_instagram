class Bin {
  /*
                      /// Posts
                    if (users.isEmpty)
                      FutureBuilder(
                          future: StoreService.loadStoredImages(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<String>> snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return MasonryGridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                itemCount: snapshot.data!.length,
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                itemBuilder: (context, index) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.elementAt(index),
                                      placeholder: (context, index) =>
                                          const Image(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            "assets/images/im_placeholder.png"),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                !snapshot.hasData) {
                              return const Center(
                                child: CupertinoActivityIndicator(
                                  radius: 20,
                                ),
                              );
                            } else {
                              return Container();
                            }
                          }),
   */
}
