//Cria uma thread implementando Runnable

package MyThread;

public class MyThread implements Runnable {
    String thrdName;

    public MyThread(String name){
        thrdName = name;
    }

    //Ponto de entrada da thread
    @Override
    public void run() {
        System.out.println(thrdName + " starting.");
        try{
            for(int count = 0; count < 10; count++){
                Thread.sleep(400);
                System.out.println("In " + thrdName + ", count is: " + count);
            }
        } catch (InterruptedException exc) {
            System.out.println(thrdName + " interrupted");
        }
        System.out.println(thrdName + " terminating.");
    }
}
