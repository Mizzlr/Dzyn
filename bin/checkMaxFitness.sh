cat ../logs/dump.txt | grep 'Run' | cut -d' ' -f 5 | q "SELECT max(c1) from -"
