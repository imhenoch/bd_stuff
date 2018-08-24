#!/bin/bash
# Downloads some unnormalized dictionaries that contains names
curl http://deron.meranda.us/data/census-dist-male-first.txt -o tmp_males
curl http://deron.meranda.us/data/census-dist-female-first.txt -o tmp_females
curl http://deron.meranda.us/data/census-dist-all-last.txt.gz -o tmp_last_names.gz
gzip -d tmp_last_names.gz
