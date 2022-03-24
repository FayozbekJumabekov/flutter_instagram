import 'package:flutter/material.dart';

class ProfDetails extends StatefulWidget {
  const ProfDetails({Key? key}) : super(key: key);

  @override
  State<ProfDetails> createState() => _ProfDetailsState();
}

class _ProfDetailsState extends State<ProfDetails> {
  List<String> storyText = [
    "New",
    "Sport",
    "Travelling",
    "Time Management",
    "Education"
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: [
          /// # Profile Account pictue and Statistcs
          Container(
            margin: EdgeInsets.only(top: 10),
            height: MediaQuery.of(context).size.height * 0.12,
            width: MediaQuery.of(context).size.width,
            child: GridTileBar(
              leading: Container(
                decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    borderRadius: BorderRadius.circular(100)),
                padding: EdgeInsets.all(2),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(100)),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "54",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5),
                      ),
                      Text(
                        "Posts",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.1),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "834",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3),
                      ),
                      Text(
                        "Followers",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.1),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "165",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3),
                      ),
                      Text(
                        "Following",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// # Profile details
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// Profile Name
                const Text(
                  "Jacob West",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 1,
                ),

                /// # Profile details
                const Text.rich(TextSpan(
                    text: "Digital goodies designer ",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                    children: [
                      TextSpan(
                          text: "@pixsellz",
                          style: TextStyle(color: Colors.blue))
                    ])),
                const SizedBox(
                  height: 1,
                ),
                const Text(
                  "Everything is designed.",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 15,
                ),

                /// #Edit Button
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Color.fromRGBO(60, 60, 67, 0.18)),
                          borderRadius: BorderRadius.circular(5),
                        )),
                    onPressed: () {},
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.button?.color,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    )),
              ],
            ),
          ),

          /// # Story List
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.15,
            child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        (index == 0)

                        /// # Add story
                            ? Container(
                          height: 70,
                          width: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: Colors.black)),
                          child: const Icon(
                            Icons.add_sharp,
                            size: 30,
                          ),
                        )

                        /// # Story with picture
                            : Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(100)),
                          child: Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),

                        /// Story Description
                        Container(
                          width: 70,
                          alignment: Alignment.center,
                          child: Text(
                            storyText[index],
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 12,
                                letterSpacing: 0.01,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
