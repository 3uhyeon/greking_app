import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class SearchPage extends StatefulWidget {
  final List<Map<String, dynamic>> mountainData;

  SearchPage({required this.mountainData});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> _filteredMountains = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredMountains = widget.mountainData;
  }

  void _filterMountains(String query) {
    setState(() {
      _filteredMountains = widget.mountainData
          .where((mountain) =>
              mountain['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search your mountain name',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchController.clear();
                    _filterMountains('');
                  },
                ),
              ),
              onChanged: _filterMountains,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredMountains.length,
              itemBuilder: (context, index) {
                final mountain = _filteredMountains[index];
                return ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 8.0),
                      Text(mountain['name']),
                    ],
                  ),
                  onTap: () {
                    // 선택된 산의 정보를 pop으로 반환
                    Navigator.pop(context, mountain);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
