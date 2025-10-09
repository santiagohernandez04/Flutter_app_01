/// Modelo para representar un GIF de Giphy
class GifModel {
  final String id;
  final String title;
  final String url;
  final String rating;
  final GifImages images;

  GifModel({
    required this.id,
    required this.title,
    required this.url,
    required this.rating,
    required this.images,
  });

  /// Crea una instancia de GifModel desde un JSON
  factory GifModel.fromJson(Map<String, dynamic> json) {
    return GifModel(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Sin título',
      url: json['url'] ?? '',
      rating: json['rating'] ?? 'g',
      images: GifImages.fromJson(json['images'] ?? {}),
    );
  }

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'rating': rating,
      'images': images.toJson(),
    };
  }
}

/// Modelo para las diferentes resoluciones de imágenes del GIF
class GifImages {
  final GifImageData original;
  final GifImageData? fixedHeight;
  final GifImageData? fixedWidth;
  final GifImageData? downsized;

  GifImages({
    required this.original,
    this.fixedHeight,
    this.fixedWidth,
    this.downsized,
  });

  factory GifImages.fromJson(Map<String, dynamic> json) {
    return GifImages(
      original: GifImageData.fromJson(json['original'] ?? {}),
      fixedHeight: json['fixed_height'] != null
          ? GifImageData.fromJson(json['fixed_height'])
          : null,
      fixedWidth: json['fixed_width'] != null
          ? GifImageData.fromJson(json['fixed_width'])
          : null,
      downsized: json['downsized'] != null
          ? GifImageData.fromJson(json['downsized'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'original': original.toJson(),
      'fixed_height': fixedHeight?.toJson(),
      'fixed_width': fixedWidth?.toJson(),
      'downsized': downsized?.toJson(),
    };
  }
}

/// Modelo para los datos de una imagen específica
class GifImageData {
  final String url;
  final String? width;
  final String? height;

  GifImageData({
    required this.url,
    this.width,
    this.height,
  });

  factory GifImageData.fromJson(Map<String, dynamic> json) {
    return GifImageData(
      url: json['url'] ?? '',
      width: json['width'],
      height: json['height'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'width': width,
      'height': height,
    };
  }
}

/// Modelo para la respuesta completa de la API de Giphy
class GiphyResponse {
  final List<GifModel> data;
  final GiphyPagination pagination;

  GiphyResponse({
    required this.data,
    required this.pagination,
  });

  factory GiphyResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dataList = json['data'] ?? [];
    return GiphyResponse(
      data: dataList.map((gif) => GifModel.fromJson(gif)).toList(),
      pagination: GiphyPagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

/// Modelo para la paginación de la respuesta
class GiphyPagination {
  final int totalCount;
  final int count;
  final int offset;

  GiphyPagination({
    required this.totalCount,
    required this.count,
    required this.offset,
  });

  factory GiphyPagination.fromJson(Map<String, dynamic> json) {
    return GiphyPagination(
      totalCount: json['total_count'] ?? 0,
      count: json['count'] ?? 0,
      offset: json['offset'] ?? 0,
    );
  }
}

