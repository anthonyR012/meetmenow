

void throwIfError(bool condition, Failure failure) {
  if (condition) {
    throw failure;
  }
}


class Failure implements Exception {
  final String message;
  Failure(this.message);
}

class FailureManage {
 
  FailureManage();
  Failure get connectivity => ConnectivityFailure("Sin conexión a internet");
  Failure get emptyField => EmptyFailure("Campo sin valor");
  Failure get wentWrong => WentWrongFailure("Algo salió mal");
  Failure server(String message) => ServerFailure(message);
  Failure client(String message) => ClientFailure(message);

  Failure noFound(String message) =>
      NoFoundFailure("No se encontraron resultados de $message");
  Failure missingArgument(String argument) =>
      MissingArgumentFailure("Argumento '$argument' es requerido");
  Failure insufficientParameters(String permission) =>
      InsufficientParametersFailure(
          "Permiso '$permission' es necesario para acceder a esta funcionalidad");
}

class UnknownFailure extends Failure {
  UnknownFailure(super.message);
}

class ConnectivityFailure extends Failure {
  ConnectivityFailure(super.message);
}

class EmptyFailure extends Failure {
  EmptyFailure(super.message);
}

class WentWrongFailure extends Failure {
  WentWrongFailure(super.message);
}

class MissingArgumentFailure extends Failure {
  MissingArgumentFailure(super.message);
}

class InsufficientParametersFailure extends Failure {
  InsufficientParametersFailure(super.message);
}

class NoFoundFailure extends Failure {
  NoFoundFailure(super.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class ClientFailure extends Failure {
  ClientFailure(super.message);
}

class WidgetsFailure extends Failure {
  WidgetsFailure(super.message);
}
