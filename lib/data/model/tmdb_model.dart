class Tmdb {
  bool? adult;
  String? backdropPath;
  String? firstAirDate;
  List<Genres>? genres;
  String? name;
  int? numberOfEpisodes;
  int? numberOfSeasons;
  String? overview;
  String? posterPath;
  List<Seasons>? seasons;
  String? tagline;
  int? voteCount;
  int? id;
  Videos? videos;
  Images? images;
  ExternalIds? externalIds;
  Credits? credits;
  double? runtime;

  Tmdb(
      {this.adult,
      this.backdropPath,
      this.firstAirDate,
      this.genres,
      this.name,
      this.numberOfEpisodes,
      this.numberOfSeasons,
      this.overview,
      this.posterPath,
      this.seasons,
      this.id,
      this.tagline,
      this.voteCount,
      this.videos,
      this.images,
      this.runtime,
      this.credits,
      this.externalIds});

  Tmdb.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    firstAirDate = json['first_air_date'] ?? json['release_date'];
    if (json['genres'] != null) {
      genres = <Genres>[];
      json['genres'].forEach((v) {
        genres!.add(Genres.fromJson(v));
      });
    }
    name = json['name'] ?? json['title'];
    runtime = double.tryParse(json['runtime'].toString());

    numberOfEpisodes = json['number_of_episodes'];
    numberOfSeasons = json['number_of_seasons'];
    overview = json['overview'];
    posterPath = json['poster_path'];

    if (json['seasons'] != null) {
      seasons = <Seasons>[];
      json['seasons'].forEach((v) {
        seasons!.add(Seasons.fromJson(v));
      });
    }

    tagline = json['tagline'];
    voteCount = json['vote_count'];
    videos = json['videos'] != null ? Videos.fromJson(json['videos']) : null;
    images = json['images'] != null ? Images.fromJson(json['images']) : null;
    credits = json['credits'] != null ? Credits.fromJson(json['credits']) : null;
    externalIds = json['external_ids'] != null ? ExternalIds.fromJson(json['external_ids']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adult'] = adult;
    data['id'] = id;
    data['backdrop_path'] = backdropPath;

    data['first_air_date'] = firstAirDate;
    if (genres != null) {
      data['genres'] = genres!.map((v) => v.toJson()).toList();
    }

    data['name'] = name;
    data['runtime'] = runtime;

    data['number_of_episodes'] = numberOfEpisodes;
    data['number_of_seasons'] = numberOfSeasons;
    data['overview'] = overview;
    data['poster_path'] = posterPath;

    if (seasons != null) {
      data['seasons'] = seasons!.map((v) => v.toJson()).toList();
    }

    data['tagline'] = tagline;
    data['vote_count'] = voteCount;
    if (videos != null) {
      data['videos'] = videos!.toJson();
    }
    if (images != null) {
      data['images'] = images!.toJson();
    }
    if (credits != null) {
      data['credits'] = credits!.toJson();
    }
    if (externalIds != null) {
      data['external_ids'] = externalIds!.toJson();
    }
    return data;
  }
}

class Genres {
  int? id;
  String? name;

  Genres({this.id, this.name});

  Genres.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Seasons {
  String? airDate;
  int? episodeCount;
  int? id;
  String? name;
  String? overview;
  String? posterPath;
  int? seasonNumber;
  double? voteAverage;

  Seasons({this.airDate, this.episodeCount, this.id, this.name, this.overview, this.posterPath, this.seasonNumber, this.voteAverage});

  Seasons.fromJson(Map<String, dynamic> json) {
    airDate = json['air_date'];
    episodeCount = json['episode_count'];
    id = json['id'];
    name = json['name'];
    overview = json['overview'];
    posterPath = json['poster_path'];
    seasonNumber = json['season_number'];
    voteAverage = double.tryParse(json['vote_average'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['air_date'] = airDate;
    data['episode_count'] = episodeCount;
    data['id'] = id;
    data['name'] = name;
    data['overview'] = overview;
    data['poster_path'] = posterPath;
    data['season_number'] = seasonNumber;
    data['vote_average'] = voteAverage;
    return data;
  }
}

class Videos {
  List<Results>? results;

  Videos({this.results});

  Videos.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String? iso6391;
  String? iso31661;
  String? name;
  String? key;
  String? publishedAt;
  String? site;
  int? size;
  String? type;
  bool? official;
  String? id;

  Results({this.iso6391, this.iso31661, this.name, this.key, this.publishedAt, this.site, this.size, this.type, this.official, this.id});

  Results.fromJson(Map<String, dynamic> json) {
    iso6391 = json['iso_639_1'];
    iso31661 = json['iso_3166_1'];
    name = json['name'];
    key = json['key'];
    publishedAt = json['published_at'];
    site = json['site'];
    size = json['size'];
    type = json['type'];
    official = json['official'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['iso_639_1'] = iso6391;
    data['iso_3166_1'] = iso31661;
    data['name'] = name;
    data['key'] = key;
    data['published_at'] = publishedAt;
    data['site'] = site;
    data['size'] = size;
    data['type'] = type;
    data['official'] = official;
    data['id'] = id;
    return data;
  }
}

class Images {
  List<ImagesData>? backdrops;
  List<ImagesData>? logos;
  List<ImagesData>? posters;

  Images({this.backdrops, this.logos, this.posters});

  Images.fromJson(Map<String, dynamic> json) {
    if (json['backdrops'] != null) {
      backdrops = <ImagesData>[];
      json['backdrops'].forEach((v) {
        backdrops!.add(ImagesData.fromJson(v));
      });
    }
    if (json['logos'] != null) {
      logos = <ImagesData>[];
      json['logos'].forEach((v) {
        logos!.add(ImagesData.fromJson(v));
      });
    }
    if (json['posters'] != null) {
      posters = <ImagesData>[];
      json['posters'].forEach((v) {
        posters!.add(ImagesData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (backdrops != null) {
      data['backdrops'] = backdrops!.map((v) => v.toJson()).toList();
    }
    if (logos != null) {
      data['logos'] = logos!.map((v) => v.toJson()).toList();
    }
    if (posters != null) {
      data['posters'] = posters!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImagesData {
  double? aspectRatio;
  int? height;
  String? iso6391;
  String? filePath;
  double? voteAverage;
  int? voteCount;
  int? width;

  ImagesData({this.aspectRatio, this.height, this.iso6391, this.filePath, this.voteAverage, this.voteCount, this.width});

  ImagesData.fromJson(Map<String, dynamic> json) {
    aspectRatio = double.tryParse(json['aspect_ratio'].toString());
    height = json['height'];
    iso6391 = json['iso_639_1'];
    filePath = json['file_path'];
    voteAverage = double.tryParse(json['vote_average'].toString());
    voteCount = json['vote_count'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aspect_ratio'] = aspectRatio;
    data['height'] = height;
    data['iso_639_1'] = iso6391;
    data['file_path'] = filePath;
    data['vote_average'] = voteAverage;
    data['vote_count'] = voteCount;
    data['width'] = width;
    return data;
  }
}

class ExternalIds {
  String? imdbId;

  ExternalIds({this.imdbId});

  ExternalIds.fromJson(Map<String, dynamic> json) {
    imdbId = json['imdb_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imdb_id'] = imdbId;
    return data;
  }
}

class Cast {
  bool? adult;
  int? gender;
  int? id;
  String? knownForDepartment;
  String? name;
  String? originalName;
  double? popularity;
  String? profilePath;
  String? character;
  String? creditId;
  int? order;

  Cast({this.adult, this.gender, this.id, this.knownForDepartment, this.name, this.originalName, this.popularity, this.profilePath, this.character, this.creditId, this.order});

  Cast.fromJson(Map<String, dynamic> json) {
    adult = json['adult'];
    gender = json['gender'];
    id = json['id'];
    knownForDepartment = json['known_for_department'];
    name = json['name'];
    originalName = json['original_name'];
    popularity = double.tryParse(json['popularity'].toString());
    profilePath = json['profile_path'];
    character = json['character'];
    creditId = json['credit_id'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adult'] = adult;
    data['gender'] = gender;
    data['id'] = id;
    data['known_for_department'] = knownForDepartment;
    data['name'] = name;
    data['original_name'] = originalName;
    data['popularity'] = popularity;
    data['profile_path'] = profilePath;
    data['character'] = character;
    data['credit_id'] = creditId;
    data['order'] = order;
    return data;
  }
}

class Credits {
  List<Cast>? cast;

  Credits({this.cast});

  Credits.fromJson(Map<String, dynamic> json) {
    if (json['cast'] != null) {
      cast = <Cast>[];
      json['cast'].forEach((v) {
        cast!.add(Cast.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cast != null) {
      data['cast'] = cast!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
