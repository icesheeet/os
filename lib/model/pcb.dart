// 进程控制块模型
class PCB {
  int? pid; // 进程ID
  String? status; // 进程状态：运行、等待、完成
  double? curretPercent; // 进程完成百分比
  int? needTime; // 进程需要运行的时间
  // 进程的CPU计算和IO操作的时间片构成，1表示CPU计算，0表示IO操作，时间总和为needTime，-1表示进程已经完成
  List<Map<int, int>> timeSlice = [
    {-1: 0}
  ];
}
