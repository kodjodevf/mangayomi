import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/archive_reader/models/models.dart';
import 'package:mangayomi/modules/archive_reader/providers/archive_reader_providers.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/utils/media_query.dart';

class LocalReaderScreen extends ConsumerStatefulWidget {
  const LocalReaderScreen({super.key});

  @override
  ConsumerState createState() => _LocalReaderScreenState();
}

class _LocalReaderScreenState extends ConsumerState<LocalReaderScreen> {
  List<LocalArchive> images = [];
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Archive Reader'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        //File
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(
                                type: FileType.custom,
                                allowedExtensions: [
                              'cbz',
                              'zip',
                              'cbt',
                              'tar'
                            ]);
                        if (result != null) {
                          //File
                          final ddd = await ref.watch(
                              getArchiveDataFromFileProvider(
                                      result.files.first.path!)
                                  .future);

                          setState(() {
                            images.add(ddd);
                            isLoading = false;
                          });
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      label: const Text("Load cbz file"),
                      icon: const Icon(Icons.archive_rounded)),
                  ElevatedButton.icon(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        //Directory
                        String? result =
                            await FilePicker.platform.getDirectoryPath();

                        if (result != null) {
                          //Directory
                          final ddd = await ref.watch(
                              getArchiveDataFromDirectoryProvider(result)
                                  .future);
                          setState(() {
                            images = ddd;
                            isLoading = false;
                          });
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      label: const Text("Load from directory"),
                      icon: const Icon(Icons.create_new_folder_rounded)),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.68, crossAxisCount: 3),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: InkWell(
                          onTap: () {
                            context.push("/archiveReaderReaderView",
                                extra: images[index]);
                          },
                          child: Ink.image(
                            height: 200,
                            fit: BoxFit.cover,
                            image: MemoryImage(images[index].coverImage!),
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.6)
                                  ],
                                  stops: const [0, 1],
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        images[index].name!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          shadows: <Shadow>[
                                            Shadow(
                                                offset: Offset(0.5, 0.9),
                                                blurRadius: 3.0)
                                          ],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: Text(
                                            getTypeExtension(images[index]
                                                    .extensionType!)
                                                .toUpperCase(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (isLoading)
          Container(
            width: mediaWidth(context, 1),
            height: mediaHeight(context, 1),
            color: Colors.black45,
            child: UnconstrainedBox(
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  height: 200,
                  width: 200,
                  child: const Center(child: ProgressCenter())),
            ),
          )
      ],
    );
  }
}
