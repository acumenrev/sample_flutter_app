import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'Startup Name Generator',
      home: new RandomWords(),
      theme: new ThemeData(
        primaryColor: Colors.red
      ),
    );


  }

  void _pushAdded() {

  }

}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RandomWordsState();
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _savePairs = Set<WordPair>();
  final _highlighted = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {

    // TODO: implement build  
    return new Scaffold (
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.favorite), onPressed: _pushAdded)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(padding: const EdgeInsets.all(0.0),
      shrinkWrap: false,
      reverse: false,
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();

        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _savePairs.contains(pair);
    return new ListTile(
      title: new Text(pair.asPascalCase, style: _biggerFont,),
      trailing: new Icon(alreadySaved == true ? Icons.favorite : Icons.favorite_border,
      color: alreadySaved == true ? Colors.red : null,),
      onTap: () {
        setState(() {
          if (alreadySaved == true) {
            _savePairs.remove(pair);
          } else {
            _savePairs.add(pair);
          }
        });
      },

    );
  }

  void _pushAdded() {
    _highlighted.clear();
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context){
        final _highlightedStyle = TextStyle(color: Colors.red, fontSize: 22.0);
        final _nonHighlightedStyle = TextStyle(color: Colors.grey, fontSize: 18.0);

          final tile = _savePairs.map((pair) {
            final alreadyHighlighted = _highlighted.contains(pair);
            return new ListTile(title: new Text(pair.asPascalCase, style: alreadyHighlighted == true ? _highlightedStyle : _nonHighlightedStyle),
            onTap: () {
              setState(() {
                if (alreadyHighlighted == true) {
                  _highlighted.remove(pair);
                } else {
                  _highlighted.add(pair);
                }
              });
            });
          });
          final divided = ListTile.divideTiles(tiles: tile, context: context).toList();

          return new Scaffold(appBar: new AppBar(
            title: new Text('Saved Suggestions'),
          ),
            body: new ListView(children: divided));
      })
    );
  }
}