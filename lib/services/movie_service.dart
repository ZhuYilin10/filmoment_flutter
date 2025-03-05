import 'dart:math';
import '../utils/http_client.dart';

class MovieService {
  final HttpClient _client = HttpClient.instance;
  // 设置最大页数限制
  static const int MAX_PAGE = 500;

  Future<List<Map<String, dynamic>>> getRandomPopularMovies(int count) async {
    try {
      // 第一次请求，获取总页数
      print('开始第一次请求...');
      final initialResponse = await _client.get<Map<String, dynamic>>(
        '/movie/popular',
        queryParameters: {
          'language': 'zh-CN',
          'page': 1,
        },
      );
      
      // 获取总页数，但限制最大值
      final int totalPages = min(
        initialResponse['total_pages'] as int,
        MAX_PAGE
      );
      
      final random = Random();
      List<Map<String, dynamic>> validMovies = [];
      
      // 持续获取数据直到找到足够的有效电影
      while (validMovies.length < count) {
        final randomPage = random.nextInt(totalPages - 1) + 1;
        print('尝试获取第 $randomPage 页的数据');
        
        final response = await _client.get<Map<String, dynamic>>(
          '/movie/popular',
          queryParameters: {
            'language': 'zh-CN',
            'page': randomPage,
          },
        );
        
        final List<dynamic> results = response['results'] as List<dynamic>;
        final List<Map<String, dynamic>> movies = results.cast<Map<String, dynamic>>();
        
        // 过滤出有效的电影（有简介的）
        final validMoviesFromPage = movies.where((movie) {
          final overview = movie['overview'] as String?;
          return overview != null && overview.trim().isNotEmpty;
        }).toList();
        
        // 打乱有效电影的顺序
        validMoviesFromPage.shuffle(random);
        
        // 添加到有效电影列表中
        validMovies.addAll(validMoviesFromPage);
        
        // 如果收集到足够的有效电影，就截取需要的数量
        if (validMovies.length >= count) {
          validMovies = validMovies.take(count).toList();
          break;
        }
      }
      
      return validMovies;
    } catch (e) {
      print('获取电影失败: $e');
      rethrow;
    }
  }
} 