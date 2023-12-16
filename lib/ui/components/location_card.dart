import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  final String sportsCenterName;
  final String sportsCenterAddress;
  final String regionName;
  final String districtName;
  final bool isBookmarked;
  final VoidCallback? onBookmarkPressed;

  const LocationCard({
    super.key,
    required this.sportsCenterName,
    required this.sportsCenterAddress,
    required this.regionName,
    required this.districtName,
    required this.isBookmarked,
    this.onBookmarkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {},
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 16, right: 4),
          titleTextStyle: Theme.of(context).textTheme.titleMedium,
          title: Text(sportsCenterName),
          subtitleTextStyle: Theme.of(context).textTheme.bodySmall,
          subtitle: Column(
            children: [
              _buildAddressRow(),
              const SizedBox(height: 4),
              _buildBottomRow(),
            ],
          ),
          trailing: IconButton(
            isSelected: isBookmarked,
            selectedIcon: const Icon(Icons.bookmark),
            icon: const Icon(Icons.bookmark_border),
            onPressed: onBookmarkPressed,
          ),
        ),
      ),
    );
  }

  Widget _buildAddressRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.map, size: 16),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            sportsCenterAddress,
            overflow: TextOverflow.fade,
            maxLines: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.location_pin, size: 16),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            '$districtName, $regionName',
            overflow: TextOverflow.fade,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
