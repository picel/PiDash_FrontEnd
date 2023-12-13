import 'package:flutter/material.dart';
import 'package:pi_dash/models/net_stat_model.dart';
import 'package:pi_dash/utils/FormatUtils.dart';

class NetStatView extends StatelessWidget {
  final NetStatModel netData;
  const NetStatView({super.key, required this.netData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff463f3a),
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
          // stack row and text, text should be on center
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_upward_outlined,
                        color: const Color(0xffbcb8b1),
                        size: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Text(
                        '${FormatUtils.byteCountDecimal(netData.txSpeed)}/s',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.04,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffbcb8b1),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_downward_outlined,
                        color: const Color(0xffbcb8b1),
                        size: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Text(
                        '${FormatUtils.byteCountDecimal(netData.rxSpeed)}/s',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.04,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffbcb8b1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  (netData.interface == '') ? 'No Traffic' : netData.interface,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.04,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffbcb8b1),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
