import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_demo/screens/widgets/asset_thumbnail.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  // This will hold all the assets we fetched
  List<AssetEntity> assets = [];

  DateTime startDate;
  DateTime endDate;

  _fetchAssets() async {
    if (!validDate()) {
      return;
    }
    final albums = await PhotoManager.getAssetPathList(
        onlyAll: true,
        filterOption: FilterOptionGroup(
            createTimeCond: DateTimeCond(min: startDate, max: endDate)));
    final recentAlbum = albums.first;
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0,
      end: 1000000,
    );
    setState(() => assets = recentAssets);
  }

  bool validDate() {
    if (startDate == null || endDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Select dates first')));
      return false;
    } else if (endDate.isBefore(startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('End Date is before start date')));
      return false;
    }
    return true;
  }

  Future<DateTime> _pickDate() async {
    return await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2012, 1, 1),
        lastDate: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                startDate != null
                    ? Flexible(
                        child: Text(
                            '${startDate.day}/${startDate.month}/${startDate.year}'),
                      )
                    : Flexible(child: Text('No date selected')),
                Flexible(
                  flex: 2,
                  child: ElevatedButton(
                      onPressed: () async {
                        startDate = await _pickDate();
                        setState(() {});
                      },
                      child: Text('Start date')),
                ),
                Flexible(
                  flex: 2,
                  child: ElevatedButton(
                      onPressed: () async {
                        endDate = await _pickDate();
                        setState(() {});
                      },
                      child: Text('End date')),
                ),
                endDate != null
                    ? Flexible(
                        child: Text(
                            '${endDate.day}/${endDate.month}/${endDate.year}'))
                    : Flexible(child: Text('No date selected'))
              ],
            ),
          ),
          ElevatedButton(onPressed: _fetchAssets, child: Text('Get Media')),
          assets == null || assets.length == 0
              ? Flexible(flex: 2, child: Text('No image found'))
              : Flexible(
                  flex: 7,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: assets.length,
                    itemBuilder: (_, index) {
                      return AssetThumbnail(asset: assets[index]);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
