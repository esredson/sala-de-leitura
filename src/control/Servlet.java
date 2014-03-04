package control;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Aluno;
import model.Autor;
import model.Genero;
import model.Turma;
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

			Autor a0 = new Autor();
			dao().salvar(a0);
			dao().excluir(a0.getId(), Autor.class);

			Autor a00 = new Autor();
			dao().salvar(a00);
			dao().excluir(a00.getId(), Autor.class);

			Autor a000 = new Autor();
			dao().salvar(a000);
			dao().excluir(a000.getId(), Autor.class);

			Autor a1 = new Autor();
			a1.setNome("Pedrinho de Souza");
			dao().salvar(a1);

			Autor a2 = new Autor();
			a2.setNome("Joãozinho Ferreira");
			dao().salvar(a2);

			Genero g1 = new Genero();
			g1.setNome("Romance");
			dao().salvar(g1);

			Genero g2 = new Genero();
			g2.setNome("Ficcao");
			dao().salvar(g2);

			Turma t1 = new Turma();
			t1.setNome("101");
			dao().salvar(t1);

			Aluno aluno1 = new Aluno();
			aluno1.setNome("Zezinho Peralta");
			aluno1.setTurma(t1);
			aluno1.setMatricula("32");
			dao().salvar(aluno1);

			int a = 0;

		}

		String jsp = "";
		String uri = request.getRequestURI();
		if (!uri.endsWith("/"))
			uri += "/";
		if (uri.endsWith("/autor/"))
			jsp = autor(request);
		else if (uri.endsWith("/autor/incluir/"))
			jsp = autorIncluir(request);
		else if (uri.endsWith("/autor/alterar/"))
			jsp = autorAlterar(request);
		else if (uri.endsWith("/autor/excluir/"))
			jsp = autorExcluir(request);
		else if (uri.endsWith("/genero/"))
			jsp = genero(request);
		else if (uri.endsWith("/genero/incluir/"))
			jsp = generoIncluir(request);
		else if (uri.endsWith("/genero/alterar/"))
			jsp = generoAlterar(request);
		else if (uri.endsWith("/genero/excluir/"))
			jsp = generoExcluir(request);
		else if (uri.endsWith("/aluno/"))
			jsp = aluno(request);
		else if (uri.endsWith("/aluno/incluir/"))
			jsp = alunoIncluir(request);
		else if (uri.endsWith("/aluno/alterar/"))
			jsp = alunoAlterar(request);
		else if (uri.endsWith("/aluno/excluir/"))
			jsp = alunoExcluir(request);
		else if (uri.endsWith("/turma/"))
			jsp = turma(request);
		else if (uri.endsWith("/turma/incluir/"))
			jsp = turmaIncluir(request);
		else if (uri.endsWith("/turma/alterar/"))
			jsp = turmaAlterar(request);
		else if (uri.endsWith("/turma/excluir/"))
			jsp = turmaExcluir(request);
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
		Autor autor = (Autor) dao().porId(Autor.class,
				Long.valueOf(request.getParameter("id")));
		autor.setNome(request.getParameter("nome"));
		dao().salvar(autor);
		request.setAttribute("autor", autor);
		return "/paginas/autor_incluido.jsp";
	}

	public String autorExcluir(HttpServletRequest request) {
		Long id = new Long(request.getParameter("id"));
		dao().excluir(id, Autor.class);
		request.setAttribute("id", id);
		return "/paginas/autor_excluido.jsp";
	}

	public String genero(HttpServletRequest request) {
		List<Genero> lista = dao().todos(Genero.class);
		request.setAttribute("generos", lista);
		return "/paginas/genero.jsp";
	}

	public String generoIncluir(HttpServletRequest request) {
		Genero genero = new Genero();
		genero.setNome(request.getParameter("nome"));
		dao().salvar(genero);
		request.setAttribute("genero", genero);
		return "/paginas/genero_incluido.jsp";
	}

	public String generoAlterar(HttpServletRequest request) {
		Genero genero = (Genero) dao().porId(Genero.class,
				Long.valueOf(request.getParameter("id")));
		genero.setNome(request.getParameter("nome"));
		dao().salvar(genero);
		request.setAttribute("genero", genero);
		return "/paginas/genero_incluido.jsp";
	}

	public String generoExcluir(HttpServletRequest request) {
		Long id = new Long(request.getParameter("id"));
		dao().excluir(id, Genero.class);
		request.setAttribute("id", id);
		return "/paginas/genero_excluido.jsp";
	}

	public String aluno(HttpServletRequest request) {
		List<Aluno> lista = dao().todos(Aluno.class);
		request.setAttribute("alunos", lista);
		List<Turma> listaTurmas = dao().todos(Turma.class);
		request.setAttribute("turmas", listaTurmas);
		return "/paginas/aluno.jsp";
	}

	public String alunoIncluir(HttpServletRequest request) {
		Aluno aluno = new Aluno();
		aluno.setNome(request.getParameter("nome"));
		aluno.setMatricula(request.getParameter("matricula"));
		Turma t = (Turma) dao().porId(Turma.class,
				Long.valueOf(request.getParameter("turma")));
		aluno.setTurma(t);
		dao().salvar(aluno);
		request.setAttribute("aluno", aluno);
		return "/paginas/aluno_incluido.jsp";
	}

	public String alunoAlterar(HttpServletRequest request) {
		Aluno aluno = (Aluno) dao().porId(Aluno.class,
				Long.valueOf(request.getParameter("id")));
		aluno.setNome(request.getParameter("nome"));
		aluno.setMatricula(request.getParameter("matricula"));
		Turma t = (Turma) dao().porId(Turma.class,
				Long.valueOf(request.getParameter("turma")));
		aluno.setTurma(t);
		dao().salvar(aluno);
		request.setAttribute("aluno", aluno);
		return "/paginas/aluno_incluido.jsp";
	}

	public String alunoExcluir(HttpServletRequest request) {
		Long id = new Long(request.getParameter("id"));
		dao().excluir(id, Aluno.class);
		request.setAttribute("id", id);
		return "/paginas/aluno_excluido.jsp";
	}

	public String turma(HttpServletRequest request) {
		List<Turma> lista = dao().todos(Turma.class);
		request.setAttribute("turmas", lista);
		return "/paginas/turma.jsp";
	}

	public String turmaIncluir(HttpServletRequest request) {
		Turma turma = new Turma();
		turma.setNome(request.getParameter("nome"));
		dao().salvar(turma);
		request.setAttribute("turma", turma);
		return "/paginas/turma_incluido.jsp";
	}

	public String turmaAlterar(HttpServletRequest request) {
		Turma turma = (Turma) dao().porId(Turma.class,
				Long.valueOf(request.getParameter("id")));
		turma.setNome(request.getParameter("nome"));
		dao().salvar(turma);
		request.setAttribute("turma", turma);
		return "/paginas/turma_incluido.jsp";
	}

	public String turmaExcluir(HttpServletRequest request) {
		Long id = new Long(request.getParameter("id"));
		dao().excluir(id, Turma.class);
		request.setAttribute("id", id);
		return "/paginas/turma_excluida.jsp";
	}

}