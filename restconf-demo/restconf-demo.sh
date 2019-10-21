#!/usr/bin/env bash

PORT=${1:=8008}

# Beginings - show confd.conf and YANG model

echo -en "\e[33m"
echo -en "\n$ less confd.conf"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
less confd.conf
echo -e "\e[0m"

echo -en "\e[33m"
echo -en "\n$ less dhcp.yang"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
less dhcp.yang
echo -e "\e[0m"

# Step one: discover the root resource

#echo "Discover the root resource, either as xml..."
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -u admin:admin http://localhost:$PORT\e[1m/.well-known/host-meta\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -u admin:admin http://localhost:$PORT/.well-known/host-meta
echo -e "\e[0m"

#echo "or as json..."
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/\e[1mxrd+json\e[22m\" -u admin:admin http://localhost:$PORT\e[1m/.well-known/host-meta\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/xrd+json" -u admin:admin http://localhost:$PORT/.well-known/host-meta
echo -e "\e[0m"



# Retrieve server capability information
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -u admin:admin http://localhost:$PORT\e[1m/restconf/data/ietf-restconf-monitoring:restconf-state/capabilities\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -u admin:admin http://localhost:$PORT/restconf/data/ietf-restconf-monitoring:restconf-state/capabilities
echo -e "\e[0m"



# The restconf resource and the api resource

#echo "In RESTCONF the root resource is restonf"
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application\e[1m/yang-data+xml\e[22m\" -u admin:admin http://localhost:$PORT\e[1m/restconf\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf
echo -e "\e[0m"

echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/\e[1myang-data+json\e[22m\" -u admin:admin http://localhost:$PORT\e[1m/restconf\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/yang-data+json" -u admin:admin http://localhost:$PORT/restconf
echo -e "\e[0m"

#echo "In the legacy REST API the root resource is api"
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/\e[1mvnd.yang.api+xml\e[22m\" -u admin:admin http://localhost:$PORT\e[1m/api\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/vnd.yang.api+xml" -u admin:admin http://localhost:$PORT/api
echo -e "\e[0m"

echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/\e[1mvnd.yang.api+json\e[22m\" -u admin:admin http://localhost:$PORT\e[1m/api\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/vnd.yang.api+json" -u admin:admin http://localhost:$PORT/api
echo -e "\e[0m"




# Media types is different yang-data+(xml|json) in RESTCONF,
# vnd.yang.(api|datastore|data|collection)+(xml|json) in legacy REST

#echo "The media type is always yang-data in RESTCONF, except in one case"
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/\e[1myang-data+xml\e[22m\" -u admin:admin http://localhost:$PORT\e[1m/restconf\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf
echo -e "\e[0m"

echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/\e[1myang-data+xml\e[22m\" -u admin:admin http://localhost:$PORT\e[1m/restconf/data\e[22m?depth=1"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data?depth=1
echo -e "\e[0m"

echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/\e[1myang-data+xml\e[22m\" -u admin:admin http://localhost:$PORT\e[1m/restconf/data/dhcp:dhcp\e[22m?depth=1"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp?depth=1
echo -e "\e[0m"

echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/\e[1myang-data+xml\e[22m\" -u admin:admin http://localhost:$PORT\e[1m/restconf/data/dhcp:dhcp/subnet\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet
echo -e "\e[0m"

# Legacy REST: different media types for different resources

#echo "The media type varies depending on the resource in the legacy REST API"
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/\e[1mvnd.yang.api+xml\e[22m\" -u admin:admin http://localhost:$PORT\e[1m/api\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/vnd.yang.api+xml" -u admin:admin http://localhost:$PORT/api
echo -e "\e[0m"

echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/\e[1mvnd.yang.datastore+xml\e[22m\" -u admin:admin http://localhost:$PORT\e[1m/api/running\e[22m?shallow"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/vnd.yang.datastore+xml" -u admin:admin http://localhost:$PORT/api/running?shallow
echo -e "\e[0m"

echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/\e[1mvnd.yang.data+xml\e[22m\" -u admin:admin http://localhost:$PORT\e[1m/api/running/dhcp\e[22m?shallow"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/vnd.yang.data+xml" -u admin:admin http://localhost:$PORT/api/running/dhcp?shallow
echo -e "\e[0m"

echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/\e[1mvnd.yang.collection+xml\e[22m\" -u admin:admin http://localhost:$PORT\e[1m/api/running/dhcp/subnet\e[22m?shallow"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/vnd.yang.collection+xml" -u admin:admin http://localhost:$PORT/api/running/dhcp/subnet?shallow
echo -e "\e[0m"




# In legacy REST if neither "deep" nor "shallow" is used, a variable
# depth is returned. The output will stop at the first encountered
# presence container or list key value(s)

# RESTCONF depth is by default unbounded and the depth query parameter is used to control listing depth

#echo "RESTCONF show all data in the sub-trees referenced by a resource"
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT\e[1m/restconf/data/dhcp:dhcp\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp
echo -e "\e[0m"

#echo "With REST things are more complicated"
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/\e[1mvnd.yang.data+xml\e[22m\" -u admin:admin http://localhost:$PORT\e[1m/api/running/dhcp\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/vnd.yang.data+xml" -u admin:admin http://localhost:$PORT/api/running/dhcp
echo -e "\e[0m"

echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/\e[1mvnd.yang.data+xml\e[22m\" -u admin:admin http://localhost:$PORT\e[1m/api/running/dhcp?deep\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/vnd.yang.data+xml" -u admin:admin http://localhost:$PORT/api/running/dhcp?deep
echo -e "\e[0m"



# The syntax for specifying depth is diffrent legacy REST use
# deep/shallow query parameters, RESTCONF use depth=1,2, 3, ...,
# unbounded

#echo "depth=n controles sub-tree listing depth with RESTCONF"
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT\e[1m/restconf/data/dhcp:dhcp?depth=1\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp?depth=1
echo -e "\e[0m"

echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT\e[1m/restconf/data/dhcp:dhcp?depth=unbounded\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp?depth=unbounded
echo -e "\e[0m"

#echo "deep/shallow controls sub-tree listing depth with the legacy REST API"
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/\e[1mvnd.yang.data+xml\e[22m\" -u admin:admin http://localhost:$PORT\e[1m/api/running/dhcp?shallow\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/vnd.yang.data+xml" -u admin:admin http://localhost:$PORT/api/running/dhcp?shallow
echo -e "\e[0m"

echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/\e[1mvnd.yang.data+xml\e[22m\" -u admin:admin http://localhost:$PORT\e[1m/api/running/dhcp?deep\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/vnd.yang.data+xml" -u admin:admin http://localhost:$PORT/api/running/dhcp?deep
echo -e "\e[0m"




# List keys are different: =key in RESTCONF /key in legacy REST

#echo "Keys are represented differently in RESTCONF and REST: \"=key\" in RESTCONF, \"/key\" in legacy REST"
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet\e[1m=10.254.239.0%2F27\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet=10.254.239.0%2F27
echo -e "\e[0m"

echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/\e[1mvnd.yang.data+xml\e[22m\" -u admin:admin http://localhost:$PORT/api/running/dhcp/subnet\e[1m/10.254.239.0%2F27\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/vnd.yang.data+xml" -u admin:admin http://localhost:$PORT/api/running/dhcp/subnet/10.254.239.0%2F27?deep
echo -e "\e[0m"




# RESTCONF uses a query parameter to ditinguish between config and
# operational data, legacy rest has the operational datastore

#echo "Use the content query parameter to filter config/operational state data"
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp\e[1m?content=nonconfig\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp?content=nonconfig
echo -e "\e[0m"

echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/\e[1mvnd.yang.data+xml\e[22m\" -u admin:admin http://localhost:$PORT\e[1m/api/operational/dhcp/status\e[22m?deep"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/vnd.yang.data+xml" -u admin:admin http://localhost:$PORT/api/operational/dhcp/status?deep
echo -e "\e[0m"



# Combine query parameters
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp\e[1m?content=nonconfig\&fields=status/leases/address\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp?content=nonconfig\&fields=status/leases/address
echo -e "\e[0m"


# Delete and re-create a resource
# First: make sure it's there
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet
echo -e "\e[0m"

# Create a new resource using the POST method
echo -en "\e[33m"
echo -en "\n$ cat new-subnet.xml"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
cat new-subnet.xml
echo -e "\e[0m"


echo -en "\e[33m"
echo -en "\n$ curl -i -X \e[1m\"POST\"\e[22m -H \"Content-Type: application/yang-data+xml\" -T \e[1mnew-subnet.xml\e[22m -u admin:admin http://localhost:$PORT\e[1m/restconf/data/dhcp:dhcp\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "POST" -H "Content-Type: application/yang-data+xml" -T new-subnet.xml -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp
echo -e "\e[0m"


# Make sure it's there
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/yang-data+xml\" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet
echo -e "\e[0m"

# Hmmm, what happened here?
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/\e[1mvnd.yang.collection+xml\e[22m\" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/vnd.yang.collection+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet
echo -e "\e[0m"

# It works with json, though
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/\e[1myang-data+json\e[22m\" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/yang-data+json" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet
echo -e "\e[0m"



# second: delete it fom the data store
echo -en "\e[33m"
echo -en "\n$ curl -i -X \e[1m\"DELETE\"\e[22m -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet\e[1m=10.254.239.0%2F27\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "DELETE" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet=10.254.239.0%2F27
echo -e "\e[0m"

# Make sure it's gone
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet\e[1m=10.254.239.0%2F27\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet=10.254.239.0%2F27
echo -e "\e[0m"


echo -en "\e[33m"
echo -en "\n$ cat saved-subnet.xml"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
cat saved-subnet.xml
echo -e "\e[0m"



# Create the resource using the POST method
echo -en "\e[33m"
echo -en "\n$ curl -i -X \e[1m\"POST\"\e[22m -H \"Content-Type: application/yang-data+xml\" -T saved-subnet.xml -u admin:admin http://localhost:$PORT\e[1m/restconf/data/dhcp:dhcp\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "POST" -H "Content-Type: application/yang-data+xml" -T saved-subnet.xml -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp
echo -e "\e[0m"

# It's there again
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/yang-data+xml\" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet\e[1m=10.254.239.0%2F27\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet=10.254.239.0%2F27
echo -e "\e[0m"

# Make sure it's gone
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet\e[1m=10.254.251.0%2F27\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet=10.254.251.0%2F27
echo -e "\e[0m"




# Modify an existing resource using PATCH
# Make sure it's there
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/yang-data+xml\" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet=10.254.239.0%2F27\e[1m?fields=max-lease-time\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet=10.254.239.0%2F27?fields=max-lease-time
echo -e "\e[0m"

# Update the resource

echo -en "\e[33m"
echo -en "\n$ cat patch-subnet.xml"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
cat patch-subnet.xml
echo -e "\e[0m"


echo -en "\e[33m"
echo -en "\n$ curl -i -X \"\e[1mPATCH\e[22m\" -H \"Content-Type: application/yang-data+xml\" -T \e[1mpatch-subnet.xml\e[22m -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet\e[1m=10.254.239.0%2F27\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "PATCH" -H "Accept: application/yang-data+xml" -T patch-subnet.xml -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet=10.254.239.0%2F27
echo -e "\e[0m"

# Check the new value
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/yang-data+xml\" -u admin:admin http://localhost:$PORT\e/restconf/data/dhcp:dhcp/subnet=10.254.239.0%2F27?fields=max-lease-time"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet=10.254.239.0%2F27?fields=max-lease-time
echo -e "\e[0m"


# Replace an existing resource using PUT
# Make sure it's there
#echo -en "\e[33m"
#echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/yang-data+xml\" -u admin:admin http://localhost:$PORT/restconf/data/dhcp/subnet=10.254.239.0%2F27?fields=max-lease-time"
#echo -en "\e[0m"
#read -r
#
#echo -e "\e[95m"
#curl -i -X "GET" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp/subnet=10.254.239.0%2F27?fields=max-lease-time
#echo -e "\e[0m"

# Update the resource
echo -en "\e[33m"
echo -en "\n$ curl -i -X \e[1m\"PUT\"\e[22m -H \"Content-Type: application/yang-data+xml\" -T \e[1msaved-subnet.xml\e[22m -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet=10.254.239.0%2F27"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "PUT" -H "Accept: application/yang-data+xml" -T saved-subnet.xml -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet=10.254.239.0%2F27
echo -e "\e[0m"

# Check the new value
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -H \"Accept: application/yang-data+xml\" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet=10.254.239.0%2F27?fields=max-lease-time"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -H "Accept: application/yang-data+xml" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet=10.254.239.0%2F27?fields=max-lease-time
echo -e "\e[0m"


# Rollback management
## look at the value before we apply the last update
#echo -en "\e[33m"
#echo -en "\n$ curl -i -X \"GET\" -u admin:admin http://localhost:$PORT\e[1m/restconf/data/dhcp/subnet=10.254.239.0%2F27?fields=max-lease-time\e[22m"
#echo -en "\e[0m"
#read -r
#
#echo -e "\e[95m"
#curl -i -X "GET" -u admin:admin http://localhost:$PORT/restconf/data/dhcp/subnet=10.254.239.0%2F27?fields=max-lease-time
#echo -e "\e[0m"

# list the rollback files resurce
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -u admin:admin http://localhost:$PORT\e[1m/restconf/data/tailf-rollback:rollback-files\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -u admin:admin http://localhost:$PORT/restconf/data/tailf-rollback:rollback-files
echo -e "\e[0m"

# View the rollback file

echo -en "\e[33m"
echo -en "\n$ cat rollback-0.xml"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
cat rollback-0.xml
echo -e "\e[0m"

echo -en "\e[33m"
echo -en "\n$ curl -i -X \e[1m\"POST\"\e[22m -T \e[1mrollback-0.xml\e[22m -u admin:admin http://localhost:$PORT/restconf/data/tailf-rollback:rollback-files\e[1m/get-rollback-file\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "POST" -T rollback-0.xml -u admin:admin http://localhost:$PORT/restconf/data/tailf-rollback:rollback-files/get-rollback-file
echo -e "\e[0m"

# Apply the rollback
echo -en "\e[33m"
echo -en "\n$ curl -i -X \e[1m\"POST\"\e[22m -T \e[1mrollback-0.xml\e[22m -u admin:admin http://localhost:$PORT/restconf/data/tailf-rollback:rollback-files\e[1m/apply-rollback-file\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "POST" -T rollback-0.xml -u admin:admin http://localhost:$PORT/restconf/data/tailf-rollback:rollback-files/apply-rollback-file
echo -e "\e[0m"

# look at the value again
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -u admin:admin http://localhost:$PORT\e[1m/restconf/data/dhcp:dhcp/subnet=10.254.239.0%2F27?fields=max-lease-time\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/subnet=10.254.239.0%2F27?fields=max-lease-time
echo -e "\e[0m"



# Invoke action
echo -en "\e[33m"
echo -en "\n$ cat action-params.xml"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
cat action-params.xml
echo -e "\e[0m"

echo -en "\e[33m"
echo -en "\n$ curl -i -X \e[1m\"POST\"\e[22m -H \"Content-Type: application/yang-data+xml\" -T \e[1maction-params.xml\e[22m -u admin:admin http://localhost:$PORT\e[1m/restconf/data/dhcp:dhcp/set-clock\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "POST" -H "Content-Type: application/yang-data+xml" -T action-params.xml -u admin:admin http://localhost:$PORT/restconf/data/dhcp:dhcp/set-clock
echo -e "\e[0m"





# Server metadata - schema

# Retrieve The Server Module Information
# FIrst: list all modules
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -u admin:admin http://localhost:$PORT/restconf/data/\e[1mietf-yang-library:modules-state\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -u admin:admin http://localhost:$PORT/restconf/data/ietf-yang-library:modules-state
echo -e "\e[0m"

# Second: list the URL used to retrive a particular module. Note two keys to identify the module
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -u admin:admin http://localhost:$PORT/restconf/data/\e[1mietf-yang-library:modules-state/module=ietf-restconf,2017-01-26\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -u admin:admin http://localhost:$PORT/restconf/data/ietf-yang-library:modules-state/module=ietf-restconf,2017-01-26
echo -e "\e[0m"

# Third: retrive the schema for the desired module
echo -en "\e[33m"
echo -en "\n$ curl -i -X \"GET\" -u admin:admin \e[1mhttp://localhost:$PORT/restconf/tailf/modules/ietf-restconf/2017-01-26\e[22m"
echo -en "\e[0m"
read -r

echo -e "\e[95m"
curl -i -X "GET" -u admin:admin http://localhost:$PORT/restconf/tailf/modules/ietf-restconf/2017-01-26
echo -e "\e[0m"

echo
echo -en "\e[33m"
echo -en "Thank you!"
echo -en "\e[0m"
read -r
