package control;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Autor;
import control.persist.Dao;

public class Servlet extends HttpServlet {

	private Dao dao;

	private Dao dao() {
		if (dao == null)
			dao = new Dao();
		return dao;
	}
	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		dao().transacao();

		if (dao().todos(Autor.class).size() == 0) {
			Autor a1 = new Autor();
			a1.nome = "Pedrinho de Souza";
			dao().salvar(a1);

			Autor a2 = new Autor();
			a2.nome = "Joãozinho Ferreira";
			dao().salvar(a2);
		}

		String jsp = "";
		String uri = request.getRequestURI();
		if (!uri.endsWith("/"))
			uri += "/";
		if (uri.endsWith("/autor/"))
			jsp = autor(request);
		else if (uri.endsWith("/autor/incluir/"))
			jsp = autorIncluir(request);
		else
			jsp = "/paginas/erro.jsp";
		request.getRequestDispatcher(jsp).forward(request, response);

		PrintWriter out = response.getWriter();
		out.print(uri);

		dao().commit();
	}

	public String autor(HttpServletRequest request) {
		List<Autor> lista = dao().todos(Autor.class);
		request.setAttribute("autores", lista);
		return "/paginas/autor.jsp";
	}

	public String autorIncluir(HttpServletRequest request) {
		Autor autor = new Autor();
		autor.setNome(request.getParameter("nome"));
		dao().salvar(autor);
		request.setAttribute("autor", autor);
		return "/paginas/autor_incluido.jsp";
	}
	
	public String autorAlterar(HttpServletRequest request) {
		Autor autor = new Autor();
		autor.setNome(request.getParameter("nome"));
		dao().salvar(autor);
		request.setAttribute("autor", autor);
		return "/paginas/autor_incluido.jsp";
	}
	
	public String autorExcluir(HttpServletRequest request) {
		dao().excluir(new Long(request.getParameter("id")), Autor.class);
		return "/paginas/autor_excluido.jsp";
	}

}