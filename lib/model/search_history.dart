import 'dart:developer';

class SearchHistory {
    String search;
    int?  search_id;
    //DateTime storedAt;
    //int countSearch;
    //SearchHistory({required this.search, required this.storedAt, required this.countSearch});
    SearchHistory({required this.search});
    SearchHistory.secondConstructor({required this.search, required this.search_id});
    Map<String, dynamic> toJson() {
        return {
            "search": search,
            //"storedAt": storedAt,
            //"countSearch": countSearch
        };
    }

    static SearchHistory fromJson({required Map<String, dynamic> searchMap}) {
        SearchHistory searchHistory =
                SearchHistory.secondConstructor(search: searchMap['search'], search_id: searchMap['search_id']);
                //SearchHistory(search: searchMap['search'] as String);
        return searchHistory;
    }

    @override
    bool operator ==(Object other) {
        return this == other;
    }

    @override
    int get hashCode => search.hashCode;
}
