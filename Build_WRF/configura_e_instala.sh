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
echo "### O diretorio das libs: /home/zagreb/Build_WRF/LIBRARIES   ###"
echo "################################################################"
echo " "

cd  


exit 1
