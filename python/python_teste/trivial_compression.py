class CompressedGene:
    def __init__(self, gene: str)-> None:
        self._compress(gene)

    def _compress(self, gene: str) -> None:
        self.bit_string: int = 1
        for nucleottide in gene.upper():
            self.bit_string <<= 2
            if nucleottide == "A":
                self.bit_string |= 0b00
            elif nucleottide == "C" :
                self.bit_string |= 0b01
            elif nucleottide == "G":
                self.bit_string |= 0b10
            elif nucleottide == "T":
                self.bit_string |= 0b11
            else:
                raise ValueError("Invalid Nucleottide:{}".formar(nucleottide))
    
    def decompress(self) -> str:
        gene: str = ""
        for i in range(0, self.bit_string.bit_length()-1, 2):
            bits: int = self.bit_string >> i & 0b11
            if bits == 0b00:
                gene += "A"
            elif bits == 0b01:
                gene += "C"
            elif bits == 0b10:
                gene += "G"
            elif bits == 0b11:
                gene += "T"
            else:
                raise ValueEerror("Invalid bits: {}".format(bits))
    
        return gene[::-1]
                    
    def __str__(self) -> str:
        return self.decompress()                    
    
if __name__ == "__main__":
    from sys import getsizeof
    #original: str =  "TAGGGATTAACCGTTATATATATATAGCCATGGATCGATTATATAGGGATTAACCGTTATATATATATAGCCATGGATCGATTATA" * 100
    original: str =  "TAAG" * 3
    print("original is {} bytes".format(getsizeof(original)))
    compressed: CompressedGene = CompressedGene(original) #compacta a variavel original
    print("compressed is {} bytes".format(getsizeof(compressed.bit_string)))
    print(compressed)
    print("original and decompressed are the: {}".format(original == compressed.decompress()))
    print("compressed is {} times smaller than original".format(getsizeof(original) / getsizeof(compressed.bit_string)))                    