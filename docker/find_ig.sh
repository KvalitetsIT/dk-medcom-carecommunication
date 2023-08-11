#!/bin/sh
for fname in `find ./dependencies -name '*.tgz'`; do
  name=$(basename $fname)
  echo "found dependency: $name"
  mkdir -p /tmp/$name
  tar xzf $fname -C /tmp/$name

  ./load_ig.sh /tmp/$name/package
  echo ""
done

echo "loading ig"
tar -xzf package.tgz -C /tmp
./load_ig.sh /tmp/package
