package br.edu.utfpr;

import com.opencsv.bean.AbstractBeanField;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public class LocalDateConverter extends AbstractBeanField<String, LocalDate> {
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    @Override
    protected LocalDate convert(String value) {
        try{
            return LocalDate.parse(value, formatter);
        } catch (DateTimeParseException exc){
            throw new RuntimeException("Erro ao analisar data: " + value, exc);
        }
    }
}
