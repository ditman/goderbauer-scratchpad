import 'package:flutter/material.dart';

class SearchableText extends StatefulWidget {
  const SearchableText(this.text, {super.key, this.style});

  final String text;
  final TextStyle? style;

  @override
  State<SearchableText> createState() => _SearchableTextState();
}

class _SearchableTextState extends State<SearchableText> implements Searchable {
  List<TextSpan>? _children;
  List<String> _pieces = <String>[];

  SearchConductor? _searchConductor;
  int? _activeIndex;
  String? _searchTerm;

  @override
  void initState() {
    super.initState();
    _updateChildren();
  }

  @override
  void didUpdateWidget(SearchableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      throw UnimplementedError('Changing text is not implemented.');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final SearchConductor newConductor = SearchConductor.of(context);
    if (_searchConductor != newConductor) {
      _searchConductor?.unregister(this);
      newConductor.register(this);
      // TODO: Tell new conductor about hits.
    }
  }

  @override
  void dispose() {
    _searchConductor?.unregister(this);
    super.dispose();
  }

  @override
  void clear() {
    _searchTerm = null;
    _children = null;
    _activeIndex = null;
    _pieces = <String>[];
  }

  @override
  int searchFor(String term) {
    setState(() {
      _pieces = widget.text.split(term);
      _searchTerm = term;
      _children = null;
      _activeIndex = null;
    });
    return _pieces.length - 1;
  }

  @override
  bool next() {
    int newIndex = _activeIndex == null ? 0 : _activeIndex! + 1;
    if (newIndex >= _pieces.length - 1) {
      if (_activeIndex != null) {
        setState(() {
          _children = null;
          _activeIndex = null;
        });
      }
      return false;
    }
    setState(() {
      _children = null;
      _activeIndex = newIndex;
    });
    return true;
  }

  @override
  bool previous() {
    int newIndex = _activeIndex == null ? _pieces.length - 2 : _activeIndex! - 1;
    if (newIndex < 0) {
      if (_activeIndex != null) {
        setState(() {
          _children = null;
          _activeIndex = null;
        });
      }
      return false;
    }
    setState(() {
      _children = null;
      _activeIndex = newIndex;
    });
    return true;
  }

  void _updateChildren() {
    final List<TextSpan> children = <TextSpan>[];
    if (_pieces.isEmpty) {
      children.add(TextSpan(
        text: widget.text,
        style: widget.style,
      ));
      _children = children;
      return;
    }
    int index = 0;
    for (String piece in _pieces) {
      children.add(TextSpan(
        text: piece,
        style: widget.style,
      ));
      final Color highlight =
          index == _activeIndex ? Colors.yellow : Colors.grey;
      children.add(TextSpan(
        text: _searchTerm,
        style: widget.style?.copyWith(backgroundColor: highlight) ??
            TextStyle(backgroundColor: highlight),
      ));
      index++;
    }
    children.removeLast();
    _children = children;
  }

  @override
  Widget build(BuildContext context) {
    if (_children == null) {
      _updateChildren();
    }
    return Text.rich(TextSpan(children: _children));
  }
}

class SearchInPage extends StatefulWidget {
  const SearchInPage({
    super.key,
    required this.child,
    required this.searchTerm,
  });

  final Widget child;
  final TextEditingController searchTerm;

  @override
  State<SearchInPage> createState() => _SearchInPageState();
}

class _SearchInPageState extends State<SearchInPage>
    implements SearchConductor {
  final List<Searchable> _searchables = <Searchable>[];

  @override
  void initState() {
    super.initState();
    widget.searchTerm.addListener(_handleSearch);
    // TODO: implement didUpdateWidget
  }

  @override
  void dispose() {
    widget.searchTerm.removeListener(_handleSearch);
    super.dispose();
  }

  void _handleSearch() {
    bool needsNext = true;
    for (final Searchable searchable in _searchables) {
      searchable.searchFor(widget.searchTerm.value.text);
      if (needsNext) {
        needsNext = !searchable.next();
      }
    }
  }

  @override
  void register(Searchable searchable) {
    _searchables.add(searchable);
  }

  @override
  void unregister(Searchable searchable) {
    _searchables.remove(searchable);
  }

  @override
  Widget build(BuildContext context) {
    return _SearchConductorScope(
      conductor: this,
      child: widget.child,
    );
  }
}

abstract class Searchable {
  /// Returns the number of found instances.
  int searchFor(String string);

  void clear();

  /// Returns false if there is no next.
  bool next();
  bool previous();
}

abstract class SearchConductor {
  void register(Searchable searchable);
  void unregister(Searchable searchable);

  static SearchConductor of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_SearchConductorScope>()!
        .conductor;
  }
}

class _SearchConductorScope extends InheritedWidget {
  const _SearchConductorScope({
    required this.conductor,
    required super.child,
  });

  final SearchConductor conductor;

  @override
  bool updateShouldNotify(_SearchConductorScope oldWidget) =>
      conductor != oldWidget.conductor;
}
