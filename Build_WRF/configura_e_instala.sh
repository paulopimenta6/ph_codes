#!/bin/env bash

echo "############################################################"
echo "### Verificando se o diretorio do WRF existe             ###"
echo "############################################################"
dir="${HOME}/Build_WRF"

if test -d "${dir}" 
then
	echo "O diretorio existe"
else
	echo "O diretorio nao existe vamos criar o diretorio"
	mkdir "${dir}"
	echo "A diretorio ${dir} foi criado"
fi

echo "################################################################"
echo "### O diretorio das libs: /home/zagreb/Build_WRF/LIBRARIES   ###"
echo "################################################################"
echo " "
echo "### criando diretorio...                                     ###"
dir_libs="${dir}/LIBRARIES"
mkdir ${dir_libs}

echo " "
echo "#################################################################"
export "${dir_libs}"
export CC="gcc"
export CXX="g++"
export FC="gfortran"
export FCFLAGS="-m64"
export F77="gfortran"
export FFLAGS="-m64"
export JASPERLIB=${dir_libs}"/grib2/lib"
export JASPERINC=${dir_libs}"/grib2/include"
export LDFLAGS="-L"${dir_libs}"/grib2/lib"
export CPPFLAGS="-I"${dir_libs}"/grib2/include"
export LD_LIBRARY_PATH=${dir_libs}"/grib2/lib:"${LD_LIBRARY_PATH}
echo "##########################################################"
echo " "

echo "################################################################"
echo "### Entrando nos diretorio de libs                           ###"
echo "### Instalando as libs                                       ###"
echo "################################################################"
echo " "

for arquivoLib in jasper-1.900.1.tar.gz libpng-1.2.50.tar.gz mpich-3.0.4.tar.gz netcdf-4.1.3.tar.gz zlib-1.2.7.tar.gz
do
	cp ${arquivoLib} ${dir_libs}
done

#cp *.tar.* ${dir_libs}
cd ${dir_libs}
 
"##########################################################"
"### Usamos as seguintes versoes                        ###"
"### netcdf-4.1.3                                       ###"
"### mpich-3.0.4                                        ###"
"### zlib-1.2.7                                         ###"
"### libpng-1.2.50                                      ###"
"### Jasper-1.900.1                                     ###"
"##########################################################"

#1 - Descompactando a lib NetCDF 
if test -d ${dir_libs}"/netcdf-4.1.3/" 
then
	echo "O diretorio existe, vamos recria-lo"
	rm -r ${dir_libs}"/netcdf-4.1.3/"
	tar xzvf netcdf-4.1.3.tar.gz
else
	echo "O diretorio nao existe vamos criar o diretorio"
	tar xzvf netcdf-4.1.3.tar.gz
	echo "A diretorio "${dir_libs}"/netcdf-4.1.3/ foi criado"
fi
# e configurando a lib NetCDF
cd netcdf-4.1.3
./configure "--prefix="${dir_libs}"/netcdf --disable-dap --disable-netcdf-4 --disable-shared"
make
make install
export PATH=${dir_libs}"/netcdf/bin:"${PATH}
export NETCDF=${dir_libs}"/netcdf"
cd .. 

#2 - Descompactando a lib mpich
if test -d ${dir_libs}"/mpich-3.0.4/" 
then
	echo "O diretorio existe, vamos recria-lo"
	rm -r ${dir_libs}"/mpich-3.0.4/"
	tar xzvf mpich-3.0.4.tar.gz
else
	echo "O diretorio nao existe vamos criar o diretorio"
	tar xzvf mpich-3.0.4.tar.gz
	echo "A diretorio "${dir_libs}"/mpich-3.0.4/ foi criado"
fi

# e configurando a lib mpich
cd mpich-3.0.4
./configure "--prefix="${dir_libs}"/mpich"
make
make install
export PATH=${dir_libs}"/mpich/bin:${PATH}"
cd ..

#3 - Descompactando a lib zlib
if test -d ${dir_libs}"/zlib-1.2.7/" 
then
	echo "O diretorio existe, vamos recria-lo"
	rm -r ${dir_libs}"/zlib-1.2.7/"
	tar xzvf zlib-1.2.7.tar.gz
else
	echo "O diretorio nao existe vamos criar o diretorio"
	tar xzvf zlib-1.2.7.tar.gz
	echo "A diretorio "${dir_libs}"/zlib-1.2.7/ foi criado"
fi

# e configurando a lib zlib
cd zlib-1.2.7
./configure "--prefix="${dir_libs}"/grib2"
make
make install
cd .. 

#4 - Descompactando a lib libpng
if test -d ${dir_libs}"/libpng-1.2.50/" 
then
	echo "O diretorio existe, vamos recria-lo"
	rm -r ${dir_libs}"/libpng-1.2.50/"
	tar xzvf libpng-1.2.50.tar.gz
else
	echo "O diretorio nao existe vamos criar o diretorio"
	tar xzvf libpng-1.2.50.tar.gz
	echo "A diretorio "${dir_libs}"/libpng-1.2.50/ foi criado"
fi

# e configurando a lib libpng
cd libpng-1.2.50
./configure "--prefix="${dir_libs}"/grib2"
make
make install
cd ..

#5 - Descompactando a lib jasper
if test -d ${dir_libs}"/jasper-1.900.1/" 
then
	echo "O diretorio existe, vamos recria-lo"
	rm -r ${dir_libs}"/jasper-1.900.1/"
	tar xzvf jasper-1.900.1.tar.gz
else
	echo "O diretorio nao existe vamos criar o diretorio"
	tar xzvf jasper-1.900.1.tar.gz
	echo "A diretorio "${dir_libs}"/jasper-1.900.1/ foi criado"
fi

# e configurando a lib jasper
cd jasper-1.900.1
./configure "--prefix="${dir_libs}"/grib2"
make
make install
cd .. 

exit 1
