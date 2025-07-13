package org.paulopimenta.shop_api;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Main {

    private static final Logger logger = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) {

        logger.info(">>> Iniciando aplicação Shop API...");

        try{
            SpringApplication.run(Main.class, args);
            logger.info(">>> Aplicacao executada com sucesso");
        }catch(Exception e){
            logger.info(">>> Erro ao iniciar a aplicacao: ", e.getMessage(), e);
            System.exit(1);
        }
    }
}