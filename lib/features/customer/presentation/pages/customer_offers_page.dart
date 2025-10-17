import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerOffersPage extends StatelessWidget {
  const CustomerOffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo data for offers
    final List<Map<String, dynamic>> demoOffers = [
      {
        'id': '1',
        'title': 'Oil Change Special',
        'description': 'Get 20% off on your next oil change service',
        'discount': '20%',
        'validUntil': '2024-04-30',
        'originalPrice': '150',
        'discountedPrice': '120',
        'isActive': true,
      },
      {
        'id': '2',
        'title': 'Brake Service Package',
        'description': 'Complete brake service with 15% discount',
        'discount': '15%',
        'validUntil': '2024-05-15',
        'originalPrice': '400',
        'discountedPrice': '340',
        'isActive': true,
      },
      {
        'id': '3',
        'title': 'Engine Tune-up',
        'description': 'Comprehensive engine check and tune-up',
        'discount': '25%',
        'validUntil': '2024-03-31',
        'originalPrice': '300',
        'discountedPrice': '225',
        'isActive': false,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Special Offers'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: demoOffers.length,
        itemBuilder: (context, index) {
          final offer = demoOffers[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16.h),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: offer['isActive']
                    ? LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.1),
                          Colors.white,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: offer['isActive'] ? Colors.green : Colors.grey,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            offer['isActive'] ? 'Active' : 'Expired',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Text(
                            '${offer['discount']} OFF',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      offer['title'],
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      offer['description'],
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Text(
                          'Valid until: ${offer['validUntil']}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[500],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${offer['originalPrice']} EGP',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[500],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '${offer['discountedPrice']} EGP',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    if (offer['isActive']) ...[
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Book service with offer
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: const Text('Book Service'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}