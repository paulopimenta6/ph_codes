package entities;

public class cadastro {
   public String name;
   public double GrossSalary;
   public double tax;
   
   public double NetSalary(){
      return GrossSalary - tax;   
   }
   
   public void IncreaseSalary(double percentage){
       GrossSalary += (percentage*GrossSalary/100.00);
   }
   
   @Override
   public String toString(){
      return name + ", $" + String.format("%.2f", NetSalary());
   }
}
