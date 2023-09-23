#ifndef PONTO_H
#define PONTO_H

class Ponto
{
	public:
	    Ponto();
	    Ponto(int x, int y);
	    int getX() const;
	    int getY() const;
	private:
		int x;
		int y;		
};

#endif