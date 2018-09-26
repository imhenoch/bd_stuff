#!/bin/bash
# Downloads some unnormalized dictionaries that contains the data
echo 'Downloading names'
curl --silent http://deron.meranda.us/data/census-dist-male-first.txt -o tmp_males
curl --silent http://deron.meranda.us/data/census-dist-female-first.txt -o tmp_females
curl --silent http://deron.meranda.us/data/census-dist-all-last.txt.gz -o tmp_last_names.gz
gzip -d tmp_last_names.gz

echo 'Downloading companies'
curl --silent http://www.opendata500.com/us/download/us_companies.csv -o tmp_companies

echo 'Normalizing data'
python3 normalize_data.py
rm tmp*

echo 'Done!'
