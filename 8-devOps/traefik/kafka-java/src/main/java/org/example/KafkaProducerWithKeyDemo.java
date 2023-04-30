package org.example;

import org.apache.kafka.clients.producer.*;
import org.apache.kafka.common.serialization.StringSerializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Properties;
import java.util.concurrent.ExecutionException;

public class KafkaProducerWithKeyDemo {
    public static void main(String[] args) throws ExecutionException, InterruptedException {

        Logger logger = LoggerFactory.getLogger(KafkaProducerWithKeyDemo.class);

//        String bootstrapServer = "127.0.0.1:29092";
//        String bootstrapServer = "127.0.0.1:19092";
//        String bootstrapServer = "redpanda1.dev.me:19092";
        String bootstrapServer = "redpanda2.dev.me:19092";

//        String bootstrapServer = "kafka-1.personal.local:19092";
//        String bootstrapServer = "kafka-1.personal.local:29092";

        // Create Producer Properties
        Properties properties = new Properties();
        properties.setProperty(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServer);
        properties.setProperty(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        properties.setProperty(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
//        properties.setProperty(ProducerConfig.MAX_REQUEST_SIZE_CONFIG, "50");
//        properties.setProperty(ProducerConfig.BATCH_SIZE_CONFIG, "5");

        // Google prompt: kafka producer with sni
        Properties props = properties;
//        props.put("bootstrap.servers", "your.kafka.broker:9093");
//        props.put("security.protocol", "SSL");
//        props.put("security.protocol", "SASL_PLAINTEXT");
//        props.put("max.request.size", "4857600");
//        props.put("ssl.enabled.protocols", "TLSv1.3");
//        props.put("ssl.truststore.type", "PEM");

//        props.put("ssl.truststore.location", "/path/to/client.truststore.jks");
//        props.put("ssl.truststore.location", "/home/z/src/devOps/08-devOps/traefik/pki/personal.local+9.pem");
//        props.put("ssl.truststore.location", "/home/z/src/Scala/teaching/demos/arch-demo/support/redpanda-mounts/personal.local+9.pem");

//        props.put("ssl.truststore.password", "your_truststore_password");
//        props.put("ssl.keystore.location", "/path/to/client.keystore.jks");
//        props.put("ssl.keystore.type", "PEM");
//        props.put("ssl.keystore.location", "/home/z/src/Scala/teaching/demos/arch-demo/support/redpanda-mounts/personal.local+9-client-conv.pem");


//        props.put("ssl.keystore.password", "your_keystore_password");

//        props.put("ssl.endpoint.identification.algorithm", "https");

        // Create the Producer
        KafkaProducer<String, String> producer = new KafkaProducer<>(props);

        for (int i = 0; i < 2; i++) {

            String topic = "gfg_topic";
            String value = "hello_geeksforgeeks " + i;
            String key = "id_" + i;

            // Log the Key
            logger.info("Key: " + key);

            // Create a Producer Record with Key
            ProducerRecord<String, String> record =
                    new ProducerRecord<>(topic, key, value);

            // Java Producer with Callback
            producer.send(record, (recordMetadata, e) -> {
                // Executes every time a record successfully sent
                // or an exception is thrown
                if (e == null) {
                    logger.info("Received new metadata. \n" +
                            "Topic: " + recordMetadata.topic() + "\n" +
                            "Partition: " + recordMetadata.partition() + "\n" +
                            "Offset: " + recordMetadata.partition() + "\n");
                } else {
                    logger.error("Error while producing ", e);
                }
            }).get(); // Block the .send() to make it synchronous
        }

        // Flush and Close the Producer
        producer.flush();
        producer.close();

    }
}