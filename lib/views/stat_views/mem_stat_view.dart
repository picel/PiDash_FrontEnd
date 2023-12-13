import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pi_dash/models/mem_stat_model.dart';
import 'package:pi_dash/utils/FormatUtils.dart';

class MemStatView extends StatelessWidget {
  final MemStatModel memData;
  const MemStatView({super.key, required this.memData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff4a4e69),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.025,
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.15,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Memory',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.04,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffc9ada7),
                ),
              ),
              Text(
                '${FormatUtils.byteCountDecimal(memData.used)} / ${FormatUtils.byteCountDecimal(memData.total)}',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.04,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffc9ada7),
                ),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.025,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                // show memory usage bar with used, reserved
                Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    width: (memData.total == 0)
                        ? 0
                        : max(
                            memData.used /
                                memData.total *
                                MediaQuery.of(context).size.width *
                                0.8,
                            MediaQuery.of(context).size.height * 0.25 / 10,
                          ),
                    height: MediaQuery.of(context).size.height * 0.25 / 10,
                    decoration: BoxDecoration(
                      color: const Color(0xffc9ada7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
