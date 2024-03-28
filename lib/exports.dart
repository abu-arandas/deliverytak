// ignore_for_file: depend_on_referenced_packages

/* ====== Package ====== */
export 'dart:async';

export 'package:flutter/material.dart';

export 'firebase_options.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:firebase_storage/firebase_storage.dart';

export 'package:get_storage/get_storage.dart';
export 'package:flutter_bootstrap5/flutter_bootstrap5.dart';
export 'package:get/get.dart';
export 'package:phone_form_field/phone_form_field.dart';
export 'package:font_awesome_flutter/font_awesome_flutter.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:carousel_slider/carousel_slider.dart';
export 'package:image_picker/image_picker.dart';
export 'package:flutter_map/flutter_map.dart';
export 'package:latlong2/latlong.dart' hide Path;
export 'package:geolocator/geolocator.dart';
export 'package:geocoding/geocoding.dart';

/* ====== Config ====== */
export 'config/app.dart';
export 'config/constants.dart';

export 'config/scaffold/client.dart';
export 'config/scaffold/admin.dart';

export 'config/product/client/widget.dart';
export 'config/product/client/favorite.dart';
export 'config/product/client/cart.dart';
export 'config/product/client/page.dart';

/* ====== Controller ====== */
export 'controller/user.dart';
export 'controller/scaffold.dart';
export 'controller/product.dart';
export 'controller/order.dart';
export 'controller/location.dart';

/* ====== Model ====== */
export 'model/user.dart';
export 'model/product.dart';
export 'model/brand.dart';
export 'model/order.dart';

/* ====== View ====== */
export 'view/auth/login.dart';
export 'view/auth/register.dart';
export 'view/auth/reset.dart';
export 'view/auth/profile.dart';
export 'view/auth/password.dart';

export 'view/home.dart';

export 'view/home/admin.dart';
export 'view/home/client.dart';

export 'view/shop/client/most_selling.dart';
export 'view/shop/client/page.dart';

export 'view/order/client/cart.dart';
export 'view/order/client/page.dart';
export 'view/order/client/details.dart';

export 'view/about.dart';
export 'view/contact.dart';
