import 'package:flutter/material.dart';
import 'package:store/models/item.dart';

class ItemsProvider with ChangeNotifier {
  List<Item> _storeItems = [
    Item(
        id: 'item_01',
        name: 'Nike React Miler',
        price: 149,
        category: 'Men',
        isFavorite: false,
        images: [
          'https://i.ibb.co/kgVrWRF/shoes11.png',
          'https://i.ibb.co/mBLHXvP/shoes12.png',
          'https://i.ibb.co/G24x96Z/shoes13.png'
        ],
        sizes: [
          '40',
          '41',
          '42',
          '43',
          '44',
          '45'
        ]),
    Item(
        id: 'item_02',
        name: 'Nike Air Jordan 1 Low',
        price: 179,
        category: 'Jordan',
        isFavorite: false,
        images: [
          'https://i.ibb.co/99sxj15/shoes31.png',
          'https://i.ibb.co/ZSkzb6H/shoes32.png',
          'https://i.ibb.co/hmBtPyf/shoes33.png'
        ],
        sizes: [
          '40',
          '41',
          '42',
          '43',
          '44',
          '45'
        ]),
    Item(
        id: 'item_03',
        name: 'Nike Epic React Flyknit 2',
        price: 149,
        category: 'Women',
        isFavorite: false,
        images: [
          'https://i.ibb.co/4dq1fLq/shoes41.png',
          'https://i.ibb.co/b3HmycQ/shoes42.png',
          'https://i.ibb.co/j5SGcQD/shoes43.png'
        ],
        sizes: [
          '37',
          '38',
          '39',
          '40',
          '41',
          '42',
          '43',
          '44'
        ]),
    Item(
        id: 'item_04',
        name: 'Nike Vaporfly 4% Flyknit',
        price: 129,
        category: 'Men',
        isFavorite: false,
        images: [
          'https://i.ibb.co/sHFwck5/Shoes21.png',
          'https://i.ibb.co/qsw08Zt/shoes22.png',
          'https://i.ibb.co/JsyYQvz/shoes23.png'
        ],
        sizes: [
          '40',
          '41',
          '42',
          '44',
          '45',
          '47'
        ]),
  ];

  List<Item> get storeItems {
    return [..._storeItems];
  }

  List<Item> get favoriteItems {
    return _storeItems.where((item) => item.isFavorite).toList();
  }

  List<Item> get menItems {
    return _storeItems
        .where((item) => item.category == 'Men' || item.category == 'Jordan')
        .toList();
  }

  List<Item> get womenItems {
    return _storeItems.where((item) => item.category == 'Women').toList();
  }

  Item findById(String id) {
    return _storeItems.firstWhere((item) => item.id == id);
  }
}
