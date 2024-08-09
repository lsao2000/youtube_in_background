class SearchHistory {
    String search;
    DateTime storedAt;
    int countSearch;
    SearchHistory({required this.search, required this.storedAt, required this.countSearch});

    Map<String, dynamic> toJson(){
        return {
            "search": search,
            "storedAt": storedAt,
            "countSearch": countSearch
        };
    }
}
