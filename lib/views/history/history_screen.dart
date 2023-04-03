import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'History',
          style: TextStyle(color: Theme.of(context).hintColor),
        ),
        actions: [
          IconButton(
              splashRadius: 20,
              onPressed: () {},
              icon: Icon(Icons.search, color: Theme.of(context).hintColor)),
          IconButton(
              splashRadius: 20,
              onPressed: () {},
              icon: Icon(Icons.delete_sweep_outlined,
                  color: Theme.of(context).hintColor)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('12-12-2023'),
              ],
            ),
            SizedBox(
              height: 105,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: GestureDetector(
                      onTap: () {},
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: CachedNetworkImage(
                            imageUrl:
                                'https://static.fnac-static.com/multimedia/Images/FR/NR/21/db/c2/12770081/1540-1/tsp20230314072112/Blue-Lock.jpg',
                            width: 60,
                            height: 100,
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Blue Lock',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      'Chap 01',
                                      style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '22:02',
                                          style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Delete',
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('No')),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Yes')),
                                          ],
                                        )
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.delete,
                              size: 25,
                            )),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
