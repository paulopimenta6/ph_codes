class Savings
{
	public:
		double deposit(double amount)
		{
			balance += amount;
			return balance;
		}
		
		unsigned int accountNumber;
		double balance;
};