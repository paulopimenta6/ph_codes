/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package exemplothis;

/**
 *
 * @author Paulo Pimenta
 */
public class Point {
    public int x = 0;
    public int y = 0;
    private int resu;
        
    //constructor
    public Point(int x, int y) {
        this.x = x;
        this.y = y;
    }
    public Point(){
        System.out.println(x);
        System.out.println(y);
    }
    
    public boolean comparaValores(int x){
        System.out.println("---");
        System.out.println(x);
        System.out.println(this.x);
        if(this.x == x){
            return true;
        }else{
            return false;
        }
    }
    
    public int soma(){
        this.resu = this.x + this.y;
        return this.resu;
    }
}
