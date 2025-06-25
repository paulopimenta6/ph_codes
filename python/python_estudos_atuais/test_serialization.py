from __future__ import annotations

def _u32_to_bytes(value: int) -> bytes:
    if not 0 <= value < 2**32:
        raise ValueError('uint32 fora do intervalo')
    return value.to_bytes(4, 'little')

def _bytes_to_u32(b: bytes, offset: int):
    if offset + 4 > len(b):
        raise ValueError('buffer insuficiente')
    return int.from_bytes(b[offset:offset+4], 'little'), offset + 4

def serialize_strings(lista):
    componente = []
    for elem in lista:
        componente.append(_u32_to_bytes(len(elem)) + elem.encode('UTF-8'))
    dados = b"".join(componente)             
    print(dados)

def serialize_u32(numLst):
    ba_num = bytearray()
    for elem in numLst:
        ba_num.append(elem)
    print(ba_num) 

    print(list(ba_num))   

###################################################################################################################################
lst = ['dsaa', 'bdsf', 'csdfds']
lstNum = [1, 4, 8, 99]
###################################################################################################################################
serialize_strings(lst)
serialize_u32(lstNum)