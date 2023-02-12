// ignore_for_file: unnecessary_new, prefer_collection_literals

class HomeModel {
  Movie? banner;
  List<Movie>? action;
  List<Movie>? romance;
  List<Movie>? series;

  HomeModel({this.banner, this.action, this.romance, this.series});

  HomeModel.fromJson(Map<String, dynamic> json) {
    banner =
        json['banner'] != null ? new Movie.fromJson(json['banner']) : null;
    if (json['action'] != null) {
      action = <Movie>[];
      json['action'].forEach((v) {
        action!.add(new Movie.fromJson(v));
      });
    }
    if (json['romance'] != null) {
      romance = <Movie>[];
      json['romance'].forEach((v) {
        romance!.add(new Movie.fromJson(v));
      });
    }
    if (json['series'] != null) {
      series = <Movie>[];
      json['series'].forEach((v) {
        series!.add(new Movie.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (banner != null) {
      data['banner'] = banner!.toJson();
    }
    if (action != null) {
      data['action'] = action!.map((v) => v.toJson()).toList();
    }
    if (romance != null) {
      data['romance'] = romance!.map((v) => v.toJson()).toList();
    }
    if (series != null) {
      data['series'] = series!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Movie {
  bool? adult;
  String? backdropPath;
  int? id;
  String? name;
  String? title;
  String? originalLanguage;
  String? originalName;
  String? overview;
  String? posterPath;
  String? mediaType;
  List<int>? genreIds;
  double? popularity;
  String? firstAirDate;
  double? voteAverage;
  int? voteCount;
  List<String>? genre;
  String? quality;
  String? imdb;
  String? runtime;
  int? season;

  Movie(
      {this.adult,
      this.backdropPath,
      this.id,
      this.name,
      this.title,
      this.runtime,
      this.originalLanguage,
      this.originalName,
      this.overview,
      this.posterPath,
      this.mediaType,
      this.genreIds,
      this.popularity,
      this.firstAirDate,
      this.voteAverage,
      this.voteCount,
      this.genre,
      this.imdb,
      this.quality,
      this.season});

  Movie.fromJson(Map<String, dynamic> json) {
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    id = json['id'];
    name = json['name'];
    originalLanguage = json['original_language'];
    originalName = json['original_name'];
    overview = json['overview'];
    posterPath = json['poster_path'];
    mediaType = json['media_type'];
    genreIds = json['genre_ids'].cast<int>();
    popularity = json['popularity'];
    quality = json['quality'];
    firstAirDate = json['first_air_date'];
    voteAverage = double.parse(json['vote_average'].toString());
    voteCount = json['vote_count'];
    genre = json['genre'].cast<String>();
    imdb = json['imdb'];
    title = json['title'];
    runtime = json['runtime'];
    season = json['season'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adult'] = adult;
    data['backdrop_path'] = backdropPath;
    data['id'] = id;
    data['name'] = name;
    data['title'] = title;
    data['original_language'] = originalLanguage;
    data['original_name'] = originalName;
    data['overview'] = overview;
    data['poster_path'] = posterPath;
    data['media_type'] = mediaType;
    data['genre_ids'] = genreIds;
    data['popularity'] = popularity;
    data['quality'] = quality;
    data['first_air_date'] = firstAirDate;
    data['vote_average'] = voteAverage;
    data['vote_count'] = voteCount;
    data['genre'] = genre;
    data['imdb'] = imdb;
    data['season'] = season;
    data['runtime'] = runtime;
    return data;
  }
}