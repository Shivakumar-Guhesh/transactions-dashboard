import 'package:intl/intl.dart';

const currencyLocale = 'en_IN';
const currencySymbol = '₹';

final currencyFormat = NumberFormat.currency(
  locale: currencyLocale,
  symbol: currencySymbol,
  decimalDigits: 2,
);

final compactSimpleCurrencyFormat = NumberFormat.compactCurrency(
  locale: currencyLocale,
  symbol: currencySymbol,
  decimalDigits: 2,
)..minimumFractionDigits = 2;
