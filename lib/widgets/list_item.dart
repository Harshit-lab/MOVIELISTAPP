
import 'package:flutter/material.dart';
import 'package:movie/helper/models/movie.dart';
import 'package:movie/helper/movie_provider.dart';
import 'package:movie/screens/movie_edit_screen.dart';
import 'package:movie/screens/movie_view_screen.dart';
import 'package:movie/utils/constants.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'delete_popup.dart';
import 'delete_popup_one.dart';

class ListItem extends StatelessWidget {
  final int id;
  final String title;
  final String director;
  final String imagePath;
  final String date;
  BuildContext context;
  

  ListItem(this.id, this.title, this.director, this.imagePath, this.date, this.context);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 135.0,
      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, MovieViewScreen.route, arguments: id);
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(color: white, 
          boxShadow: shadow,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: grey,
            width: 1.0,
          ),
          ),
          child: Row(
            children: [
              Expanded(child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: itemTitle,
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      date,
                      overflow: TextOverflow.ellipsis,
                      style: itemDateStyle,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Expanded(
                      child: Text(
                        director,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: itemContentStyle,
                      ),
                      ),
                    Row(
                      children: [
                        IconButton(onPressed: () {
                      Navigator.pushNamed(context, MovieEditScreen.route, arguments: id);
                    }, icon: Icon(Icons.edit)),
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
                    
                  ],
                ),
              ),
              ),
              if(imagePath != null) 
                Row(
                  children: [
                    SizedBox(
                      height: 12.0,
                    ),
                    Container(
                      height: 80.0,
                      width: 95.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        image: DecorationImage(
                          image: FileImage(
                            File(imagePath),
                          ),
                          fit: BoxFit.cover,
                          )
                      ),
                    )
                  ],
                )
          ],),
        ),
      ),
    );
  }
  _showDialog() {
    showDialog (
      context: this.context,
      builder: (context) {
        return DeletePopupOne(id);
      }
      );

  }
  
}