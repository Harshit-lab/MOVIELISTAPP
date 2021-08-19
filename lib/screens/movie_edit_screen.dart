import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:movie/helper/models/movie.dart';
import 'package:movie/helper/movie_provider.dart';
import 'package:movie/screens/movie_view_screen.dart';
import 'package:movie/utils/constants.dart';
import 'package:movie/widgets/delete_popup.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class MovieEditScreen extends StatefulWidget {
  static const route = '/edit-movie';
  @override
  _MovieEditScreenState createState() => _MovieEditScreenState();
}

class _MovieEditScreenState extends State<MovieEditScreen> {

  final titleController = TextEditingController();
  final contentController = TextEditingController();
  var _image;
  final picker = ImagePicker();
  bool firstTime = true;
  var id;
  var selectedMovie;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstTime == true) {
      id = ModalRoute.of(this.context)!.settings.arguments;
      if (id != null) {
        selectedMovie = Provider.of<MovieProvider>(this.context, listen: false).getMovie(id);
        titleController.text = selectedMovie?.title;
        contentController.text = selectedMovie?.director;
        if (selectedMovie?.imagePath != null) {
          _image = File(selectedMovie.imagePath);
        }
      }
    }
    firstTime = false;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.7,
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: () => Navigator.of(context).pop(),
        icon: Icon(Icons.arrow_back),
        color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () => {
              getImage(ImageSource.camera)
            },
             icon: Icon(Icons.photo_camera),
             color: Colors.black,
          ),
          IconButton(
            color: Colors.black,
            onPressed: () => {
              getImage(ImageSource.gallery)
            },
            icon: Icon(Icons.insert_photo),
            ),
          IconButton(
            onPressed: () => {
              if (id!=null) {
                _showDialog()
              } else {
                 Navigator.pop(context)
              }
            }, 
            icon: Icon(Icons.delete),
            color: Colors.black,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(left: 10.0, right: 5.0, top: 10.0, bottom: 5.0),
            child: TextField(
                controller: titleController,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: createTitle,
                decoration: InputDecoration(hintText: 'Enter Movie Title', border: InputBorder.none),
              ),
            ),
            if (_image != null) 
              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                height: 250.0,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          image: FileImage(_image),
                          fit: BoxFit.cover,
                        ),
                      )
                    ),
                     Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _image = null;
                            },);
                          },
                          child: Icon(
                            Icons.delete,
                            size: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 5.0, top: 10.0, bottom: 5.0),
              child: TextField(
                controller: contentController,
                maxLines: null,
                style: createContent,
                decoration: InputDecoration(
                  hintText: 'Enter the Director\'s name...',
                  border: InputBorder.none
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (titleController.text.isEmpty)
            titleController.text = 'Untitled Movie';

            saveNote();
        },
        child: Icon(
          Icons.save
        ),
      ),
    );
  }

  getImage(ImageSource imageSource) async {
    PickedFile imageFile = await  picker.getImage(source: imageSource);
    if (imageFile == null) return;
    File tmpFile = File(imageFile.path);
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = basename(imageFile.path);
    tmpFile = await tmpFile.copy('${appDir.path}/$fileName');
    setState(() {
      _image = tmpFile;
    });
  }

  void saveNote() {
    String title = titleController.text.trim();
    String content = contentController.text.trim();
    String imagePath = _image != null ? _image.path : null;

    if (id!=null) {
      Provider.of<MovieProvider>(this.context, listen: false).addOrUpdateMovie(id, title, content, imagePath, EditMode.UPDATE);
      Navigator.of(this.context).pop();
    } else {
      int id = DateTime.now().millisecondsSinceEpoch;
    Provider.of<MovieProvider>(this.context, listen: false)
      .addOrUpdateMovie(id, title, content, imagePath, EditMode.ADD);
    Navigator.of(this.context).pushReplacementNamed(MovieViewScreen.route, arguments: id);
    }
  }

  _showDialog() {
    showDialog (
      context: this.context,
      builder: (context) {
        return DeletePopup(selectedMovie);
      }
      );

  }
}