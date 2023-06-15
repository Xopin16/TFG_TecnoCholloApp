// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_tecnocholloapp/repositories/authentication_repository.dart'
    as _i4;
import 'package:flutter_tecnocholloapp/repositories/carrito_repository.dart'
    as _i5;
import 'package:flutter_tecnocholloapp/repositories/category_repository.dart'
    as _i6;
import 'package:flutter_tecnocholloapp/repositories/product_repository.dart'
    as _i7;
import 'package:flutter_tecnocholloapp/repositories/user_repository.dart'
    as _i8;
import 'package:flutter_tecnocholloapp/repositories/venta_repository.dart'
    as _i9;
import 'package:flutter_tecnocholloapp/rest/rest_client.dart' as _i3;
import 'package:flutter_tecnocholloapp/services/authentication_service.dart'
    as _i12;
import 'package:flutter_tecnocholloapp/services/carrito_service.dart' as _i10;
import 'package:flutter_tecnocholloapp/services/category_service.dart' as _i11;
import 'package:flutter_tecnocholloapp/services/product_service.dart' as _i13;
import 'package:flutter_tecnocholloapp/services/venta_service.dart' as _i14;
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
    gh.singleton<_i5.CarritoRepository>(_i5.CarritoRepository());
    gh.singleton<_i6.CategoryRepository>(_i6.CategoryRepository());
    gh.singleton<_i7.ProductRepository>(_i7.ProductRepository());
    gh.singleton<_i8.UserRepository>(_i8.UserRepository());
    gh.singleton<_i9.VentaRepository>(_i9.VentaRepository());
    gh.singleton<_i10.CarritoService>(_i10.CarritoService());
    gh.singleton<_i11.CategoryService>(_i11.CategoryService());
    gh.singleton<_i12.JwtAuthenticationService>(
        _i12.JwtAuthenticationService());
    gh.singleton<_i13.ProductService>(_i13.ProductService());
    gh.singleton<_i14.VentaService>(_i14.VentaService());
    return this;
  }
}
