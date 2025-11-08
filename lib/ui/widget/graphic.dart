import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pen/ui/theme/theme.dart';

class GraphicalCard extends StatelessWidget {
  const GraphicalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 414,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kategori Terlaris',
            style: headingStyle.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 60,
                      sections: [
                        PieChartSectionData(
                          color: const Color(0xFF5570F1),
                          value: 35,
                          title: '',
                          radius: 30,
                        ),
                        PieChartSectionData(
                          color: const Color(0xFF97A5EB),
                          value: 25,
                          title: '',
                          radius: 30,
                          
                        ),
                        PieChartSectionData(
                          color: const Color(0xFFFFCC5C),
                          value: 20,
                          title: '',
                          radius: 30,
                        ),
                        PieChartSectionData(
                          color: const Color(0xFFFF6B6B),
                          value: 20,
                          title: '',
                          radius: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegend('Pakaian', const Color(0xFF5570F1)),
                      const SizedBox(height: 12),
                      _buildLegend('Aksesoris', const Color(0xFFFFCC5C)),
                      const SizedBox(height: 12),
                      _buildLegend('Elektronik', const Color(0xFF97A5EB)),
                      const SizedBox(height: 12),
                      _buildLegend('Lainnya', const Color(0xFFFF6B6B)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: gray,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}