#!/bin/bash
# Downloads some unnormalized dictionaries that contains the data
echo 'Downloading names'
curl --silent http://deron.meranda.us/data/census-dist-male-first.txt -o tmp_males
curl --silent http://deron.meranda.us/data/census-dist-female-first.txt -o tmp_females
curl --silent http://deron.meranda.us/data/census-dist-all-last.txt.gz -o tmp_last_names.gz
gzip -d tmp_last_names.gz

echo 'Downloading companies'
curl --silent http://www.opendata500.com/us/download/us_companies.csv -o tmp_companies

echo 'Downloading products'
curl --silent  https://community.watsonanalytics.com/wp-content/uploads/2015/08/WA_Sales_Products_2012-14.csv -o tmp_products

echo 'Dowloading stores'
curl --silent https://data.baltimorecity.gov/api/views/uuwk-975y/rows.csv -o tmp_stores

echo 'Downloading cities'
curl --silent https://pkgstore.datahub.io/core/world-cities/world-cities_csv/data/6cc66692f0e82b18216a48443b6b95da/world-cities_csv.csv -o tmp_cities

echo 'Normalizing data'
python3 normalize_data.py
rm tmp*

echo 'Done!'
