import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
