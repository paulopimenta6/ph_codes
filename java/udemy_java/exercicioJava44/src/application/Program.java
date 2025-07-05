package application;

import entities.Order;
import entities.enums.OrderStatus;
import java.util.Date;

/**
 *
 * @author Paulo_Pimenta
 */
public class Program {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        Order order = new Order(1080, new Date(), OrderStatus.PENDING_PAYMENT);
        
        System.out.println(order);
        
        OrderStatus os1 = OrderStatus.DELIVERED;
        OrderStatus os2 = OrderStatus.SHIPPED;
        OrderStatus os3 = OrderStatus.valueOf("DELIVERED");
        
        System.out.println(os1);
        System.out.println(os2);
        System.out.println(os3);       
        
    }
    
}
