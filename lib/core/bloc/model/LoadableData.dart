class LoadableData<T> {
  LoadableData._(this.data, this.loading);

  factory LoadableData(T data) => LoadableData._(data, false);
  factory LoadableData.loading(T data, [bool loading = true]) => LoadableData._(data, loading);

  bool loading;
  T data;
}
