package br.edu.utfpr;

import com.opencsv.bean.CsvToBeanBuilder;

import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.Month;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.Map.Entry;
import java.util.stream.Collectors;

import static java.util.stream.Collectors.*;

public class SalesReader {

    private final List<Sale> sales;

    public SalesReader(String salesFile) {

        final var dataStream = ClassLoader.getSystemResourceAsStream(salesFile);

        if (dataStream == null) {
            throw new IllegalStateException("File not found or is empty");
        }

        final var builder = new CsvToBeanBuilder<Sale>(new InputStreamReader(dataStream, StandardCharsets.UTF_8));

        sales = builder
                .withType(Sale.class)
                .withSeparator(';')
                .build()
                .parse();
    }

    public BigDecimal totalOfCompletedSales() {
        return sales.stream()
                .filter(Sale::isCompleted)
                .map(Sale::getValue)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public BigDecimal totalOfCancelledSales() {
        return sales.stream()
                .filter(Sale::isCancelled)
                .map(Sale::getValue)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public Optional<Sale> mostRecentCompletedSale() {
        return sales.stream()
                .filter(Sale::isCompleted)
                .max(Comparator.comparing(Sale::getSaleDate));
    }

    public long daysBetweenFirstAndLastCancelledSale() {
        Optional<LocalDate> firstCancelled = sales.stream()
                .filter(Sale::isCancelled)
                .map(Sale::getSaleDate)
                .min(LocalDate::compareTo);

        Optional<LocalDate> lastCancelled = sales.stream()
                .filter(Sale::isCancelled)
                .map(Sale::getSaleDate)
                .max(LocalDate::compareTo);

        if(firstCancelled.isPresent() && lastCancelled.isPresent()){
            return ChronoUnit.DAYS.between(firstCancelled.get(), lastCancelled.get());
        }
        return 0;
    }

    public BigDecimal totalCompletedSalesBySeller(String sellerName) {
        return sales.stream()
                .filter(Sale::isCompleted)
                .filter(sale->sale.getSeller().equalsIgnoreCase(sellerName))
                .map(Sale::getValue)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public long countAllSalesByManager(String managerName) {
        return sales.stream()
                .filter(sale->sale.getManager().equalsIgnoreCase(managerName))
                .count();
    }

    public BigDecimal totalSalesByStatusAndMonth(Sale.Status status, Month... months) {
        Set<Month> monthSet = new HashSet<>(Arrays.asList(months));
        return sales.stream()
                .filter(sale->sale.getStatus() == status)
                .filter(sale->monthSet.contains(sale.getSaleDate().getMonth()))
                .map(Sale::getValue)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public Map<String, Long> countCompletedSalesByDepartment() {
        return sales.stream()
                .filter(Sale::isCompleted)
                .collect(groupingBy(Sale::getDepartment, counting()));
    }

    public Map<Integer, Map<String, Long>> countCompletedSalesByPaymentMethodAndGroupingByYear() {
        return sales.stream()
                .filter(Sale::isCompleted)
                .collect(groupingBy(sale->sale.getSaleDate().getYear(),
                        groupingBy(Sale::getPaymentMethod, counting())));
    }

    public Map<String, BigDecimal> top3BestSellers() {
        return sales.stream()
                .filter(Sale::isCompleted)
                .collect(Collectors.groupingBy(Sale::getSeller,
                        Collectors.reducing(BigDecimal.ZERO, Sale::getValue, BigDecimal::add)))
                .entrySet().stream()
                .sorted(Map.Entry.<String, BigDecimal>comparingByValue().reversed())
                //.sorted(Map.Entry.<String, BigDecimal>comparingByValue())
                .limit(3)
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue, (exc1, exc2) -> exc1, LinkedHashMap::new));
    }
}
