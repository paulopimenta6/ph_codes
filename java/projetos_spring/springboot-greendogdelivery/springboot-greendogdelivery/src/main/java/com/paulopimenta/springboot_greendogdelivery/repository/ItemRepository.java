package com.paulopimenta.springboot_greendogdelivery.repository;

import com.paulopimenta.springboot_greendogdelivery.domain.Item;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ItemRepository extends JpaRepository<Item, Long> {
}
