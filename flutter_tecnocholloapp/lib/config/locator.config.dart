// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_tecnocholloapp/repositories/authentication_repository.dart'
    as _i4;
import 'package:flutter_tecnocholloapp/repositories/category_repository.dart'
    as _i5;
import 'package:flutter_tecnocholloapp/repositories/product_repository.dart'
    as _i6;
import 'package:flutter_tecnocholloapp/repositories/user_repository.dart'
    as _i7;
import 'package:flutter_tecnocholloapp/rest/rest_client.dart' as _i3;
import 'package:flutter_tecnocholloapp/services/authentication_service.dart'
    as _i9;
import 'package:flutter_tecnocholloapp/services/category_service.dart'
    as _i8;
import 'package:flutter_tecnocholloapp/services/product_service.dart'
    as _i10;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart'
    as _i2; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.RestAuthenticatedClient>(_i3.RestAuthenticatedClient());
    gh.singleton<_i3.RestClient>(_i3.RestClient());
    gh.singleton<_i4.AuthenticationRepository>(_i4.AuthenticationRepository());
    gh.singleton<_i5.CategoryRepository>(_i5.CategoryRepository());
    gh.singleton<_i6.ProductRepository>(_i6.ProductRepository());
    gh.singleton<_i7.UserRepository>(_i7.UserRepository());
    gh.singleton<_i8.CategoryService>(_i8.CategoryService());
    gh.singleton<_i9.JwtAuthenticationService>(_i9.JwtAuthenticationService());
    gh.singleton<_i10.ProductService>(_i10.ProductService());
    return this;
  }
}
