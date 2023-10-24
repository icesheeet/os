import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:os_flutter/model/pcb.dart';
import 'package:os_flutter/page/components/manual.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 下拉框选择的值
  String? valueAlgorithm = '时间片轮转';
  String? valueProcessNum = '2';
  String? valueTimeSlice = '10';
  // PCB
  List<PCB> pcbs = [];
  // 正在运行中的进程号，第一个表示CPU，第二个表示IO
  List<int> currentId = [-1, -1];

  // 获取下一个CPU运行的进程号
  int getNextCpuId(List<int> currentId) {
    // 循环pcbs.length次，如果没有找到下一个CPU运行的进程，返回-1
    for (int index = currentId[0] + 1;
        index < pcbs.length + currentId[0] + 1;
        index++) {
      int indexTemp = index % pcbs.length;
      var timeSlice = pcbs[indexTemp].timeSlice;
      int timeSliceId = 0;
      while (timeSlice[timeSliceId].keys.first == -1) {
        timeSliceId++;
      }
      if (timeSliceId > timeSlice.length) {
        continue;
      }
      if (timeSlice[timeSliceId].keys.first == 1) {
        return pcbs[indexTemp].pid! + 1;
      }
    }
    return -1;
  }

  // 获取下一个IO运行的进程号
  int getNextIoId(List<int> currentId) {
    // 循环pcbs.length次，如果没有找到下一个IO运行的进程，返回-1
    for (int index = currentId[1] + 1;
        index < pcbs.length + currentId[1] - 1;
        index++) {
      int indexTemp = index % pcbs.length;
      var timeSlice = pcbs[indexTemp].timeSlice;
      int timeSliceId = 0;
      while (timeSlice[timeSliceId].keys.first == -1) {
        timeSliceId++;
      }
      if (timeSliceId > timeSlice.length) {
        continue;
      }
      if (timeSlice[timeSliceId].keys.first == 0) {
        return pcbs[indexTemp].pid! + 1;
      }
    }
    return -1;
  }

  // 时间片轮转调度
  void timeSliceRoundRobin() {
    // 不是所有进程都已经完成
    if (!pcbs.every((element) => (element.status == '完成'))) {
      int timeSliceId = 0;
      if (currentId[0] != -1) {
        var timeSlice = pcbs[currentId[0]].timeSlice;
        while (timeSlice[timeSliceId].keys.first == -1) {
          timeSliceId++;
        }
        // 更新已完成
        timeSlice[0]
            .update(-1, (value) => value + timeSlice[timeSliceId].values.first);
        // 更新当前进程的完成百分比
        pcbs[currentId[0]].curretPercent =
            timeSlice[0].values.first / pcbs[currentId[0]].needTime!;
        // 删除当前进程的第一个时间片
        timeSlice.removeAt(timeSliceId);
      }
      // timeSliceId = 0;
      // if (currentId[1]!=-1){
      //   var timeSlice = pcbs[currentId[1]].timeSlice;
      //   while (timeSlice[timeSliceId].keys.first == -1) {
      //     timeSliceId++;
      //   }
      //   // 更新已完成
      //   timeSlice[0]
      //       .update(-1, (value) => value + timeSlice[timeSliceId].values.first);
      //   // 更新当前进程的完成百分比
      //   pcbs[currentId[1]].curretPercent =
      //       timeSlice[0].values.first / pcbs[currentId[1]].needTime!;
      //   // 删除当前进程的第一个时间片
      //   timeSlice.removeAt(timeSliceId);
      // }
    }
    currentId[0] = getNextCpuId(currentId);
    currentId[1] = getNextIoId(currentId);
    setState(() {
      currentId = currentId;
      pcbs = pcbs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center, // 上下居中
        children: <Widget>[
          // 配置
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // 下拉框选择调度算法
            children: [
              const SizedBox(
                width: 80,
                child: Text('调度算法：'),
              ),
              DropdownButton<String>(
                value: valueAlgorithm,
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem<String>(
                    value: '时间片轮转',
                    child: Text('时间片轮转'),
                  ),
                  DropdownMenuItem<String>(
                    value: '优先级调度',
                    child: Text('优先级调度'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    valueAlgorithm = value;
                  });
                },
              ),
              const SizedBox(width: 30),
              // 下拉选择进程数：2，3，4
              const SizedBox(
                width: 80,
                child: Text('进程数：'),
              ),
              DropdownButton<String>(
                value: valueProcessNum,
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem<String>(
                    value: '2',
                    child: Text('2'),
                  ),
                  DropdownMenuItem<String>(
                    value: '3',
                    child: Text('3'),
                  ),
                  DropdownMenuItem<String>(
                    value: '4',
                    child: Text('4'),
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    valueProcessNum = value;
                  });
                },
              ),
              const SizedBox(width: 30),
              // 下拉选择时间片大小：10，20，30
              const SizedBox(
                width: 100,
                child: Text('时间片大小：'),
              ),
              DropdownButton<String>(
                value: valueTimeSlice,
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem<String>(
                    value: '10',
                    child: Text('10'),
                  ),
                  DropdownMenuItem<String>(
                    value: '20',
                    child: Text('20'),
                  ),
                  DropdownMenuItem<String>(
                    value: '30',
                    child: Text('30'),
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    valueTimeSlice = value;
                  });
                },
              ),
            ],
          ), // 调度算法配置
          const SizedBox(height: 20),
          // 调度算法说明
          Manual(
            currentId: currentId,
          ),
          const SizedBox(height: 20),
          // 进程调度显示
          const Text('进程调度显示'),
          Column(
            // for循环显示pcbNum个进程
            children: List.generate(
              pcbs.length,
              (index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // 左对齐
                    const SizedBox(width: 50),
                    // 进程号
                    Text('进程${index + 1}'),
                    // 进程的CPU计算和IO操作的时间片构成
                    Row(
                      children: List.generate(
                        pcbs[index].timeSlice.length,
                        (index2) {
                          return Container(
                            // 设置边距
                            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            width: pcbs[index].timeSlice[index2].values.first *
                                5.0,
                            height: 50,
                            color: () {
                              switch (
                                  pcbs[index].timeSlice[index2].keys.first) {
                                case 1:
                                  return Colors.red;
                                case 0:
                                  return Colors.green;
                                default:
                                  return Colors.blue;
                              }
                            }(),
                            child: Text(
                                '${pcbs[index].timeSlice[index2].values.first}'),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 50),
                    // 进程完成百分比，保留两位小数
                    Text(
                        '完成百分比：${(pcbs[index].curretPercent! * 100).toStringAsFixed(2)}%'),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      // 进程调度显示
      persistentFooterButtons: [
        // 创建进程
        TextButton(
          onPressed: () {
            // 创建valueProcessNum个进程，时间片大小随机
            if (pcbs.isNotEmpty) {
              return;
            }
            for (int i = 0; i < int.parse(valueProcessNum!); i++) {
              PCB pcb = PCB();
              pcb.pid = i;
              pcb.status = '等待';
              pcb.curretPercent = 0.0;
              // 随机生成时间片，每片大小在20-50之间，总和为needTime
              int timeSliceSum = 0;
              while (timeSliceSum <= 150) {
                // 生成CPU计算时间片
                int timeSlice = Random().nextInt(30) + 20;
                timeSliceSum += timeSlice;
                while (timeSlice > 0) {
                  if (timeSlice >= int.parse(valueTimeSlice!)) {
                    pcb.timeSlice.add({1: int.parse(valueTimeSlice!)});
                    timeSlice -= int.parse(valueTimeSlice!);
                  } else {
                    pcb.timeSlice.add({1: timeSlice});
                    timeSlice = 0;
                  }
                }
                // 生成IO操作时间片
                if (timeSliceSum <= 150) {
                  int timeSlice = Random().nextInt(30) + 20;
                  timeSliceSum += timeSlice;
                  while (timeSlice > 0) {
                    if (timeSlice >= int.parse(valueTimeSlice!)) {
                      pcb.timeSlice.add({0: int.parse(valueTimeSlice!)});
                      timeSlice -= int.parse(valueTimeSlice!);
                    } else {
                      pcb.timeSlice.add({0: timeSlice});
                      timeSlice = 0;
                    }
                  }
                }
              }
              pcb.needTime = timeSliceSum;
              pcbs.add(pcb);
              print('进程$i创建成功');
            }

            currentId[0] = getNextCpuId(currentId);
            currentId[1] = getNextIoId(currentId);
            setState(() {
              pcbs = pcbs;
              currentId = currentId;
            });
          },
          child: const Text('创建进程'),
        ),
        // 开始运行
        TextButton(
          onPressed: () {
            switch (valueAlgorithm) {
              case '时间片轮转':
                timeSliceRoundRobin();
                break;
              case '优先级调度':
                break;
            }
          },
          child: const Text('运行到下一步'),
        ),
        // 重新开始
        TextButton(
          onPressed: () {
            pcbs.clear();
            setState(() {
              pcbs = pcbs;
              currentId = [-1, -1];
            });
          },
          child: const Text('重新开始'),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('暂停运行'),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('数据分析（TODO）'),
        ),
        // 退出
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('退出'),
                content: const Text('确定退出吗？'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('取消'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // 退出程序
                      exit(0);
                    },
                    child: const Text('确定'),
                  ),
                ],
              ),
            );
          },
          child: const Text('退出'),
        ),
        // 关于
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => const AboutDialog(
                applicationName: '模拟进程调度',
                applicationVersion: '1.0.0',
                applicationIcon: Icon(Icons.web),
                children: [
                  Text('作者：葛兴海'),
                  Text('学号：211540378'),
                ],
              ),
            );
          },
          child: const Text('关于'),
        ),
      ],
    );
  }
}
