#!/bin/ash

jq -c '.dependencies | to_entries[]' $1/package.json | while read row; do
    package=$(echo $row | jq -r '.key')
    version=$(echo $row | jq -r '.value')

    mkdir -p dependencies

   
    if echo $package | grep -q "hl7.fhir.dk"; then
      echo fetching dependency $package@$version
      curl -Ls https://packages.simplifier.net/$package/$version --output ./dependencies/$package-$version.tgz
    elif echo $package | grep -q "medcom"; then
      echo fetching dependency $package@$version
      if [ $version == "current" ]; then
        if echo $package | grep -q "core"; then
          curl -Ls http://build.fhir.org/ig/medcomdk/dk-medcom-core/package.tgz --output ./dependencies/$package-$version.tgz
        elif echo $package | grep -q "messaging"; then
          curl -Ls http://build.fhir.org/ig/medcomdk/dk-medcom-messaging/package.tgz --output ./dependencies/$package-$version.tgz
        elif echo $package | grep -q "terminology"; then
          curl -Ls http://build.fhir.org/ig/medcomdk/dk-medcom-terminology/package.tgz --output ./dependencies/$package-$version.tgz
        fi
      else
        echo "not able to download versioned package yet" 
#        curl -Ls http://medcomfhir.dk/ig//$version/package.tgz --output ./downloads/$package-$version.tgz
      fi
 
    fi
done

