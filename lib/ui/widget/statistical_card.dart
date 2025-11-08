import 'package:flutter/material.dart';
import 'package:pen/ui/theme/theme.dart';

class StatisticalCard extends StatelessWidget {
  const StatisticalCard({super.key, required this.title, required this.icon, required this.numericData, required this.cardColor});
  final String title;
  final Icon icon;
  final String numericData;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 103,
        width: 180,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon.icon, size: 25, color: icon.color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: subheadingStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Text(
                numericData,
                style: headingStyle.copyWith(fontSize: 20, color: black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}