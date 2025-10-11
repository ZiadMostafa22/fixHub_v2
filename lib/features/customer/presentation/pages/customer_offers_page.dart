import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_maintenance_system_new/core/models/offer_model.dart';
import 'package:car_maintenance_system_new/core/services/firebase_service.dart';

class CustomerOffersPage extends ConsumerStatefulWidget {
  const CustomerOffersPage({super.key});

  @override
  ConsumerState<CustomerOffersPage> createState() => _CustomerOffersPageState();
}

class _CustomerOffersPageState extends ConsumerState<CustomerOffersPage> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offers & Announcements', style: TextStyle(fontSize: 18.sp)),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list, size: 22.sp),
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'all', child: Text('All', style: TextStyle(fontSize: 14.sp))),
              PopupMenuItem(value: 'announcement', child: Text('Announcements', style: TextStyle(fontSize: 14.sp))),
              PopupMenuItem(value: 'discount', child: Text('Discounts', style: TextStyle(fontSize: 14.sp))),
              PopupMenuItem(value: 'promotion', child: Text('Promotions', style: TextStyle(fontSize: 14.sp))),
              PopupMenuItem(value: 'news', child: Text('News', style: TextStyle(fontSize: 14.sp))),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseService.firestore
            .collection('offers')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text('Error loading offers', style: TextStyle(fontSize: 16.sp)),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_offer_outlined, size: 80.sp, color: Colors.grey),
                  SizedBox(height: 16.h),
                  Text(
                    'No offers available',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Check back later for new offers!',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          var offers = snapshot.data!.docs
              .map((doc) => OfferModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
              .toList();

          // Filter by active status first
          offers = offers.where((offer) => offer.isActive).toList();

          // Filter offers by type
          if (_selectedFilter != 'all') {
            offers = offers.where((offer) => 
              offer.type.toString().split('.').last == _selectedFilter
            ).toList();
          }

          // Filter by date (only show current and future offers)
          final now = DateTime.now();
          offers = offers.where((offer) {
            if (offer.endDate == null) return true;
            return offer.endDate!.isAfter(now);
          }).toList();

          if (offers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_offer_outlined, size: 80.sp, color: Colors.grey),
                  SizedBox(height: 16.h),
                  Text(
                    'No $_selectedFilter offers',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return _buildOfferCard(offer);
            },
          );
        },
      ),
    );
  }

  Widget _buildOfferCard(OfferModel offer) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: () => _showOfferDetails(offer),
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Offer Type Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: _getTypeColor(offer.type).withValues(alpha: 0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
              ),
              child: Row(
                children: [
                  Icon(_getTypeIcon(offer.type), size: 16.sp, color: _getTypeColor(offer.type)),
                  SizedBox(width: 4.w),
                  Text(
                    _getTypeName(offer.type),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: _getTypeColor(offer.type),
                    ),
                  ),
                  const Spacer(),
                  if (offer.discountPercentage != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '${offer.discountPercentage}% OFF',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    offer.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14.sp, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Text(
                        'Valid from ${DateFormat('MMM dd, yyyy').format(offer.startDate)}',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  if (offer.endDate != null) ...[
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.event, size: 14.sp, color: Colors.grey),
                        SizedBox(width: 4.w),
                        Text(
                          'Expires ${DateFormat('MMM dd, yyyy').format(offer.endDate!)}',
                          style: TextStyle(fontSize: 12.sp, color: Colors.red[600]),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOfferDetails(OfferModel offer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(offer.title, style: TextStyle(fontSize: 18.sp)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: _getTypeColor(offer.type).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_getTypeIcon(offer.type), size: 16.sp, color: _getTypeColor(offer.type)),
                    SizedBox(width: 4.w),
                    Text(
                      _getTypeName(offer.type),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: _getTypeColor(offer.type),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Text(offer.description, style: TextStyle(fontSize: 14.sp)),
              SizedBox(height: 16.h),
              if (offer.discountPercentage != null) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'DISCOUNT',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${offer.discountPercentage}% OFF',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      if (offer.code != null && offer.code!.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(color: Colors.red.shade300, style: BorderStyle.solid, width: 2),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Code: ',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                offer.code!,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Enter this code when booking to get the discount',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
              ],
              Text(
                'Valid Period:',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              Text(
                'From: ${DateFormat('MMMM dd, yyyy').format(offer.startDate)}',
                style: TextStyle(fontSize: 12.sp),
              ),
              if (offer.endDate != null)
                Text(
                  'Until: ${DateFormat('MMMM dd, yyyy').format(offer.endDate!)}',
                  style: TextStyle(fontSize: 12.sp),
                ),
              if (offer.terms != null && offer.terms!.isNotEmpty) ...[
                SizedBox(height: 16.h),
                Text(
                  'Terms & Conditions:',
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Text(
                  offer.terms!,
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[700]),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(OfferType type) {
    switch (type) {
      case OfferType.announcement:
        return Colors.blue;
      case OfferType.discount:
        return Colors.red;
      case OfferType.promotion:
        return Colors.green;
      case OfferType.news:
        return Colors.orange;
    }
  }

  IconData _getTypeIcon(OfferType type) {
    switch (type) {
      case OfferType.announcement:
        return Icons.campaign;
      case OfferType.discount:
        return Icons.local_offer;
      case OfferType.promotion:
        return Icons.star;
      case OfferType.news:
        return Icons.newspaper;
    }
  }

  String _getTypeName(OfferType type) {
    switch (type) {
      case OfferType.announcement:
        return 'ANNOUNCEMENT';
      case OfferType.discount:
        return 'DISCOUNT';
      case OfferType.promotion:
        return 'PROMOTION';
      case OfferType.news:
        return 'NEWS';
    }
  }
}

