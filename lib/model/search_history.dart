class SearchHistory {
  String search;
  int? searchId;

  SearchHistory({required this.search});
  
  SearchHistory.secondConstructor({
    required this.search, 
    required int? searchId,
  }) : this.searchId = searchId;

  Map<String, dynamic> toJson() {
    return {
      "search": search,
      "search_id": searchId,
    };
  }

  static SearchHistory fromJson({required Map<String, dynamic> searchMap}) {
    return SearchHistory.secondConstructor(
      search: searchMap['search'], 
      searchId: searchMap['search_id'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchHistory && 
           other.search == search && 
           other.searchId == searchId;
  }

  @override
  int get hashCode => search.hashCode ^ (searchId?.hashCode ?? 0);
}
