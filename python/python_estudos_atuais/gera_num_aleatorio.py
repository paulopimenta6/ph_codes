import random

for x in range(10):
    print(f"{random.random():.2f}")

print("#########################################")

for x in range(10):
    print(f"{random.uniform(14, 25):.2f}")

print("#########################################")

print(random.sample(range(1, 101), 6))

print("#########################################")

a = list(range(1, 11))
print(a)
random.shuffle(a)
print(a)