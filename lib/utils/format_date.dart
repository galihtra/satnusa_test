String formatDate(String dateStr) {
  final date = DateTime.parse(dateStr);
  const monthNames = [
    '', // Dummy for index 0
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final day = date.day;
  final month = monthNames[date.month];
  final year = date.year;

  return '$day $month $year';
}
