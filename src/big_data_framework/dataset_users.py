import argparse
from faker import Faker
from .serialize import serialize

fake = Faker()
fake.seed_instance(0)
# Separate generator: adding birthdate must not change the other fields
fake_birth = Faker()
fake_birth.seed_instance(1)

def users_generate(count):
    users = []
    for _ in range(count):
        users.append({
            "uuid": fake.uuid4(),
            "username": fake.user_name(),
            "name": fake.name(),
            "birthdate": fake_birth.date_of_birth(minimum_age=0, maximum_age=100).isoformat(),
            "address": fake.address().replace("\n", ", "),
            "email": fake.email(),
        })
    return users

def main():
    parser = argparse.ArgumentParser(description="Users generator")
    parser.add_argument("-c", "--count", type=int, default=10, help="Number of users to generate.")
    parser.add_argument("-o", "--output", choices=["csv", "json", "jsonline"], default="json", help="Output format.")
    args = parser.parse_args()

    users = users_generate(args.count)
    serialize(users, args.output)

if __name__ == "__main__":
    main()
