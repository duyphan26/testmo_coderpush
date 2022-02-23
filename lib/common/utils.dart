T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  if (value != null) {
    final valueS = value.toString();
    if (0 is T) {
      return int.tryParse(valueS) as T?;
    } else if (0.0 is T) {
      return double.tryParse(valueS) as T?;
    } else if ('' is T) {
      return valueS as T;
    } else if (false is T) {
      if (valueS == '0' || valueS == '1') {
        return (valueS == '1') as T;
      }
      return (valueS == 'true') as T;
    }
  }
  return null;
}