package entities;

public class Grade {
    public String name;
    public double grade1;
    public double grade2;
    public double grade3;
    
    public double calcGrades(){
        return grade1 + grade2 + grade3;   
    }
    
    public boolean passedOrNotPassed(){
        if(calcGrades()>=60.00){
            return true;
        } else{
            return false;
        }        
    }
    
    @Override
    public String toString(){
        if(passedOrNotPassed()){
            return "Final Grade: " + String.format("%.2f%n", calcGrades())
                + "PASS\n";   
        } else{
            return "Final Grade: " + String.format("%.2f%n", calcGrades())
                + "Failed\n"
                + "Missing: " + String.format("%.2f%n", 60.00 - calcGrades());
        }        
    }    
}
