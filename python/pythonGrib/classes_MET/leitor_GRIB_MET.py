#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jun 22 05:36:04 2021

@author: paulopimenta
"""

import pygrib


class leitor_de_GRIB:
    
    def __init__(self):
        self.arquivo_GRIB="../grib/gfs.t00z.pgrb2.0p25.f003"
        self.grb=" "  
        # =============================================================================
        # Aqui sera modificado posteriormente com uma lista de grb        
        # =============================================================================

    def abre_GRIB(self):        
    # =============================================================================
    # Leitura do grib dentro da lib pygrib  
    # =============================================================================
        self.grb=pygrib.open(self.arquivo_GRIB)
        