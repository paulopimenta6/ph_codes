package com.paulopimenta.springboot_greendogdelivery.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class ExemploCommandRunner implements CommandLineRunner {

    Logger logger = LoggerFactory.getLogger(ExemploCommandRunner.class);

    @Override
    public void run(String... args) throws Exception {
        logger.info("==== ExemploCommandRunner ====");

        if (args.length>0) {
            for (String arg : args)
                logger.info("[" + arg + "]");
        } else {
            logger.info("Sem argumentos");
        }

        logger.info("==== ExemploCommandRunner ====");

    }
}
