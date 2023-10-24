import 'package:flutter/material.dart';
import 'package:os_flutter/page/home_page.dart';

/// !!!中文字体需要在网络正常的情况下才能加载
void main() => runApp(const ProcessSchedule());

class ProcessSchedule extends StatelessWidget {
  const ProcessSchedule({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '模拟进程调度',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 43, 97, 159)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '模拟进程调度'),
    );
  }
}
