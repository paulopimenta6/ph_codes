/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package teste;

/**
 *
 * @author Paulo Pimenta
 */
public class Teste {
    
    public static Passeio passeio = new Passeio();
    public static Carga carga = new Carga();    
    private static Leitura leitura = new Leitura();
    
    public static Passeio vetPasseio[] = new Passeio[5];
    public static Carga vetCarga[] = new Carga[5];

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        
        boolean flag = true;
        int opcao = 0;
        
        while(flag){
            System.out.println("\t ======================================================");
            System.out.println("\t =====Sistema de Gestão de Veiculos - Menu Inicial=====");
            System.out.println("\t 1. Cadastrar Veículo de Passeio");
            System.out.println("\t 2. Cadastrar Veículo de Carga");
            System.out.println("\t 3. Imprimir Todos os Veículos de Passeio");
            System.out.println("\t 4. Imprimir Todos os Veículos de Carga");
            System.out.println("\t 5. Imprimir Veículo de Passeio pela Placa");
            System.out.println("\t 6. Imprimir Veículo de Carga pela Placa");
            System.out.println("\t 7. Sair do Sistema");
        
            try{
            opcao = Integer.parseInt(leitura.entDados("\t Escolha uma opcao: "));
            }
            catch(NumberFormatException nfe){
                System.out.println("\t ");
                System.out.println("\t ==========================");
                System.out.println("\t Deve ser um valor inteiro!");
                System.out.println("\t Pressione <ENTER>");
                System.out.println("\t ==========================");
                leitura.entDados("");
                continue;
            }
            
            switch(opcao){
                case 1:
                    //for(int i = 0; i < vetPasseio.length; i++){
                    for(int i = achaVagoPasseio(); i < vetPasseio.length; i++){
                        if(i==-1){
                            leitura.entDados("\t Vetor de Carros de Passeio esta lotado - Aperte <ENTER>");
                            break;
                        }
                        passeio = new Passeio();
                        vetPasseio[i] = cadPasseio(passeio);
                        
                        leitura.entDados("\t Passeio armazenado na posicao " + i + " do vetor - Aperte <ENTER>");
                        String RespPasseio = leitura.entDados("\t Cadastrar outro veiculo de Passeio? s/n: ");
                        
                        //O metodo equalsIgnoreCase esta associado a uma string e ignora 
                        //o caso sensitive das strings 
                        if(RespPasseio.equalsIgnoreCase("n")){
                            break;
                        }
                        
                        if(achaVagoPasseio()==-1){
                            leitura.entDados("\t Vetor Passeio esta lotado - Aperte <ENTER>");
                            break;                            
                        }                        
                    }
                    break;
                
                case 2:
                    //for(int i = 0; i < vetCarga.length; i++){
                    for(int i = achaVagoCarga(); i < vetCarga.length; i++){
                        if(i == -1){
                            leitura.entDados("\t O vetor de carga esta lotado - Aperte <ENTER>");
                            break;
                        }
                            
                        carga = new Carga();
                        vetCarga[i] = cadCarga(carga);
                            
                        leitura.entDados("\t Carga armazenada na posicao " + " do vetor - aperte <ENTER>");
                        String respCarga = leitura.entDados("\t Deseja cadastrar uma nova Carga? s/n: ");
                            
                        if(respCarga.equalsIgnoreCase("n")){
                            break;
                        }
                        
                        if(achaVagoCarga() == -1){
                            leitura.entDados("\t O vetor esta carga esta lotado - Aperte <ENTER>");
                             break;
                        }                    
                    }
                    break;
                    
                case 3:
                    System.out.println("\t ======================================================");
                    System.out.println("\t Impressao de todos os veiculos de Passeio");
                    System.out.println("\t ======================================================");
                    for(int i = 0; i < vetPasseio.length; i++){
                        if(vetPasseio[i] != null){
                            impPasseio(vetPasseio[i], i);
                        }
                        else{
                            leitura.entDados("\t Nao ha mais veiculos para imprimir - Aperte <ENTER>");
                        }
                    }
                    break;
                    
                case 4: 
                    System.out.println("\t ======================================================");
                    System.out.println("\t Impressao de todos os veiculos de Carga");
                    System.out.println("\t ======================================================");
                    for(int i = 0; i < vetCarga.length; i++){
                        if(vetCarga[i] != null){
                            impCarga(vetCarga[i], i);
                        }
                        else{
                            leitura.entDados("\t Nao ha mais veiculos para imprimir - Aperte <ENTER>");
                        }
                    }
                    break;
                    
                case 5:
                    System.out.println("\t ======================================================");
                    System.out.println("\t Consulta pela placa de veiculo de Passeio");
                    System.out.println("\t ======================================================");                    
                    
                    passeio = new Passeio();
                    boolean existePlacaPasseio = false;
                    String placaPasseio = leitura.entDados("\t Informa a placa a ser pesquisada: ");
                    passeio.setPlaca(placaPasseio);
                    
                    for(int i = 0; i < vetPasseio.length; i++){
                        if(vetPasseio[i] != null){ //Aqui e preciso garantir que nao havera nenhum exception de impressao de algum vetor nulo
                            if(vetPasseio[i].getPlaca().equalsIgnoreCase(passeio.getPlaca())){
                                impPasseio(vetPasseio[i], i);
                                existePlacaPasseio = true;
                            }
                                    
                        }
                                                
                    }
                    if(!existePlacaPasseio){
                        leitura.entDados("\t Nao existe a placa cadastrada no banco de veiculos de Passeio - Aperte <ENTER>");                        
                    }
                    break;
                    
                case 6:
                    System.out.println("\t ======================================================");
                    System.out.println("\t Consulta pela placa de veiculo de Carga");
                    System.out.println("\t ======================================================");                    
                    
                    carga = new Carga();
                    boolean existePlacaCarga = false;
                    String placaCarga = leitura.entDados("\t Informa a placa a ser pesquisada: ");
                    carga.setPlaca(placaCarga);
                    
                    for(int i = 0; i < vetCarga.length; i++){
                        if(vetCarga[i] != null){//Aqui e preciso garantir que nao havera nenhum exception de impressao de algum vetor nulo
                            if(vetCarga[i].getPlaca().equalsIgnoreCase(carga.getPlaca())){
                                impCarga(vetCarga[i], i);
                                existePlacaCarga = true;
                            }
                        }                        
                    }
                    if(!existePlacaCarga){
                        leitura.entDados("\t Nao existe a placa cadastrada no banco de veiculos de Carga - Aperte <ENTER>");                        
                    }
                    break;
                    
                case 7:
                    flag = false;
                    break;
                    
                default:
                    leitura.entDados("\t O valor deve estar entre 1 e 7, inclusive");
                    break;                    
            }
        }
    
    }
    
    public static int achaVagoPasseio(){
        for(int i = 0; i < vetPasseio.length; i++){
            if(vetPasseio[i] == null){
                return i;
            }
        }
        return -1;
    }
    
    public static int achaVagoCarga(){
        for(int i = 0; i < vetCarga.length; i++){
            if(vetCarga[i] == null){
                return i;
            }
        }
        return -1;
    }
    
    public static Passeio cadPasseio(Passeio passeio){
        System.out.println("\t ======================================================");
        System.out.println("\t Cadastrando Veiculos de Passeio");
        System.out.println("\t ======================================================");
        passeio.setPassageiros(Integer.parseInt(leitura.entDados("\t Numero de Passageiros: ")));
        passeio.setPlaca(leitura.entDados("\t Placa: "));
        passeio.setMarca(leitura.entDados("\t Marca: "));
        passeio.setModelo(leitura.entDados("\t Modelo: "));
        passeio.setCor(leitura.entDados("\t Cor: "));
        passeio.setQtdRodas(Integer.parseInt(leitura.entDados("\t Numero de rodas: ")));
        passeio.setvelocMax(Integer.parseInt(leitura.entDados("\t Velocidade maxima: ")));
        passeio.getMotor().setPotencia(Integer.parseInt(leitura.entDados("\t Potencia do Motor: ")));
        passeio.getMotor().setqtdPist(Integer.parseInt(leitura.entDados("\t Quantidade de Pistoes: ")));
        
        return passeio;
    }

    public static Carga cadCarga(Carga carga){
        System.out.println("\t ======================================================");
        System.out.println("\t Cadastrando Veiculos de Carga");
        System.out.println("\t ======================================================");
        carga.settara(Integer.parseInt(leitura.entDados(("\t Tara: "))));
        carga.setcargaMax(Integer.parseInt(leitura.entDados("\t Carga Maxima: ")));
        carga.setPlaca((leitura.entDados("\t Placa: ")));
        carga.setModelo(leitura.entDados("\t Modelo: "));
        carga.setMarca((leitura.entDados("\t Marca: ")));
        carga.setCor(leitura.entDados("\t Cor: "));
        carga.setQtdRodas(Integer.parseInt(leitura.entDados("\t Numero de rodas: ")));
        carga.setvelocMax(Integer.parseInt(leitura.entDados("\t Velocidade maxima: ")));
        carga.getMotor().setPotencia(Integer.parseInt(leitura.entDados("\t Potencia do Motor: ")));
        carga.getMotor().setqtdPist(Integer.parseInt(leitura.entDados("\t Quantidade de Pistoes: ")));
        
        return carga;
    }
    
    public static void impPasseio(Passeio passeio, int i){
        System.out.println("\t ======================================================");
        System.out.println("\t Imprimindo Veiculo de Passeio");
        System.out.println("\t ======================================================");
        
        System.out.println("\t Veiculo de Passeio [" + i + "]");
        System.out.println("\t Passageiros: " + passeio.getPassageiros());
        System.out.println("\t Placa: " + passeio.getPlaca());
        System.out.println("\t marca: " + passeio.getMarca());
        System.out.println("\t Modelo: " + passeio.getModelo());
        System.out.println("\t Cor: " + passeio.getCor());
        System.out.println("\t Quantidade de Rodas: " + passeio.getQtdRodas());
        System.out.println("\t Velocidade Maxima: " + passeio.getvelocMax());
        System.out.println("\t Numero de Pistoes: " + passeio.getMotor().getqtdPist());
        System.out.println("\t Potencia: " + passeio.getMotor().getPotencia());
        System.out.println("\t Quantidade de letras somadas: " + passeio.Calcular());
        System.out.println("\t Velocidade [m/h]: " +  passeio.calcVel());
        
    }
    
    public static void impCarga(Carga carga, int i){
        System.out.println("\t ======================================================");
        System.out.println("\t Imprimindo Veiculo de Carga");
        System.out.println("\t ======================================================");
        
        System.out.println("\t Veiculo de Passeio [" + i + "]");
        System.out.println("\t Tara: " + carga.gettara());
        System.out.println("\t Carga Maxima: " + carga.getcargaMax());
        System.out.println("\t Placa: " + carga.getPlaca());
        System.out.println("\t Marca: " + carga.getMarca());
        System.out.println("\t Modelo: " + carga.getModelo());
        System.out.println("\t Cor: " + carga.getCor());
        System.out.println("\t Quantidade de Rodas: " + carga.getQtdRodas());
        System.out.println("\t Velocidade Maxima: " + carga.getvelocMax());
        System.out.println("\t Numero de Pistoes: " + carga.getMotor().getqtdPist());
        System.out.println("\t Potencia: " + carga.getMotor().getPotencia());
        System.out.println("\t Quantidade de valores inteiros somados: " + carga.Calcular());
        System.out.println("\t Velocidade [cm/h]: " +  carga.calcVel());
        
    }
        
    
    
}
