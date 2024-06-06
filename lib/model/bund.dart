import 'package:elbe/elbe.dart';

class Bund<T> {
  final T first;
  final T second;
  final T third;
  final T fourth;
  final T fifth;
  final T sixth;

  Bund.fromList(List<T> list)
      : this(list[0], list[1], list[2], list[3], list[4], list[5]);

  const Bund(
      this.first, this.second, this.third, this.fourth, this.fifth, this.sixth);

  List<T> get elements => [first, second, third, fourth, fifth, sixth];

  Bund<R> map<R>(R Function(int i, T e) onElement) =>
      Bund.fromList(elements.mapIndexed(onElement).toList());

  T get(int index) => elements[index];
}
