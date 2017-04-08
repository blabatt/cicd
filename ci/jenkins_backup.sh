#!/bin/bash

usage(){
    echo "ci-plugins

Usage:
  ci-plugins -l [-a CI_server_IP_address]
  ci-plugins -r [-a CI_server_IP_address] plugins_listing
  ci-plugins -h

Options:
  -a		Indicate IP Address of CI server
  -l		List plugins installed on indicated CI server
  -r		Restore plugins to designated CI server
"
}

while getopts lra:h arg
do 
   case $arg in
      l) LIST_PLUGINS=TRUE ;;
      r) RESTORE_PLUGINS=TRUE ;;
      a) CI_IP=${OPTARG:="127.0.0.1"} ; QUERY_IP=FALSE ;;
      h) usage ; exit 1 ;;
   esac
done


if [ $QUERY_IP -ne "FALSE" ] ; then 
   # TODO: In future, script could parameterize the CI-server's 
   # container name, here assumed to be "cicd_ci_1"
   CI_IP=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' cicd_ci_1)
else

# TODO: parameterize ci-server's username and password with user-prompt
CI_HOST="admin:admin@${CI_IP}:8080" 
   
if [ $LIST_PLUGINS ] ; then
   curl -sSL "http://$CI_HOST/pluginManager/api/xml?depth=1&xpath=/*/*/shortName|/*/*/version&wrapper=plugins" |  perl -pe 's/.*?<shortName>([\w-]+).*?<version>([^<]+)()(<\/\w+>)+/\1 \2\n/g'|sed 's/ /:/'
fi

exit 0 

