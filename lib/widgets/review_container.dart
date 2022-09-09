import 'package:flutter/material.dart';

import '../common.dart';
import '../data/model/from_api/restaurant_detail.dart';

class ReviewContainer extends StatelessWidget {
  /// [CustomerReview] object
  final CustomerReview customerReviews;

  /// Review max lines.
  final int? maxLinesReview;

  const ReviewContainer({
    Key? key,
    required this.customerReviews,
    this.maxLinesReview = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryColorBrightest.withOpacity(0.15),
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: primaryColorBrightest,
                foregroundColor: primaryColor,
                child: Text(
                  customerReviews.name.substring(0, 1),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customerReviews.name,
                    style: txtThemeH6?.copyWith(color: secondaryColor),
                  ),
                  Text(
                    AppLocalizations.of(context)!
                        .reviewDate(customerReviews.date),
                    style: txtThemeCaption?.copyWith(
                      color: primaryColorBrighter,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            customerReviews.review,
            maxLines: maxLinesReview,
            overflow: TextOverflow.ellipsis,
            style: txtThemeH6?.copyWith(color: primaryColor),
          ),
        ],
      ),
    );
  }
}
