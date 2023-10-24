import 'package:flutter/material.dart';

class Manual extends StatelessWidget {
  final List<int> currentId;
  const Manual({Key? key, required this.currentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 50,
          child: Text('说明：'),
        ),
        Container(
          width: 100,
          height: 50,
          color: Colors.red,
          child: const Center(child: Text('CPU操作')),
        ),
        const SizedBox(width: 30),
        Container(
          width: 100,
          height: 50,
          color: Colors.green,
          child: const Center(child: Text('I/O操作')),
        ),
        const SizedBox(width: 30),
        Container(
          width: 100,
          height: 50,
          color: Colors.blue,
          child: const Center(child: Text('已完成块')),
        ),
        const SizedBox(width: 20),
        Container(
          height: 50,
          color: Colors.grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('下一执行CPU计算进程：${currentId[0] == -1 ? '无' : currentId[0]}'),
              Text('下一执行IO操作进程：${currentId[1] == -1 ? '无' : currentId[1]}'),
            ],
          ),
        ),
      ],
    ); // 调度算法说明,
  }
}
