import 'dart:developer';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/utils/media_query.dart';

class ImageFinderPage extends StatefulWidget {
  const ImageFinderPage({super.key});

  @override
  State createState() => _ImageFinderPageState();
}

class LocalArchive {
  String? name;

  Uint8List? coverImage;

  List<LocalImage>? images = [];

  LocalExtensionType? extensionType;
}

enum LocalExtensionType { cbz, zip, rar, cbt, tar }

class LocalImage {
  String? name;
  Uint8List? image;
}

class _ImageFinderPageState extends State<ImageFinderPage> {
  List<LocalArchive> imagePaths = [];
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Image Finder'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        //File
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();
                        if (result != null) {
                          //File
                          final ddd = await ArchiveSS()
                              .getArchiveDatas(result.files.first.path!);
                          setState(() {
                            imagePaths.add(ddd);
                            isLoading = false;
                          });
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: const Text("File ")),
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        //Directory
                        String? result =
                            await FilePicker.platform.getDirectoryPath();

                        if (result != null) {
                          //Directory
                          final ddd = await ArchiveSS().directory(result);
                          setState(() {
                            imagePaths = ddd;
                            isLoading = false;
                          });
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: const Text("Directory")),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.68, crossAxisCount: 3),
                  itemCount: imagePaths.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: InkWell(
                          onTap: () {},
                          child: Ink.image(
                            height: 200,
                            fit: BoxFit.cover,
                            image: MemoryImage(imagePaths[index].coverImage!),
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
                                        imagePaths[index].name!,
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
                                            getTypeExtension(imagePaths[index]
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

class ArchiveSS {
  Future<List<LocalArchive>> directory(String path) async {
    return compute(extract, path);
  }

  Future<LocalArchive> getArchiveDatas(String path) async {
    return compute(extractArchive, path);
  }

  List<LocalArchive> extract(String data) {
    return searchForArchive(Directory(data));
  }

  List<LocalArchive> list = [];
  List<LocalArchive> searchForArchive(Directory dir) {
    List<FileSystemEntity> entities = dir.listSync();
    for (FileSystemEntity entity in entities) {
      if (entity is Directory) {
        searchForArchive(entity);
      } else if (entity is File) {
        String path = entity.path;
        if (isArchiveFile(path)) {
          final dd = extractArchive(path);
          list.add(dd);
        }
      }
    }
    return list;
  }

  bool isImageFile(String path) {
    List<String> imageExtensions = ['.png', '.jpg', '.jpeg'];
    String extension = path.toLowerCase();
    for (String imageExtension in imageExtensions) {
      if (extension.endsWith(imageExtension)) {
        return true;
      }
    }
    return false;
  }

  bool isArchiveFile(String path) {
    List<String> imageExtensions = ['.cbz', '.zip', '.cbr', 'cbt', 'tar'];
    String extension = path.toLowerCase();
    for (String imageExtension in imageExtensions) {
      if (extension.endsWith(imageExtension)) {
        return true;
      }
    }
    return false;
  }

  LocalArchive extractArchive(String path) {
    log(path.split('/').last.split("\\").last.split(".").last);
    final bytes = File(path).readAsBytesSync();
    final localArchive = LocalArchive()
      ..extensionType = setTypeExtension(
          path.split('/').last.split("\\").last.split(".").last)
      ..name = path
          .split('/')
          .last
          .split("\\")
          .last
          .replaceAll(RegExp(r'\.(cbz|zip|cbt|tar)'), '');
    Archive? archive;
    final extensionType = localArchive.extensionType;
    if (extensionType == LocalExtensionType.cbt ||
        extensionType == LocalExtensionType.tar) {
      archive = TarDecoder().decodeBytes(bytes);
    } else {
      archive = ZipDecoder().decodeBytes(bytes);
    }

    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        if (isImageFile(filename)) {
          if (filename.contains("cover")) {
            final data = file.content as Uint8List;
            localArchive.coverImage = Uint8List.fromList(data);
          } else {
            final data = file.content as Uint8List;
            localArchive.images!.add(LocalImage()
              ..image = Uint8List.fromList(data)
              ..name = filename.split('/').last.split("\\").last);
          }
        }
      }
    }
    localArchive.images!.sort((a, b) => a.name!.compareTo(b.name!));
    localArchive.coverImage ??= localArchive.images!.first.image;
    return localArchive;
  }
}

String getTypeExtension(LocalExtensionType type) {
  return switch (type) {
    LocalExtensionType.cbt => type.name,
    LocalExtensionType.zip => type.name,
    LocalExtensionType.rar => type.name,
    LocalExtensionType.tar => type.name,
    _ => type.name,
  };
}

LocalExtensionType setTypeExtension(String extension) {
  return switch (extension) {
    "cbt" => LocalExtensionType.cbt,
    "zip" => LocalExtensionType.zip,
    "rar" => LocalExtensionType.rar,
    "tar" => LocalExtensionType.tar,
    _ => LocalExtensionType.cbz,
  };
}
