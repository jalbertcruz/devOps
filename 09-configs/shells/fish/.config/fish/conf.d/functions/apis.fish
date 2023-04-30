function servapi
    redocly --port=10091 --host=0.0.0.0 preview-docs $argv[1] >/dev/null &
    chrome http://0.0.0.0:10091
end

# function kservapi
#     lsof -wni "tcp:10091" | rg listen | hck -f2 | sudo xargs kill -9
# end

function wmockgrpc
    mkdir -p $argv[2]/grpc
    java -cp $WM_LIB_DIR/wiremock-grpc-extension-standalone-0.9.0.jar \
        wiremock.Run \
        --port $argv[1] --root-dir $argv[2]
end

function wmock
    java -jar $WIREMOCK_STANDALONE_JAR_PATH \
        --port $argv[1] \
        --record-mappings
end
