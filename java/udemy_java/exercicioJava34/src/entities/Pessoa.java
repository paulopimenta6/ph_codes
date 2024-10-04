package entities;

/**
 *
 * @author Paulo_Pimenta
 */
public class Pessoa {
    
    private String name;
    private int age;
    private double height;
    
    public Pessoa(){
        this.name = "";
        this.age = 0;
        this.height = 0.0;
    } 

    public Pessoa(String name, int age, double height){
        this.name = name;
        this.age = age;
        this.height = height;
    }

    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }

    public double getHeight() {
        return height;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public void setHeight(double height) {
        this.height = height;
    }

    @Override
    public String toString() {
        return "Pessoa: " + "name=" + name + ", age=" + age + ", height=" + height;
    }   
    
}
