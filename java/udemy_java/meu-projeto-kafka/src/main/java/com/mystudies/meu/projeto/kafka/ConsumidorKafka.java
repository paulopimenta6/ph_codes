package com.mystudies.meu.projeto.kafka;

import org.apache.kafka.clients.consumer.*;
import java.time.Duration;
import java.util.Collections;
import java.util.Properties;


/**
 *
 * @author paulo
 */
public class ConsumidorKafka {
    public static void main(String[] args){
        //Configuracoes do consumidor
        Properties props = new Properties();
        props.put("bootstrap.servers", "localhost:9092");
        props.put("key.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
        props.put("value.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
        props.put("auto.offset.reset", "earliest");
        props.put("group.id", "meu-grupo"); //ID do grupo de consumidores
        
        //Criando consumidor
        Consumer<String, String> consumidor = new KafkaConsumer<>(props);
        consumidor.subscribe(Collections.singletonList("meu-topico")); //Inscreve no topico
        
        //Consumir mensagens
        try {
            while(true){
                ConsumerRecords<String, String> registros = consumidor.poll(Duration.ofMillis(100));
                for (ConsumerRecord<String, String> registro: registros){
                    System.out.printf("Recebida: %s | Particao: %d | Offset: %d\n", 
                            registro.value(), registro.partition(), registro.offset());
                }
            }
        } finally{
            consumidor.close();            
        }
    }
    
}
