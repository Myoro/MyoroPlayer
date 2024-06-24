/// Standard BloC enum for making async requests
enum BlocStatusEnum {
  /// BloC is idle
  idle,

  /// BloC is executing the async request
  loading,

  /// BloC has successfully completed the async request
  completed,

  /// BloC has encountered an error making the async request
  error,
}
