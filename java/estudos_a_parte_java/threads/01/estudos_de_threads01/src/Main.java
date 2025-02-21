import MyThread.*;

public class Main {
    public static void main(String[] args) {
        System.out.println("Main thread starting");

        //Primeiro constroi um objeto MyThread
        MyThread mt = new MyThread("Child #1");
        //Em seguida, constroi uma thread a partir desse objeto
        Thread newThrd = new Thread(mt);

        //Para concluir, começa a execução da thread
        newThrd.start();

        for(int i = 0; i < 50; i++){
            System.out.print(".");
            try{
                Thread.sleep(100);
            }
            catch(InterruptedException exc){
                System.out.println("Main thread interrupted.");
            }
        }

        System.out.println("Main thread ending");

    }
}