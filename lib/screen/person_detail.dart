import 'package:flutter/material.dart';
import 'package:flutter_app/model/actors_model.dart';
import 'package:flutter_app/model/person_cast_model.dart';
import 'package:flutter_app/providers/movie_provider.dart';
import 'package:flutter_app/utils/linearGradient.dart';
import 'package:flutter_app/widgets/feedback_message.dart';

class PersonDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Actor actor = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: _appbar(actor),
      body: _getInfoPersonContent(context, actor),
    );
  }

  Widget _appbar(actor) {
    return AppBar(
        title: Text(actor.name, style: TextStyle(fontSize: 30.0)),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: linearGradient()),
        ),
        centerTitle: false);
  }

  Widget _getInfoPersonContent(context, actor) {
    final moviesProvider = new MoviesProvider();

    return Container(
      child: FutureBuilder(
          future: moviesProvider.getPersonInfo(actor.id.toString()),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasError) {
              return FeedbackMessage(
                  text: snapshot.error.toString(), color: 'warning');
            }
            if (snapshot.hasData) {
              return _showPersonInfo(snapshot.data);
            }
            return Container();
          }),
    );
  }

  Widget _showPersonInfo(List<PersonFilm> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        return Column(
          children: [_personCard(context, items[i])],
        );
      },
    );
  }

  Widget _personCard(BuildContext context, PersonFilm film) {
    double _width;
    final _screenSize = MediaQuery.of(context).size;
    _screenSize.width > 400
        ? _width = _screenSize.width * 0.75
        : _width = _screenSize.width * 0.70;

    film.uniqueId = '${film.id}-detail';

    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      margin: EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Hero(
            tag: film.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(05.0),
              child: GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, 'detail', arguments: film),
                child: FadeInImage(
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 60.0,
                  /* height: 150.0, */
                  fit: BoxFit.contain,
                  image: NetworkImage(film.getPersonCastingImage()),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            width: _width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  film.title == null || film.title.isEmpty ? 'n/a' : film.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  film.character == null || film.character.isEmpty
                      ? 'n/a'
                      : film.character,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  film.originalTitle == null || film.originalTitle.isEmpty
                      ? 'na'
                      : film.originalTitle,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  film.releaseDate == null || film.releaseDate.isEmpty
                      ? 'n/a'
                      : film.releaseDate,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Icon(Icons.star_border),
                  Text(film.voteAverage == null || film.voteAverage.isNaN
                      ? 'n/a'
                      : film.voteAverage.toString()),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}