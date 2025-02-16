import 'dart:convert';
import 'package:flutmisho/ui/screens/blog_post_screen.dart';
import 'package:flutmisho/widgets/catgegory_tabs.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  HomePageBodyState createState() => HomePageBodyState();
}

class HomePageBodyState extends State<HomePageBody> {
  List<Map<String, dynamic>> allItems = [];
  List<Map<String, dynamic>> filteredItems = [];
  String? selectedCategory;
  bool isLoading = true;
  String? error;

  static const int itemsPerPage = 10;
  int currentPage = 0;
  List<Map<String, dynamic>> displayedItems = [];
  ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    fetchItems();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      loadMoreItems();
    }
  }

  Future<void> loadMoreItems() async {
    if (isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    final startIndex = (currentPage + 1) * itemsPerPage;
    if (startIndex >= filteredItems.length) {
      setState(() {
        isLoadingMore = false;
      });
      return;
    }

    await Future.delayed(const Duration(milliseconds: 500));

    final endIndex = (startIndex + itemsPerPage <= filteredItems.length)
        ? startIndex + itemsPerPage
        : filteredItems.length;

    setState(() {
      currentPage++;
      displayedItems.addAll(
        filteredItems.getRange(startIndex, endIndex).toList(),
      );
      isLoadingMore = false;
    });
  }

  Future<void> fetchItems() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/items'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'];

        setState(() {
          allItems = data.map((item) => item as Map<String, dynamic>).toList();
          filteredItems = allItems;
          displayedItems = filteredItems.take(itemsPerPage).toList();
          currentPage = 0;
          isLoading = false;
          error = null;
        });
      } else {
        setState(() {
          error = 'Failed to load items. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error loading items: $e';
        isLoading = false;
      });
    }
  }

  void filterItems(String? category, {String query = ''}) {
    setState(() {
      selectedCategory = category;
      if ((category == null || category.isEmpty) && query.isEmpty) {
        filteredItems = allItems;
      } else {
        filteredItems = allItems.where((item) {
          final matchesCategory = category == null ||
              category.isEmpty ||
              (item['category'] != null &&
                  item['category'].toString().toLowerCase() ==
                      category.toLowerCase());
          final matchesQuery = query.isEmpty ||
              item['title']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              item['description']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase());
          return matchesCategory && matchesQuery;
        }).toList();
      }
      currentPage = 0;
      displayedItems = filteredItems.take(itemsPerPage).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: fetchItems,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: TopicTabs(
            onCategorySelected: (category) {
              filterItems(category);
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                filterItems(selectedCategory, query: value);
              },
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (displayedItems.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'No items available.',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey),
                    ),
                  ),
                );
              }

              if (index == displayedItems.length) {
                if (isLoadingMore) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (selectedCategory != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          filterItems(null);
                        },
                        child: const Text('Clear Filter'),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }

              final item = displayedItems[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: _buildItemCard(context, item),
              );
            },
            childCount: displayedItems.length + 1,
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(BuildContext context, Map<String, dynamic> item) {
    final DateTime createdDate = DateTime.parse(item['created_at']);
    final String relativeTime = timeago.format(createdDate);

    List<dynamic> codeData = [];
    try {
      codeData = json.decode(item['code']);
    } catch (_) {}

    return InkWell(
        onTap: () {
          final List<dynamic> content = codeData.map((codeSnippet) {
            return {
              'type': 'code',
              'data': codeSnippet['content'] ?? '',
            };
          }).toList();

          final Map<String, dynamic> postData = {
            ...item,
            'content': content,
          };
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlogPostScreen(post: postData),
            ),
          );
        },
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundImage: NetworkImage(
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/Queen_Elizabeth_II_official_portrait_for_1959_tour_%28retouched%29_%28cropped%29_%283-to-4_aspect_ratio%29.jpg/220px-Queen_Elizabeth_II_official_portrait_for_1959_tour_%28retouched%29_%28cropped%29_%283-to-4_aspect_ratio%29.jpg',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text("TokoKuxa")
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['title'],
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(item['description']),
                          const SizedBox(height: 8),
                          Text('Created: ${item['created_at']}'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: Image.network(
                        "https://picsum.photos/200/300",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        Text(relativeTime),
                        SizedBox(width: 8),
                        Icon(Icons.waving_hand_outlined),
                        Text("22")
                      ]),
                      Row(children: [
                        Icon(
                          Icons.remove_circle_outline,
                        ),
                        Icon(Icons.more_vert),
                      ])
                    ])
              ],
            ),
          ),
        ));
  }
}
