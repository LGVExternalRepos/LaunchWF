#!/bin/bash

repo=$1
FILE_TO_COPY=$2
PAT_FOR_XYGENI_SCAN=$3
TEST_S=$4


SHA_FILE_SCAN=$(curl https://api.github.com/repos/LGVExternalRepos/$repo/contents/.github/workflows/${FILE_TO_COPY}${TEST_S} | jq -r '.sha')


               if [ "$SHA_FILE_SCAN" == "null" ]; then
                    echo "NO EXISTE "
                    menosd="'{\"message\":\"my commit message\",\"committer\":{\"name\":\"LGV\",\"email\":\"luis.garcia@xygeni.io\"},\"content\":\"$BB64_FILE_SCAN\"}'"
                    #echo $menosd > temp.json
                    #cat temp.json

                    filename=${FILE_TO_COPY}
                    base64=$(base64 "${filename}" --wrap 0)
                    destination=temp.json

                    # Generating a JSON string (https://stackoverflow.com/a/48470227)
                    json_string=$(
                      jq --null-input \
                        --arg message "my msg" \
                        --arg name "LGV" \
                        --arg email "luis.garcia@xygeni.io" \
                        --arg base64 "${base64}" \
                        '{message: $message, commiter: {name: $name, email: $email }, content: $base64 }'
                    )

                    # Creating the JSON file
                    echo $json_string > "${destination}"

                    curl -L \
                      -X PUT \
                      -H "Accept: application/vnd.github+json" \
                      -H "Authorization: Bearer ${PAT_FOR_XYGENI_SCAN}" \
                      -H "X-GitHub-Api-Version: 2022-11-28" \
                      https://api.github.com/repos/LGVExternalRepos/$repo/contents/.github/workflows/${FILE_TO_COPY}${TEST_S}  \
                        -d @temp.json
                      
                      #  -d '{"message":"my commit message","committer":{"name":"LGV","email":"luis.garcia@xygeni.io"},"content":"$BB64_FILE_SCAN"}'

                else
                    echo "EXISTE $SHA_FILE_SCAN"

                    filename=${FILE_TO_COPY}
                    base64=$(base64 "${filename}" --wrap 0)
                    sha=$(curl https://api.github.com/repos/LGVExternalRepos/$repo/contents/.github/workflows/${FILE_TO_COPY}${TEST_S} | jq -r '.sha')
                    destination=temp.json

                    # Generating a JSON string (https://stackoverflow.com/a/48470227)
                    json_string=$(
                      jq --null-input \
                        --arg message "my msg" \
                        --arg name "LGV" \
                        --arg email "luis.garcia@xygeni.io" \
                        --arg base64 "${base64}" \
                        --arg sha "${sha}" \
                        '{message: $message, commiter: {name: $name, email: $email }, content: $base64, sha: $sha }'
                    )

                    # Creating the JSON file
                    echo $json_string > "${destination}"


                    curl -L \
                      -X PUT \
                      -H "Accept: application/vnd.github+json" \
                      -H "Authorization: Bearer ${PAT_FOR_XYGENI_SCAN}" \
                      -H "X-GitHub-Api-Version: 2022-11-28" \
                      https://api.github.com/repos/LGVExternalRepos/$repo/contents/.github/workflows/${FILE_TO_COPY}${TEST_S}  \
                        -d @temp.json
                      #-d '{"message":"my commit message","committer":{"name":"LGV","email":"luis.garcia@xygeni.io"},"content":"$BB64_FILE_SCAN","sha":"$SHA_FILE_SCAN"}'
                fi