plugins {
    application
}

group = "org.example"
version = "1.0-SNAPSHOT"

application {
    mainClass = "org.example.KafkaProducerWithKeyDemo"
}

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(platform("org.junit:junit-bom:5.10.0"))
    testImplementation("org.junit.jupiter:junit-jupiter")
    implementation("org.apache.kafka:kafka-clients:4.0.0")
    implementation("ch.qos.logback:logback-classic:1.5.18")
}

tasks.test {
    useJUnitPlatform()
}