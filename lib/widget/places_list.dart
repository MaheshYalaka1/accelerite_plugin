import 'package:accelerite_plugin/modal/newplace.dart';
import 'package:accelerite_plugin/provider/user_place.dart';
import 'package:accelerite_plugin/screens/place_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesList extends ConsumerStatefulWidget {
  const PlacesList({Key? key, required this.places}) : super(key: key);
  final List<Place> places;

  @override
  ConsumerState<PlacesList> createState() {
    return _PlaceListState();
  }
}

class _PlaceListState extends ConsumerState<PlacesList> {
  @override
  Widget build(BuildContext context) {
    if (widget.places.isEmpty) {
      return Center(
        child: Text(
          'No places added yet',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.black),
        ),
      );
    }

    return ListView.builder(
      itemCount: widget.places.length,
      itemBuilder: (ctx, index) {
        final place = widget.places[index];
        return Dismissible(
          key: Key(place.id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20.0),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          onDismissed: (direction) {
            ref.read(userplaceprovider.notifier).deletePlace(place.id);
            setState(() {
              widget.places.removeAt(index);
            });
            print('Item dismissed: ${place.title}');
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: FileImage(place.image),
            ),
            title: Text(
              place.title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.black),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => placeDetailsScreen(place: place),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
