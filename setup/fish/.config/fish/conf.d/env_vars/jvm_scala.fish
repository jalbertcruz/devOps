
set -x PATH $HOME/appslnx/build-tools/maven/bin $PATH
set -x PATH $JAVA_HOME/bin/ $HOME/appslnx/build-tools/maven/bin/ $PATH
#set -x PATH $HOME/appslnx/jdk-11/bin/ $HOME/appslnx/build-tools/maven/bin/ $HOME/.rbenv/shims/ $PATH

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

set -x PATH $HOME/.local/share/coursier/bin $PATH

if test -d ~/appslnx/jdk-17
    set -x JAVA_HOME ~/appslnx/jdk-17
end

set -x PATH ~/appslnx/clojure/bin $PATH
set -x PATH ~/appslnx/build-tools/gradle/bin $PATH

set -x PATH $HOME/usr/local/bin/appslnx/tools/async-profiler $PATH
