const sum_sub = require('./sum_sub');

test('1 + 2 to equal 3', () => {
  expect(sum_sub.sum(1, 2)).toBe(3);
});

test('1 - 2 to equal -1', () => {
  expect(sum_sub.sub(1, 2)).toBe(-1);
});
