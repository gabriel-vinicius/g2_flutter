sealed class Failure {
  final String message;
  const Failure(this.message);
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Erro inesperado']);
}
