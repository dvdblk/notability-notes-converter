#!/usr/bin/env python3

import argparse
from datetime import datetime, timedelta

def arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument("datestring")
    return parser.parse_args()

def create_expected_datestring(datestr):
    time_format = "%H:%M"
    date_format = "%d %b %Y"
    datetime_format = "{} {}".format(date_format, time_format)
    today = datetime.today()
    yesterday = today - timedelta(days=1)
    date_to_day_nr = lambda d: d.strftime(date_format)
    clean_datestr = datestr.replace(
        "at", ""
    ).replace(
        "Today", date_to_day_nr(today)
    ).replace(
        "Yesterday", date_to_day_nr(yesterday)
    )

    correct_datetime = datetime.strptime(clean_datestr, datetime_format)
    return correct_datetime.strftime("%A, %d %B %Y at %H:%M:%S")

if __name__ == "__main__":
    args = arguments()
    print(create_expected_datestring(args.datestring))
