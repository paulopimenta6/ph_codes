package com.mystudies.meu.projeto.kafka;

import org.apache.kafka.clients.producer.*;
import java.util.Properties;

/**
 *
 * @author paulo
 */
public class ProdutorKafka {
    
    public static void main(String[] args){
        //Configuracao do produtor
        Properties props = new Properties();
        props.put("bootstrap.servers", "localhost:9092");
        props.put("key.serializer","org.apache.kafka.common.serialization.StringSerializer");
        props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");
        
        //Criando um produtor
        Producer<String, String> produtor = new KafkaProducer<>(props);  
        
        //Enviando mensagem
        for(int i = 0; i <10; i++){
            String mensagem = "Mensagem " + i;
            ProducerRecord<String, String> registro = new ProducerRecord<>("meu-topico", mensagem);
            
            produtor.send(registro, (metadata, ex) -> {
                if (ex == null){
                    System.out.printf("Enviada: %s | Particao: %d | Offset: %d\n",
                            mensagem, metadata. partition(), metadata.offset());
                } else{
                    System.err.println("Erro: " + ex.getMessage());
                }
            });
        }
        produtor.close();
    }
    
}
