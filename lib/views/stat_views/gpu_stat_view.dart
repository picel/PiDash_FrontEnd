import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pi_dash/models/gpu_stat_model.dart';

class GPUStatView extends StatelessWidget {
  final GPUStatModel gpuData;
  const GPUStatView({super.key, required this.gpuData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xffa3b18a),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.025,
        vertical: MediaQuery.of(context).size.height * 0.02,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GPU',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.04,
              fontWeight: FontWeight.bold,
              color: const Color(0xff344e41),
            ),
          ),
          Text(
            'Core ${gpuData.utilization.gpu.toStringAsFixed(2)}%',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.03,
              fontWeight: FontWeight.bold,
              color: const Color(0xff344e41),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.25 / 10,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    width: max(
                      gpuData.utilization.gpu /
                          100 *
                          MediaQuery.of(context).size.width *
                          0.4,
                      MediaQuery.of(context).size.height * 0.25 / 10,
                    ),
                    height: MediaQuery.of(context).size.height * 0.25 / 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xff344e41),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Memory ${gpuData.utilization.memory.toStringAsFixed(2)}%',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.03,
              fontWeight: FontWeight.bold,
              color: const Color(0xff344e41),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.25 / 10,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    width: max(
                      gpuData.utilization.memory /
                          100 *
                          MediaQuery.of(context).size.width *
                          0.4,
                      MediaQuery.of(context).size.height * 0.25 / 10,
                    ),
                    height: MediaQuery.of(context).size.height * 0.25 / 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xff344e41),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Temperature ${gpuData.temperature.toStringAsFixed(2)}°C',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.03,
              fontWeight: FontWeight.bold,
              color: const Color(0xff344e41),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.25 / 10,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    width: max(
                      gpuData.temperature /
                          100 *
                          MediaQuery.of(context).size.width *
                          0.4,
                      MediaQuery.of(context).size.height * 0.25 / 10,
                    ),
                    height: MediaQuery.of(context).size.height * 0.25 / 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (gpuData.temperature > 80)
                          ? Colors.red
                          : (gpuData.temperature > 50)
                              ? Colors.yellow
                              : Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Power ${gpuData.power.usage.toStringAsFixed(2)}W/${gpuData.power.limit.toStringAsFixed(2)}W',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.03,
              fontWeight: FontWeight.bold,
              color: const Color(0xff344e41),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.25 / 10,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    width: (gpuData.power.limit == 0)
                        ? MediaQuery.of(context).size.height * 0.25 / 10
                        : max(
                            gpuData.power.usage /
                                gpuData.power.limit *
                                MediaQuery.of(context).size.width *
                                0.4,
                            MediaQuery.of(context).size.height * 0.25 / 10,
                          ),
                    height: MediaQuery.of(context).size.height * 0.25 / 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (gpuData.power.usage / gpuData.power.limit > 0.8)
                          ? Colors.red
                          : (gpuData.power.usage / gpuData.power.limit > 0.5)
                              ? Colors.yellow
                              : const Color(0xff344e41),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.6),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.025,
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SM Clock',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff344e41),
                      ),
                    ),
                    Text(
                      gpuData.clock.smClock,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff344e41),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Memory Clock',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff344e41),
                      ),
                    ),
                    Text(
                      gpuData.clock.memClock,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff344e41),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Video Clock',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff344e41),
                      ),
                    ),
                    Text(
                      gpuData.clock.videoClock,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff344e41),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Graphics Clock',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff344e41),
                      ),
                    ),
                    Text(
                      gpuData.clock.graphicsClock,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff344e41),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
