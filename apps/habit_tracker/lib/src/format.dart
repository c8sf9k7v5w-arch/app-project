const _weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];
const _months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

String longDate(DateTime d) =>
    '${_weekdays[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]}'
        .toUpperCase();

String weekdayLetter(DateTime d) => _weekdays[d.weekday - 1][0];

String weekdayShort(DateTime d) => _weekdays[d.weekday - 1].substring(0, 3);

String greeting(DateTime now) => switch (now.hour) {
  < 12 => 'Good morning',
  < 18 => 'Good afternoon',
  _ => 'Good evening',
};
