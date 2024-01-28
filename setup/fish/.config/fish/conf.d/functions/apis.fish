
function servapi
  redocly --port=10091 --host=0.0.0.0 preview-docs $argv[1] > /dev/null &
  chrome http://0.0.0.0:10091
end

# function kservapi
#     lsof -wni "tcp:10091" | rg listen | hck -f2 | sudo xargs kill -9
# end

function wmock
  java -cp /media/a/data/docs-files/Web/Testing/proxies/wiremock/wiremock/wiremock-jre8-standalone-2.35.0.jar:/media/a/data/docs-files/Web/Testing/proxies/wiremock/wiremock/wiremock-webhooks-extension-2.35.0.jar \
    com.github.tomakehurst.wiremock.standalone.WireMockServerRunner \
    --extensions org.wiremock.webhooks.Webhooks --port $argv[1] --root-dir $argv[2]
end
