package util;

public class CurrencyConverter {
    
    private static final double IOF = 0.06;
    
    public static double dollarConverter(double dollarValue, double dollarRate){
        return ((dollarRate*dollarValue) + IOF*dollarRate*dollarValue);
    }
    
}
