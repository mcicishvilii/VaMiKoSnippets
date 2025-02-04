// home_page_body.dart
import 'dart:convert';
import 'package:flutmisho/screens/blog_post_screen.dart';
import 'package:flutmisho/widgets/catgegory_tabs.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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

  // Pagination variables
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

    // Simulate a network delay (if desired)
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
          // Initially, show all items
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

  /// Filter items by category and/or search query.
  void filterItems(String? category, {String query = ''}) {
    setState(() {
      selectedCategory = category;
      if ((category == null || category.isEmpty) && query.isEmpty) {
        filteredItems = allItems;
      } else {
        filteredItems = allItems.where((item) {
          // Make sure your JSON items include a "category" field.
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
      // Reset pagination when filters change.
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
        // Category Tabs
        SliverToBoxAdapter(
          child: TopicTabs(
            onCategorySelected: (category) {
              filterItems(category);
            },
          ),
        ),
        // Search Field
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Pass the current category as well as the query.
                filterItems(selectedCategory, query: value);
              },
            ),
          ),
        ),
        // List of Items
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
                // Optionally include a "Clear Filter" button if a category is selected.
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

  /// Build an item card that navigates to the details screen when tapped.
  Widget _buildItemCard(BuildContext context, Map<String, dynamic> item) {
    // Parse the "code" field if available.
    List<dynamic> codeData = [];
    try {
      codeData = json.decode(item['code']);
    } catch (_) {
      // Handle parse error if needed.
    }

    return InkWell(
      onTap: () {
        // Convert the codeData list into content items.
        final List<dynamic> content = codeData.map((codeSnippet) {
          return {
            'type': 'code',
            'data': codeSnippet['content'] ?? '',
          };
        }).toList();

        // Create a new post map with a "content" key.
        final Map<String, dynamic> postData = {
          ...item,
          'content': content,
        };

        // Navigate to the details screen using the slug.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlogPostScreen(post: postData),
          ),
        );
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['title'],
              ),
              const SizedBox(height: 8),
              Text(item['description']),
              const SizedBox(height: 8),
              Text(
                'Slug: ${item['slug']}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 8),
              if (codeData.isNotEmpty) ...[
                const Text(
                  'Code Snippet:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                for (var code in codeData)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      code['content'] ?? '',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
              ],
              const SizedBox(height: 8),
              Text('Created: ${item['created_at']}'),
            ],
          ),
        ),
      ),
    );
  }
}
