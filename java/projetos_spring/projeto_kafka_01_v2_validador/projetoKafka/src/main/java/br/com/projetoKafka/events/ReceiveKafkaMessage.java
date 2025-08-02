package br.com.projetoKafka.events;

import br.com.projetoKafka.dto.ShopDTO;
import br.com.projetoKafka.dto.ShopItemDTO;
import br.com.projetoKafka.model.Product;
import br.com.projetoKafka.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class ReceiveKafkaMessage {

    private static final String SHOP_TOPIC_NAME = "SHOP_TOPIC";
    private static final String SHOP_TOPIC_EVENT_NAME = "SHOP_TOPIC_EVENT";

    private final ProductRepository productRepository;
    private final KafkaTemplate<String, ShopDTO> kafkaTemplate;

    @KafkaListener(topics = SHOP_TOPIC_NAME, groupId = "group")
    public void listenShopTopic(ShopDTO shopDTO){
        try{
            log.info("Compra recebida no topico: {}.",
                    shopDTO.getIdentifier());

            boolean success = true;
            for (ShopItemDTO item:shopDTO.getItems()){
                Product product = productRepository
                        .findByIdentifier(
                                item.getProductIdentifier());

                if (!isValidShop(item, product)){
                    shopError(shopDTO);
                    success = false;
                    break;
                }
            }

            if (success){
                shopSuccess(shopDTO);
            }
        } catch(Exception e) {
            log.error("Erro no procesamento da compra {}",
                    shopDTO.getIdentifier());
        }
    }

    //valida se a compra possui algum erro
    private boolean isValidShop( ShopItemDTO item, Product product){
        return product != null && product.getAmount() >= item.getAmount();
    }

    //envia uma mensagem para o Kafka indicando erro na compra
    private void shopError(ShopDTO shopDTO){
        log.info("Erro no processamento da compra {}.",
                shopDTO.getIdentifier());
        shopDTO.setStatus("ERROR");
        kafkaTemplate.send(SHOP_TOPIC_EVENT_NAME, shopDTO);
    }

    private void shopSuccess(ShopDTO shopDTO){
        log.info("Compra {} efetuada com sucesso.",
                shopDTO.getIdentifier());
        shopDTO.setStatus("SUCCESS");
        kafkaTemplate.send(SHOP_TOPIC_EVENT_NAME, shopDTO);
    }

}
