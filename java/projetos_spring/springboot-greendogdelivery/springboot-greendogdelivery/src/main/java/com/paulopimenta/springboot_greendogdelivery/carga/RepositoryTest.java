package com.paulopimenta.springboot_greendogdelivery.carga;

import com.paulopimenta.springboot_greendogdelivery.domain.Cliente;
import com.paulopimenta.springboot_greendogdelivery.domain.Item;
import com.paulopimenta.springboot_greendogdelivery.domain.Pedido;
import com.paulopimenta.springboot_greendogdelivery.repository.ClienteRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

import java.util.ArrayList;

@Component
public class RepositoryTest implements ApplicationRunner {

    Logger logger = LoggerFactory.getLogger(ApplicationRunner.class);

    private static final long ID_CLIENTE_FERNANDO = 11L;
    private static final long ID_CLIENTE_ZE_PEQUENO = 22L;

    private static final long ID_ITEM1 = 100L;
    private static final long ID_ITEM2 = 101L;
    private static final long ID_ITEM3 = 102L;

    private static final long ID_PEDIDO1 = 1000L;
    private static final long ID_PEDIDO2 = 1001L;
    private static final long ID_PEDIDO3 = 1002L;

    private final ClienteRepository clienteRepository;

    public RepositoryTest(ClienteRepository clienteRepository) {
        this.clienteRepository = clienteRepository;
    }

    @Override
    public void run(ApplicationArguments applicationArguments) throws Exception {

        logger.info(">>> Iniciando carga de dados...");

        //Instanciando os clientes
        var fernando = new Cliente(ID_CLIENTE_FERNANDO, "Fernando Boaglio", "Sampa");
        var zePequeno = new Cliente(ID_CLIENTE_ZE_PEQUENO, "Ze Pequeno", "Cidade de Deus");

        //Instanciando os lanches
        var dog1 = new Item(ID_ITEM1, "Green dog tradicional", 25d);
        var dog2 = new Item(ID_ITEM2, "Green dog tradicional picante", 27d);
        var dog3 = new Item(ID_ITEM3, "Green dog max salada", 30d);

        var listaPedidoFernando1 = new ArrayList<Item>();
        listaPedidoFernando1.add(dog1);
        var listaPedidoFernando2 = new ArrayList<Item>();
        listaPedidoFernando2.add(dog2);

        var pedidoDoFernando = new Pedido(ID_PEDIDO1, fernando, listaPedidoFernando1, dog1.getPreco());
        fernando.novoPedido(pedidoDoFernando);
        var pedido2DoFernando = new Pedido(ID_PEDIDO3, fernando, listaPedidoFernando2, dog2.getPreco());
        fernando.novoPedido(pedido2DoFernando);

        var listaPedidoZePequeno1 = new ArrayList<Item>();
        listaPedidoZePequeno1.add(dog2);
        listaPedidoZePequeno1.add(dog3);

        var pedidoDoZepequeno = new Pedido(ID_PEDIDO2,zePequeno,listaPedidoZePequeno1, dog2.getPreco()+dog3.getPreco());
        zePequeno.novoPedido(pedidoDoZepequeno);

        logger.info(">>> Pedido - Fernando: " + pedidoDoFernando + " " + pedido2DoFernando);
        logger.info(">>> Pedido - Ze Pequeno: " + pedidoDoZepequeno);

        clienteRepository.saveAndFlush(fernando);
        logger.info(">>> Gravado cliente 1: " + fernando);
        clienteRepository.saveAndFlush(zePequeno);
        logger.info(">>> Gravado cliente 2: " + zePequeno);
    }
}
