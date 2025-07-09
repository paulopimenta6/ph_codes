package com.paulopimenta.springboot_greendogdelivery.repository;

import com.paulopimenta.springboot_greendogdelivery.domain.Pedido;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PedidoRepository extends JpaRepository<Pedido, Long> {

}
