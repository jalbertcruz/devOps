# test -e .cs-java && set jsJava (cat .cs-java) && eval "$(cs java --jvm $jsJava --env)"
if not test -e .cs-java
#     test -d ~/appslnx/jdk-11 && set -x JAVA_HOME ~/appslnx/jdk-11
#     test -d ~/appslnx/jdk-17 && set -x JAVA_HOME ~/appslnx/jdk-17
    test -d ~/appslnx/jdk-21 && set -xg JAVA_HOME ~/appslnx/jdk-21 # && echo "Using default JDK 21"
else
    set jsJava (cat .cs-java)
    echo Setting JDK version to $jsJava
    eval "$(cs java --jvm $jsJava --env)"
end

# set -x PATH $HOME/appslnx/build-tools/maven/bin

fish_add_path --global "$JAVA_HOME/bin"
fish_add_path --global $HOME/appslnx/build-tools/maven/bin
# set -x PATH $HOME/appslnx/jdk-11/bin/ $HOME/appslnx/build-tools/maven/bin/

set -x LEIN_JVM_OPTS "-Dmaven.wagon.rto=1800000"

set -x GROOVY_HOME ~/appslnx/groovy

set -x SBT_OPTS "-Xms1512M -Xmx3024M -Xss200M -XX:MaxMetaspaceSize=2024M"

# set -x JAVA_OPTS "--add-opens java.base/java.util.concurrent=ALL-UNNAMED --add-opens java.base/java.util=ALL-UNNAMED --add-opens java.base/java.lang=ALL-UNNAMED"
# set -x JAVA_OPTS " --add-opens jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED" $JAVA_OPTS
# set -x JAVA_OPTS " --add-opens jdk.compiler/com.sun.tools.javac.comp=ALL-UNNAMED" $JAVA_OPTS
# set -x JAVA_OPTS " --add-opens jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED" $JAVA_OPTS
# set -x JAVA_OPTS " --add-opens jdk.compiler/com.sun.tools.javac.main=ALL-UNNAMED" $JAVA_OPTS
# set -x JAVA_OPTS " --add-opens jdk.compiler/com.sun.tools.javac.model=ALL-UNNAMED" $JAVA_OPTS
# set -x JAVA_OPTS " --add-opens jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED" $JAVA_OPTS
# set -x JAVA_OPTS " --add-opens jdk.compiler/com.sun.tools.javac.processing=ALL-UNNAMED" $JAVA_OPTS
# set -x JAVA_OPTS " --add-opens jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED" $JAVA_OPTS
# set -x JAVA_OPTS " --add-opens jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED" $JAVA_OPTS
# set -x JAVA_OPTS " --add-opens jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED" $JAVA_OPTS

# test -d ~/appslnx/jdk-17 && set -x JAVA_HOME ~/appslnx/jdk-17 && set -x PATH $JAVA_HOME/bin
fish_add_path --global $JAVA_HOME/bin

fish_add_path --global ~/appslnx/clojure/bin
fish_add_path --global ~/appslnx/build-tools/gradle/bin

fish_add_path --global ~/usr/local/bin/appslnx/tools/async-profiler
fish_add_path --global ~/appslnx/tools/spring/bin

fish_add_path --global ~/appslnx/tools/liquibase

set -x KC_HOME ~/appslnx/web/keycloak
set -x KEYCLOAK_ADMIN admin
set -x KEYCLOAK_ADMIN_PASSWORD admin
fish_add_path --global $KC_HOME/bin

fish_add_path --global $HOME/.local/share/coursier/bin
set -x COURSIER_REPOSITORIES "ivy2Local|http://localhost:8080/releases"
#set -x COURSIER_MIRRORS "/home/z/src/devOps/06-PLs/scala/metals/mirror.properties"
