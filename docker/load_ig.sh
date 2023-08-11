#!/bin/sh
for fname in `find $1 -maxdepth 1 -name '*.json*' ! -iname '.index.json' ! -iname 'package.json' ! -iname 'implementationguid*.json'`; do

if jq -e 'select(.resourceType | IN("NamingSystem", "CodeSystem", "ValueSet", "StructureDefinition", "ConceptMap", "SearchParameter", "Subscription") )' $fname > /dev/null; then
  type=$(jq -r '.resourceType' $fname)
  id=$(jq -r '.id' $fname)

  until [ \
  "$(curl -s -w '%{http_code}' -o /dev/null "$FHIR_SERVER_BASE/metadata")" \
  -eq 200 ]
do
  echo "not ready, sleep 5 sec"
  sleep 5
done

  curl -s -w "%{http_code} %header{content-location}\n" -o /dev/null -X 'PUT' \
    $FHIR_SERVER_BASE'/'$type'/'$id \
    -H 'accept: application/fhir+json' \
    -H 'Content-Type: application/fhir+json' \
    -d @$fname
fi
done
