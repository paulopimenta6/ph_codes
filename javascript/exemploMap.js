class startReport{
    static criaQuery(terminal, filtro_data){
        const query_completa = new Map();

        //metodos usados para a compor a query        
        query_completa.set("insert", "insert into");
        query_completa.set("rel_solicita", "rel_solicita");
        query_completa.set("values", "values");

        //colunas da tabela do BD
        query_completa.set("rs_usuario", `"ATM"`);
        query_completa.set("rs_terminal", terminal);
        query_completa.set("rs_tp_relatorio", `"Rel103"`);
        query_completa.set("rs_filtro_segurado", `"T"`);
        query_completa.set("rs_filtro_tp_data", `"EMB"`);
        query_completa.set("rs_filtro_data", filtro_data);
        query_completa.set("rs_tp_arquivo", `"XLSX"`);
        query_completa.set("rs_dt_inc", `now()`);
        query_completa.set("rs_visto", `"N"`);
        query_completa.set("rs_status", `"N"`);

        let sql = `sql`;

        for (let [key, value] of query_completa){
            if (value==="insert into"){
                sql = sql + `${value}`;
            }
            if (value==="rel_solicita"){
                sql = sql + `${value}`;
            }
            if (value==="values"){
                sql = sql + `${value}`;
            }
 
            
            //console.log(`${key} = ${value}`);
             
        }        
    }
};

module.exports = startReport;