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
      final randomPage = random.nextInt(totalPages - 1) + 1;
      
      print('总页数(限制500页): $totalPages, 随机选择第 $randomPage 页');
      
      // 使用随机页数重新请求
      print('开始第二次请求，页数: $randomPage');
      try {
        final response = await _client.get<Map<String, dynamic>>(
          '/movie/popular',
          queryParameters: {
            'language': 'zh-CN',
            'page': randomPage,
          },
        );
        
        print('第二次请求成功，开始处理数据');
        final List<dynamic> results = response['results'] as List<dynamic>;
        final List<Map<String, dynamic>> movies = results.cast<Map<String, dynamic>>();
        
        movies.shuffle(random);
        return movies.take(count).toList();
      } catch (e, stackTrace) {
        print('第二次请求失败');
        print('错误: $e');
        print('堆栈: $stackTrace');
        rethrow;
      }
    } catch (e, stackTrace) {
      print('获取电影失败');
      print('错误: $e');
      print('堆栈: $stackTrace');
      rethrow;
    }
  }
} 