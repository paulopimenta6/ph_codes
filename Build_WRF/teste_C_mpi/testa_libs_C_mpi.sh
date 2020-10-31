echo "#############################################################"
echo "### Verificando se o GCC, CPP e GFORTRAN estao instalados ###"
echo "#############################################################" 
vargcc=$(echo $(which gcc))
varcpp=$(echo $(which cpp))
vargfortran=$(echo $(which gfortran))

echo " "

if [ -z ${vargcc} ]
then
	echo "GCC nao esta instalado"
	exit 1;
else
	echo "GCC instalado"
fi	

if [ -z ${varcpp} ]
then
	echo "CPP nao esta instalado"
	exit 1;
else
	echo "CPP instalado"
fi

if [ -z ${vargfortran} ]
then
	echo "GFORTRAN nao esta instalado"
	exit 1;
else
	echo "GFORTRAN esta instalado"
fi
echo " "

echo "##########################################################"
echo "### Testando o ambiente                                ###"
echo "##########################################################"

tar -xf Fortran_C_tests.tar
echo " "

echo "### Test #1: Fixed Format Fortran Test: TEST_1_fortran_only_fixed.f"
gfortran TEST_1_fortran_only_fixed.f
./a.out
echo " "

echo "### Test #2: Free Format Fortran: TEST_2_fortran_only_free.f90"
gfortran TEST_2_fortran_only_free.f90
echo " "
./a.out

echo " "
echo "### Test #3: C: TEST_3_c_only.c"
gcc TEST_3_c_only.c
./a.out

echo " "
echo "Test #4: Fortran Calling a C Function (our gcc and gfortran have different defaults, so we force both to always use 64 bit [-m64] when combining them): TEST_4_fortran+c_c.c, and TEST_4_fortran+x_f.f90"
gcc -c -m64 TEST_4_fortran+c_c.c
gfortran -c -m64 TEST_4_fortran+c_f.f90
gfortran -m64 TEST_4_fortran+c_f.o TEST_4_fortran+c_c.o
./a.out

echo " "
echo "### Test #5:csh In the command line, type:"
./TEST_csh.csh

echo " "
echo "Test #6:perl In the command line, type:"
./TEST_perl.pl

echo " "
echo "### Test #7:sh In the command line, type:"
./TEST_sh.sh

echo " "
echo "##########################################################"
echo "### Limpando o ambiente                                ###"
echo "##########################################################"

echo " "
echo "### Limpando arquivos C                                ###"
rm a.out TEST_3_c_only.c TEST_4_fortran+c_c.c 

echo " "
echo "### Limpando arquivos Fortran                          ###"
rm TEST_1_fortran_only_fixed.f TEST_2_fortran_only_free.f90   TEST_4_fortran+c_f.f90

echo " "
echo "### Limpando arquivos txt/csh/shell/perl               ###"
rm kelly_reqs.txt TEST_csh.csh TEST_sh.sh TEST_perl.pl

echo " "
echo "### Limpando objetos complilados                       ###"
rm TEST_4_fortran+c_c.o TEST_4_fortran+c_f.o

ls








