function penv
    fish_add_path --global --move $HOME/appslnx/bin/dev
end

function jenv
    fish_add_path --global --move $HOME/appslnx/bin/job
end

set -gx DEV_ENV LOCAL

function lenv
    set -gx DEV_ENV LOCAL
    direnv reload
end

# function denv
#   set -e DEV_ENV
#   direnv reload
# end

function der
    direnv reload
end

function sdenv
    set -e DENV
    set -gx DENV $argv[1]
    direnv reload
end

# https://gist.github.com/nikoheikkila/dd4357a178c8679411566ba2ca280fcc#file-readme-md
function envsource
    for line in (cat $argv | grep -v '^#')
        set item (string split -m 1 '=' $line)
        if test (string match '"*' $item[2])
            set item2 (string sub -s 2 -e -1 $item[2])
            set -gx $item[1] $item2
            #set -ge $item[1]
            # echo "Exported key $item[1] ==== " $item2
        else
            set -gx $item[1] $item[2]
            #set -ge $item[1]
            # echo "Exported key $item[1] ---> " $item[2]
        end
    end
end

function update-dev-env-vars
    #     set endpoint $JSON_VARS_URL
    #     set response (curl -s $endpoint)
    #     for pair in (echo $response | jq -r 'to_entries[] | "\(.key)=\(.value)"')
    #         set key (echo $pair | cut -d= -f1)
    #         set value (echo $pair | cut -d= -f2-)
    #         set -gx $key $value
    #     end

    set hn (hostname)
    #     set hn "lolo.dev"

    if string match -r -q '.dev$' $hn
        set config_file $PORTS_MAPPER_VARS_YAML
        set -l groups (yq '.mappings | keys | .[]' $config_file)

        for group in $groups
            # Get k1 and k2 variable names
            set k1 (yq ".mappings.$group.k1" $config_file)
            set k2s (yq ".mappings.$group.k2[]" $config_file)
            echo "Processing group: $group"
            echo "k1: $k1"
            echo "k2s: $k2s"

            # For each k2, call the endpoint and export the result
            for k2 in $k2s
                set host (eval echo \$$k1)
                set port (eval echo \$$k2)
                set url "$PORTS_MAPPER_BASE_URL/get-port?host=$host&port=$port"
                echo "Fetching port for $k2 from $url"
                set port2 (curl -s $url | jq -r .port)
                echo "Exporting $k2 with port $port2"
                set -gx $k2 $port2
            end

            # use dnsmasq instead
            #             set -gx $k1 10.0.2.2

            echo ""
        end
    else
        echo "host $hn does not end with .dev"
    end

end
