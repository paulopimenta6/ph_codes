package br.servlet;

import br.bean.RankingBean;
import br.bean.SomaBean;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import java.util.Random;

@WebServlet(name = "RankingServlet", urlPatterns = {"/ranking"})
public class RankingServlet extends HttpServlet {

    private RankingBean rankingBean = new RankingBean();
    private Random random = new Random();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        
        // Gerar números aleatórios para a soma
        int num1 = random.nextInt(100);
        int num2 = random.nextInt(100);
        
        // Armazenar os números na sessão
        session.setAttribute("num1", num1);
        session.setAttribute("num2", num2);
        
        // Obter o nome do usuário da sessão, se existir
        String userName = (String) session.getAttribute("userName");
        
        // Obter a mensagem de resultado, se existir
        String resultMessage = (String) session.getAttribute("resultMessage");
        session.removeAttribute("resultMessage"); // Limpar a mensagem após exibição
        
        // Obter o ranking atual
        List<Map.Entry<String, Integer>> ranking = rankingBean.getRanking();
        
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Jogo de Soma</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; }");
            out.println("h1 { color: #2c3e50; text-align: center; }");
            out.println(".container { background-color: #f9f9f9; border-radius: 8px; padding: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }");
            out.println(".form-group { margin-bottom: 15px; }");
            out.println("label { display: block; margin-bottom: 5px; font-weight: bold; }");
            out.println("input[type='text'], input[type='number'] { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }");
            out.println("button { background-color: #3498db; color: white; border: none; padding: 10px 15px; border-radius: 4px; cursor: pointer; }");
            out.println("button:hover { background-color: #2980b9; }");
            out.println(".result { margin: 15px 0; padding: 10px; border-radius: 4px; }");
            out.println(".success { background-color: #d4edda; color: #155724; }");
            out.println(".error { background-color: #f8d7da; color: #721c24; }");
            out.println(".ranking { margin-top: 20px; }");
            out.println(".ranking h2 { color: #2c3e50; border-bottom: 1px solid #eee; padding-bottom: 10px; }");
            out.println(".ranking ol { padding-left: 20px; }");
            out.println(".ranking li { margin-bottom: 5px; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            out.println("<div class='container'>");
            out.println("<h1>Jogo de Soma</h1>");
            
            // Formulário para nome do usuário (se ainda não informado)
            if (userName == null || userName.isEmpty()) {
                out.println("<form method='post' action='ranking'>");
                out.println("<div class='form-group'>");
                out.println("<label for='userName'>Informe seu nome:</label>");
                out.println("<input type='text' id='userName' name='userName' required>");
                out.println("</div>");
                out.println("<button type='submit' name='action' value='setName'>OK</button>");
                out.println("</form>");
            } else {
                // Exibir o jogo de soma
                out.println("<form method='post' action='ranking'>");
                out.println("<div class='form-group'>");
                out.println("<label>Quanto é: [" + num1 + "] + [" + num2 + "] = </label>");
                out.println("<input type='number' name='userAnswer' required>");
                out.println("<input type='hidden' name='correctAnswer' value='" + (num1 + num2) + "'>");
                out.println("</div>");
                out.println("<button type='submit' name='action' value='checkAnswer'>Verificar</button>");
                out.println("</form>");
                
                // Exibir mensagem de resultado, se houver
                if (resultMessage != null) {
                    if (resultMessage.contains("Acertou")) {
                        out.println("<div class='result success'>" + resultMessage + "</div>");
                    } else {
                        out.println("<div class='result error'>" + resultMessage + "</div>");
                    }
                }
            }
            
            // Exibir o ranking
            out.println("<div class='ranking'>");
            out.println("<h2>===== Ranking Atual =====</h2>");
            if (ranking.isEmpty()) {
                out.println("<p>Ainda não há jogadores no ranking.</p>");
            } else {
                out.println("<ol>");
                for (Map.Entry<String, Integer> entry : ranking) {
                    out.println("<li>" + entry.getKey() + " - " + entry.getValue() + " pontos</li>");
                }
                out.println("</ol>");
            }
            out.println("</div>");
            
            out.println("</div>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
        if ("setName".equals(action)) {
            // Processar o nome do usuário
            String userName = request.getParameter("userName");
            if (userName != null && !userName.trim().isEmpty()) {
                session.setAttribute("userName", userName);
                // Inicializar a pontuação do usuário
                rankingBean.addPlayer(userName);
            }
        } else if ("checkAnswer".equals(action)) {
            // Verificar a resposta do usuário
            String userName = (String) session.getAttribute("userName");
            if (userName != null) {
                try {
                    int userAnswer = Integer.parseInt(request.getParameter("userAnswer"));
                    int correctAnswer = Integer.parseInt(request.getParameter("correctAnswer"));
                    
                    if (userAnswer == correctAnswer) {
                        // Resposta correta
                        rankingBean.incrementScore(userName);
                        session.setAttribute("resultMessage", "✅ Acertou!");
                    } else {
                        // Resposta incorreta
                        session.setAttribute("resultMessage", "❌ Errou! A resposta correta era " + correctAnswer);
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("resultMessage", "❌ Erro: Resposta inválida");
                }
            }
        }
        
        // Redirecionar de volta para o servlet
        response.sendRedirect("ranking");
    }
}

