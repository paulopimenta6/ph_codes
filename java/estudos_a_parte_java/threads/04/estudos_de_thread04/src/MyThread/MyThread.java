package MyThread;

public class MyThread extends Thread {
    //constroi uma nova thread
    public MyThread(String name){
        super(name);
        start();
    }

    //comeca a execucao da nova thread
    public void run(){
        System.out.println(getName() + " starting.");
        try{
            for(int count=0; count<10; count++){
                Thread.sleep(400);
                System.out.println("In " + getName() + ", count is " + count);
            }
        } catch(InterruptedException exc){
            System.out.println(getName() + " Interrupted.");
        }
        System.out.println(getName() + " terminating");
    }
}
