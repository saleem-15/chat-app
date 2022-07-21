import 'package:flutter/material.dart';
import 'package:sliver_header_delegate/sliver_header_delegate.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({
    Key? key,
    required this.name,
    required this.image,
  }) : super(key: key);

  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Row(
      //     children: [
      //       CircleAvatar(
      //         backgroundImage: NetworkImage(image),
      //         maxRadius: 30,
      //       ),
      //       const SizedBox(
      //         width: 15,
      //       ),
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text(
      //             name,
      //             style: const TextStyle(fontSize: 22),
      //           ),
      //           const SizedBox(
      //             height: 3,
      //           ),
      //           Text(
      //             'Online',
      //             style: TextStyle(color: Colors.grey[200], fontSize: 12),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      //   actions: const [Icon(Icons.more_vert)],
      // ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: FlexibleHeaderDelegate(
              // builder: (context, progress) {
              //   log('progress: $progress');
              //   return const SizedBox.shrink();
              // },
              statusBarHeight: MediaQuery.of(context).padding.top,
              //> 40 ? 40 : MediaQuery.of(context).padding.top,
              expandedHeight: 240,
              background: MutableBackground(
                expandedWidget: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
                collapsedColor: Colors.blue,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.call),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
              children: [
                FlexibleTextItem(
                  text: name,
                  collapsedStyle: const TextStyle(fontSize: 20, color: Colors.white),
                  expandedStyle: const TextStyle(fontSize: 28, color: Colors.white),
                  expandedAlignment: Alignment.bottomLeft,
                  collapsedAlignment: Alignment.center,
                  expandedPadding: const EdgeInsets.only(left: 20, bottom: 20),
                ),
              ],
             
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                tileColor: (index % 2 == 0) ? Colors.white : Colors.green[50],
                title: Center(
                  child: Text('$index', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 50, color: Colors.greenAccent[400]) //TextStyle
                      ),
                ),
              ),
              childCount: 51,
            ),
          ),
        ],
      ),
    );
  }
}
