#!/bin/bash

line=$1
repo_owner=$2
PAT_FOR_XYGENI_SCAN=$3
loops=$4
event_type=$5

                
                
                REPO_URL=$line
                # extract the protocol
                proto="$(echo $REPO_URL | grep :// | sed -e's,^\(.*://\).*,\1,g')"
                echo proto : $proto
                # remove the protocol
                url="$(echo ${REPO_URL/$proto/})"
                echo url : $url
                # extract the user (if any)
                user="$(echo $url | grep @ | cut -d@ -f1)"
                echo user : $user
                # extract the host and port
                hostport="$(echo ${url/$user@/} | cut -d/ -f1)"
                echo hostport : $hostport
                # by request host without port
                host="$(echo $hostport | sed -e 's,:.*,,g')"
                echo host : $host
                # by request - try to extract the port
                port="$(echo $hostport | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"
                echo port : $port
                # extract the path (if any)
                path="$(echo $url | grep / | cut -d/ -f2-)"
                echo path : $path
                org="$(echo $path | grep / | cut -d/ -f1)"
                echo org : $org
                repo="$(echo $path | grep / | cut -d/ -f2-)"
                echo repo : $repo


                repo_owner="LGVExternalRepos" 
                loops="${{ github.event.inputs.loops }}"
                event_type="${{ github.event.inputs.action }}"
          
                    curl -L \
                    -X POST \
                    -H "Accept: application/vnd.github+json" \
                    -H "Authorization: Bearer ${PAT_FOR_XYGENI_SCAN}" \
                    -H "X-GitHub-Api-Version: 2022-11-28" \
                    https://api.github.com/repos/$repo_owner/$repo/dispatches \
                    -d "{\"event_type\": \"$event_type\", \"client_payload\": {\"loops\": \"$loops\" }}"