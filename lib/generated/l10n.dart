// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `A New Experience`
  String get anew_experience {
    return Intl.message(
      'A New Experience',
      name: 'anew_experience',
      desc: '',
      args: [],
    );
  }

  /// `'Enjoy an extensive selection of movies, series and live TV on any device,\nwith a viewing experience designed for comfort and control.`
  String get enjoy {
    return Intl.message(
      '\'Enjoy an extensive selection of movies, series and live TV on any device,\nwith a viewing experience designed for comfort and control.',
      name: 'enjoy',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for choosing our app — enjoy your time!`
  String get thanks {
    return Intl.message(
      'Thank you for choosing our app — enjoy your time!',
      name: 'thanks',
      desc: '',
      args: [],
    );
  }

  /// `Continue Using the App`
  String get Continue_Using_the_App {
    return Intl.message(
      'Continue Using the App',
      name: 'Continue_Using_the_App',
      desc: '',
      args: [],
    );
  }

  /// `User Name`
  String get username {
    return Intl.message('User Name', name: 'username', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Continue`
  String get continueBtm {
    return Intl.message('Continue', name: 'continueBtm', desc: '', args: []);
  }

  /// ` is required`
  String get is_required {
    return Intl.message(
      ' is required',
      name: 'is_required',
      desc: '',
      args: [],
    );
  }

  /// `Password at least 8 characters`
  String get at_least {
    return Intl.message(
      'Password at least 8 characters',
      name: 'at_least',
      desc: '',
      args: [],
    );
  }

  /// `No episodes available`
  String get no_episode {
    return Intl.message(
      'No episodes available',
      name: 'no_episode',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Search...`
  String get search {
    return Intl.message('Search...', name: 'search', desc: '', args: []);
  }

  /// `No series available`
  String get no_series {
    return Intl.message(
      'No series available',
      name: 'no_series',
      desc: '',
      args: [],
    );
  }

  /// `Playlist Selection`
  String get playlist_selection {
    return Intl.message(
      'Playlist Selection',
      name: 'playlist_selection',
      desc: '',
      args: [],
    );
  }

  /// `No Active Playlists`
  String get no_active_playlists {
    return Intl.message(
      'No Active Playlists',
      name: 'no_active_playlists',
      desc: '',
      args: [],
    );
  }

  /// `No Movies Available`
  String get no_movies {
    return Intl.message(
      'No Movies Available',
      name: 'no_movies',
      desc: '',
      args: [],
    );
  }

  /// `Live TV`
  String get live_tv {
    return Intl.message('Live TV', name: 'live_tv', desc: '', args: []);
  }

  /// `Movies`
  String get Movies {
    return Intl.message('Movies', name: 'Movies', desc: '', args: []);
  }

  /// `Series`
  String get Series {
    return Intl.message('Series', name: 'Series', desc: '', args: []);
  }

  /// `Live Channels`
  String get Live_Channels {
    return Intl.message(
      'Live Channels',
      name: 'Live_Channels',
      desc: '',
      args: [],
    );
  }

  /// `No categories`
  String get No_categories {
    return Intl.message(
      'No categories',
      name: 'No_categories',
      desc: '',
      args: [],
    );
  }

  /// `No channels`
  String get No_channels {
    return Intl.message('No channels', name: 'No_channels', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Personal information`
  String get Personal_information {
    return Intl.message(
      'Personal information',
      name: 'Personal_information',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get change_password {
    return Intl.message(
      'Change Password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get user {
    return Intl.message('User', name: 'user', desc: '', args: []);
  }

  /// `Mac Address`
  String get mac_address {
    return Intl.message('Mac Address', name: 'mac_address', desc: '', args: []);
  }

  /// `Old Password`
  String get old_password {
    return Intl.message(
      'Old Password',
      name: 'old_password',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get new_password {
    return Intl.message(
      'New Password',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `Favorite`
  String get favorite {
    return Intl.message('Favorite', name: 'favorite', desc: '', args: []);
  }

  /// `All`
  String get All {
    return Intl.message('All', name: 'All', desc: '', args: []);
  }

  /// `No Favorites`
  String get no_favorites {
    return Intl.message(
      'No Favorites',
      name: 'no_favorites',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `Clear History`
  String get clear_history {
    return Intl.message(
      'Clear History',
      name: 'clear_history',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to clear all watch history?`
  String get confirm_clear_history {
    return Intl.message(
      'Are you sure you want to clear all watch history?',
      name: 'confirm_clear_history',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Clear`
  String get clear {
    return Intl.message('Clear', name: 'clear', desc: '', args: []);
  }

  /// `No Watch History`
  String get no_history {
    return Intl.message(
      'No Watch History',
      name: 'no_history',
      desc: '',
      args: [],
    );
  }

  /// `Be Ready , Press Start To Play The Video`
  String get be_ready {
    return Intl.message(
      'Be Ready , Press Start To Play The Video',
      name: 'be_ready',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message('Start', name: 'start', desc: '', args: []);
  }

  /// `Return Back`
  String get return_back {
    return Intl.message('Return Back', name: 'return_back', desc: '', args: []);
  }

  /// `Remember Me`
  String get remember_me {
    return Intl.message('Remember Me', name: 'remember_me', desc: '', args: []);
  }

  /// `Just Now`
  String get just_now {
    return Intl.message('Just Now', name: 'just_now', desc: '', args: []);
  }

  /// `m`
  String get m {
    return Intl.message('m', name: 'm', desc: '', args: []);
  }

  /// `h`
  String get h {
    return Intl.message('h', name: 'h', desc: '', args: []);
  }

  /// `d`
  String get d {
    return Intl.message('d', name: 'd', desc: '', args: []);
  }

  /// `ago`
  String get ago {
    return Intl.message('ago', name: 'ago', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
