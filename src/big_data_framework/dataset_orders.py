import argparse
import datetime
import random
from faker import Faker
from .dataset_users import users_generate
from .serialize import serialize

fake = Faker()
fake.seed_instance(0)

PRODUCTS = ["cookie", "muffin", "donut", "coffee", "tea"]

def orders_generate(count_min, count_max, count_users, date_from, output):
    users = users_generate(count_users)
    orders = []

    for user in users:
        nb_orders = random.randint(count_min, count_max)
        for _ in range(nb_orders):
            orders.append({
                "uuid": fake.uuid4(),
                "user_uuid": user["uuid"],
                "date": fake.date_time_between(start_date=date_from, end_date="now").isoformat(),
                "quantity": random.randint(1, 5),
                "product": random.choice(PRODUCTS),
            })

    serialize(orders, output)

def main():
    parser = argparse.ArgumentParser(description="Orders generator")
    parser.add_argument("-u", "--count-users", type=int, default=10, help="Number of users to pick from.")
    parser.add_argument("-C", "--count-min", type=int, default=1, help="Minimum orders per user.")
    parser.add_argument("-c", "--count-max", type=int, default=5, help="Maximum orders per user.")
    parser.add_argument("-f", "--date-from", default="-30d", help="Start date for orders.")
    parser.add_argument("-o", "--output", choices=["csv", "json", "jsonline"], default="json", help="Output format.")
    args = parser.parse_args()

    orders_generate(args.count_min, args.count_max, args.count_users, args.date_from, args.output)

if __name__ == "__main__":
    main()
