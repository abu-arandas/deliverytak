// ignore_for_file: depend_on_referenced_packages

/* ====== Package ====== */
export 'dart:async';
export 'dart:math' hide pi;

export 'package:flutter/material.dart' hide Hero;
export 'package:flutter/services.dart';

export 'firebase_options.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:cloud_firestore/cloud_firestore.dart' hide Settings;
export 'package:firebase_storage/firebase_storage.dart';

export 'package:flutter_bootstrap5/flutter_bootstrap5.dart';
export 'package:get/get.dart';
export 'package:phone_form_field/phone_form_field.dart';
export 'package:font_awesome_flutter/font_awesome_flutter.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:cached_network_image/cached_network_image.dart';
export 'package:carousel_slider/carousel_slider.dart';
export 'package:image_picker/image_picker.dart';
export 'package:flutter_map/flutter_map.dart';
export 'package:latlong2/latlong.dart' hide Path;
export 'package:geolocator/geolocator.dart';
export 'package:barcode_widget/barcode_widget.dart';
export 'package:intl/intl.dart' hide TextDirection;

/* ====== Config ====== */
export 'config/app.dart';
export 'config/constants.dart';

/* ====== Controller ====== */
export 'controller/firestore.dart';
export 'controller/cart.dart';
export 'controller/sort.dart';
export 'controller/location.dart';

/* ====== Model ====== */
export 'model/user.dart';
export 'model/brand.dart';
export 'model/category.dart';
export 'model/product.dart';
export 'model/order.dart';

/* ====== View ====== */
export 'view/main.dart';
export 'view/about.dart';
export 'view/contact.dart';

export 'view/scaffold/auth.dart';
export 'view/scaffold/client/main.dart';
export 'view/scaffold/client/widgets/appbar.dart';
export 'view/scaffold/client/widgets/drawer.dart';
export 'view/scaffold/client/widgets/body.dart';
export 'view/scaffold/admin/main.dart';
export 'view/scaffold/admin/widgets/appbar.dart';
export 'view/scaffold/admin/widgets/side.dart';
export 'view/scaffold/admin/widgets/search.dart';

export 'view/auth/login.dart';
export 'view/auth/register.dart';
export 'view/auth/reset.dart';
export 'view/auth/profile.dart';
export 'view/auth/password.dart';

export 'view/home/client/main.dart';
export 'view/home/client/widgets/hero.dart';
export 'view/home/client/widgets/brands.dart';
export 'view/home/client/widgets/products.dart';
export 'view/home/client/widgets/special.dart';
export 'view/home/admin/main.dart';
export 'view/home/admin/components/panels.dart';
export 'view/home/admin/components/analitics.dart';
export 'view/home/admin/components/users.dart';
export 'view/home/admin/components/orders.dart';

export 'view/shop/client/main.dart';
export 'view/shop/client/widgets/sort.dart';
export 'view/shop/client/widgets/data.dart';
export 'view/shop/admin/main.dart';
export 'view/shop/admin/categories/widget.dart';
export 'view/shop/admin/categories/add.dart';
export 'view/shop/admin/categories/edit.dart';
export 'view/shop/admin/brands/widget.dart';
export 'view/shop/admin/brands/add.dart';
export 'view/shop/admin/brands/edit.dart';

export 'view/cart/main.dart';
export 'view/cart/widget.dart';

export 'view/product/client/widget.dart';
export 'view/product/client/details.dart';
export 'view/product/admin/widget.dart';
export 'view/product/admin/add.dart';
export 'view/product/admin/edit.dart';

export 'view/orders/main.dart';
export 'view/orders/details.dart';
