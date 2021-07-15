a=({'code': 'BKN', 'meaning': 'Broken', 'oktaMin': 5, 'oktaMax': 7, 'altitude': 2000, 'presenceCB': False, 'presenceTCU': False},)

i=0
for i in range(len(a)):
    
    print("===========================")

    if a[i] is not None:

        print("Tipo de nuvem: " + a[i]["code"])
        print("Tipo de nuvem (nome completo): " + a[i]["meaning"])
        print("Cobertura minima de nuvem: " + str(a[i]["oktaMin"]))
        print("Cobertura maxima de nuvem: " + str(a[i]["oktaMax"]))
        print("Altitude da nuvem: " + str(a[i]["altitude"]))

        if a[i]["presenceCB"]=="False":
	    print("Presenca de nuvem CB: - ")
        else:
	    print("Presenca de nuvem CB: Presente")

        if a[i]["presenceTCU"]=="False":
	    print("Presenca de Nuvem do tipo cumulo em forma de torre: - ")
        else:
	    print("Presenca de Nuvem do tipo cumulo em forma de torre: Presente")

    else:

        print("Sem nuvem")  
