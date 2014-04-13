package control;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Aluno;
import model.Autor;
import model.Emprestimo;
import model.Exemplar;
import model.Genero;
import model.Livro;
import model.Turma;
import control.persist.Modelo;

public class Servlet extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		try {
			if (new Autor().buscar().size() == 0) {

				Autor a1 = new Autor();
				a1.setNome("Pedrinho de Souza");
				a1.salvar();

				Autor a2 = new Autor();
				a2.setNome("Joãozinho Ferreira");
				a2.salvar();

				Autor a3 = new Autor();
				a3.setNome("Jopilandro Silva");
				a3.salvar();

				Autor a4 = new Autor();
				a4.setNome("Pedrovaldo Lima");
				a4.salvar();

				Autor a5 = new Autor();
				a5.setNome("Jurandi");
				a5.salvar();

				Genero g1 = new Genero();
				g1.setNome("Romance");
				g1.salvar();

				Genero g2 = new Genero();
				g2.setNome("Ficcao");
				g2.salvar();

				Turma t1 = new Turma();
				t1.setNome("101");
				t1.salvar();

				Aluno aluno1 = new Aluno();
				aluno1.setNome("Jorginho Peralta");
				aluno1.setTurma(t1);
				aluno1.setMatricula("32");
				aluno1.salvar();

				Livro l = new Livro();
				l.setNome("O Gato Comeu");
				l.setGenero(g2);
				l.setAutor(a1);
				l.salvar();

				Emprestimo e = new Emprestimo();
				e.setExemplar(l.getExemplares().get(0));
				e.setAluno(aluno1);
				try {
					e.setRetirada(new SimpleDateFormat("dd/MM/yyyy")
							.parse("02/04/2012"));
				} catch (Exception ex) {
					ex.printStackTrace();
				}
				e.salvar();

				int a = 0;

			}

			String jsp = "";
			String uri = request.getRequestURI();
			if (!uri.endsWith("/"))
				uri += "/";
			if (uri.endsWith("/autores/"))
				jsp = autorListar(request);
			else if (uri.endsWith("/autor/incluir/"))
				jsp = autorIncluir(request);
			else if (uri.endsWith("/autor/alterar/"))
				jsp = autorAlterar(request);
			else if (uri.endsWith("/autor/excluir/"))
				jsp = autorExcluir(request);
			else if (uri.endsWith("/generos/"))
				jsp = generoListar(request);
			else if (uri.endsWith("/genero/incluir/"))
				jsp = generoIncluir(request);
			else if (uri.endsWith("/genero/alterar/"))
				jsp = generoAlterar(request);
			else if (uri.endsWith("/genero/excluir/"))
				jsp = generoExcluir(request);
			else if (uri.endsWith("/alunos/"))
				jsp = alunoListar(request);
			else if (uri.endsWith("/aluno/incluir/"))
				jsp = alunoIncluir(request);
			else if (uri.endsWith("/aluno/alterar/"))
				jsp = alunoAlterar(request);
			else if (uri.endsWith("/aluno/excluir/"))
				jsp = alunoExcluir(request);
			else if (uri.endsWith("/turmas/"))
				jsp = turmaListar(request);
			else if (uri.endsWith("/turma/incluir/"))
				jsp = turmaIncluir(request);
			else if (uri.endsWith("/turma/alterar/"))
				jsp = turmaAlterar(request);
			else if (uri.endsWith("/turma/excluir/"))
				jsp = turmaExcluir(request);
			else if (uri.endsWith("/livros/"))
				jsp = livroListar(request);
			else if (uri.endsWith("/livro/incluir/"))
				jsp = livroIncluir(request);
			else if (uri.endsWith("/livro/alterar/"))
				jsp = livroAlterar(request);
			else if (uri.endsWith("/livro/excluir/"))
				jsp = livroExcluir(request);
			else if (uri.endsWith("/emprestimos/"))
				jsp = emprestimoListar(request);
			else if (uri.endsWith("/emprestimo/incluir/"))
				jsp = emprestimoIncluir(request);
			else if (uri.endsWith("/emprestimo/alterar/"))
				jsp = emprestimoAlterar(request);
			else if (uri.endsWith("/emprestimo/excluir/"))
				jsp = emprestimoExcluir(request);
			else
				jsp = "/paginas/erro.jsp";
			request.getRequestDispatcher(jsp).forward(request, response);

			PrintWriter out = response.getWriter();
			out.print(uri);
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.setContentType("text/plain;charset=UTF-8");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write(e.getMessage());	
		}
	}

	public String autorListar(HttpServletRequest request) {
		List<Autor> lista = new Autor().buscar();
		request.setAttribute("autores", lista);
		return "/paginas/autores.jsp";
	}

	public String autorIncluir(HttpServletRequest request) throws Exception {
		Autor autor = new Autor();
		autor.setNome(request.getParameter("nome"));
		autor.salvar();
		request.setAttribute("autor", autor);
		return "/paginas/autor_incluido.jsp";
	}

	public String autorAlterar(HttpServletRequest request) throws Exception {
		Autor autor = new Autor().setId(
				Long.valueOf(request.getParameter("id"))).buscarUm();
		autor.setNome(request.getParameter("nome"));
		autor.salvar();
		request.setAttribute("autor", autor);
		return "/paginas/autor_incluido.jsp";
	}

	public String autorExcluir(HttpServletRequest request) {
		Long id = new Long(request.getParameter("id"));
		Autor autor = new Autor().setId(
				Long.valueOf(request.getParameter("id"))).buscarUm();
		autor.excluir();
		request.setAttribute("id", id);
		return "/paginas/autor_excluido.jsp";
	}

	public String generoListar(HttpServletRequest request) {
		List<Genero> lista = new Genero().buscar();
		request.setAttribute("generos", lista);
		return "/paginas/generos.jsp";
	}

	public String generoIncluir(HttpServletRequest request) throws Exception{
		Genero genero = new Genero();
		genero.setNome(request.getParameter("nome"));
		genero.salvar();
		request.setAttribute("genero", genero);
		return "/paginas/genero_incluido.jsp";
	}

	public String generoAlterar(HttpServletRequest request) throws Exception{
		Genero genero = new Genero().setId(
				Long.valueOf(request.getParameter("id"))).buscarUm();
		genero.setNome(request.getParameter("nome"));
		genero.salvar();
		request.setAttribute("genero", genero);
		return "/paginas/genero_incluido.jsp";
	}

	public String generoExcluir(HttpServletRequest request)throws Exception {
		Long id = Long.valueOf(request.getParameter("id"));
		new Genero().setId(id).buscarUm().excluir();
		request.setAttribute("id", id);
		return "/paginas/genero_excluido.jsp";
	}

	public String alunoListar(HttpServletRequest request) {
		List<Aluno> lista = new Aluno().buscar();
		request.setAttribute("alunos", lista);
		List<Turma> listaTurmas = new Turma().buscar();
		request.setAttribute("turmas", listaTurmas);
		return "/paginas/alunos.jsp";
	}

	public String alunoIncluir(HttpServletRequest request) throws Exception {
		Aluno aluno = new Aluno();
		aluno.setNome(request.getParameter("nome"));
		aluno.setMatricula(request.getParameter("matricula"));
		aluno.setTurma(new Turma().setId(
				Long.valueOf(request.getParameter("turma"))).buscarUm());
		aluno.salvar();
		request.setAttribute("aluno", aluno);
		return "/paginas/aluno_incluido.jsp";
	}

	public String alunoAlterar(HttpServletRequest request) throws Exception {
		Aluno aluno = new Aluno().setId(
				Long.valueOf(request.getParameter("id"))).buscarUm();
		aluno.setNome(request.getParameter("nome"));
		aluno.setMatricula(request.getParameter("matricula"));
		Turma t = new Turma()
				.setId(Long.valueOf(request.getParameter("turma"))).buscarUm();
		aluno.setTurma(t);
		aluno.salvar();
		request.setAttribute("aluno", aluno);
		return "/paginas/aluno_incluido.jsp";
	}

	public String alunoExcluir(HttpServletRequest request) {
		Long id = new Long(request.getParameter("id"));
		new Aluno().setId(id).buscarUm().excluir();
		request.setAttribute("id", id);
		return "/paginas/aluno_excluido.jsp";
	}

	public String turmaListar(HttpServletRequest request) {
		List<Turma> lista = new Turma().buscar();
		request.setAttribute("turmas", lista);
		return "/paginas/turmas.jsp";
	}

	public String turmaIncluir(HttpServletRequest request) throws Exception {
		Turma turma = new Turma();
		turma.setNome(request.getParameter("nome"));
		turma.salvar();
		request.setAttribute("turma", turma);
		return "/paginas/turma_incluido.jsp";
	}

	public String turmaAlterar(HttpServletRequest request) throws Exception {
		Turma turma = new Turma().setId(
				Long.valueOf(request.getParameter("id"))).buscarUm();
		turma.setNome(request.getParameter("nome"));
		turma.salvar();
		request.setAttribute("turma", turma);
		return "/paginas/turma_incluido.jsp";
	}

	public String turmaExcluir(HttpServletRequest request) {
		Long id = new Long(request.getParameter("id"));
		new Turma().setId(id).buscarUm().excluir();
		request.setAttribute("id", id);
		return "/paginas/turma_excluida.jsp";
	}

	public String livroListar(HttpServletRequest request) {
		List<Livro> lista = new Livro().buscar();
		request.setAttribute("livros", lista);
		List<Autor> listaAutores = new Autor().buscar();
		request.setAttribute("autores", listaAutores);
		List<Genero> listaGeneros = new Genero().buscar();
		request.setAttribute("generos", listaGeneros);
		return "/paginas/livros.jsp";
	}

	public String livroIncluir(HttpServletRequest request) throws Exception {
		Livro livro = new Livro();
		livro.setNome(request.getParameter("nome"));
		livro.setGenero(new Genero().setId(
				Long.valueOf(request.getParameter("genero"))).buscarUm());
		livro.setAutor(new Autor().setId(
				Long.valueOf(request.getParameter("autor"))).buscarUm());
		livro.salvar(Long.valueOf(request.getParameter("exemplares")));
		request.setAttribute("livro", livro);
		return "/paginas/livro_incluido.jsp";
	}

	public String livroAlterar(HttpServletRequest request) throws Exception {
		Livro livro = new Livro().setId(
				Long.valueOf(request.getParameter("id"))).buscarUm();
		livro.setNome(request.getParameter("nome"));
		livro.setGenero(new Genero().setId(
				Long.valueOf(request.getParameter("genero"))).buscarUm());
		livro.setAutor(new Autor().setId(
				Long.valueOf(request.getParameter("autor"))).buscarUm());
		livro.salvar(Long.valueOf(request.getParameter("exemplares")));
		request.setAttribute("livro", livro);
		return "/paginas/livro_incluido.jsp";
	}

	public String livroExcluir(HttpServletRequest request) {
		Long id = new Long(request.getParameter("id"));
		new Livro().setId(id).buscarUm().excluir();
		request.setAttribute("id", id);
		return "/paginas/livro_excluido.jsp";
	}

	public String emprestimoListar(HttpServletRequest request) {
		List<Emprestimo> lista = new Emprestimo().buscar();
		request.setAttribute("emprestimos", lista);
		List<Exemplar> listaLivros = new Exemplar().buscar();
		request.setAttribute("exemplares", listaLivros);
		List<Aluno> listaAlunos = new Aluno().buscar();
		request.setAttribute("alunos", listaAlunos);
		return "/paginas/emprestimos.jsp";
	}

	public String emprestimoIncluir(HttpServletRequest request) throws Exception {
		Emprestimo emprestimo = new Emprestimo();
		try {
			emprestimo.setRetirada(new SimpleDateFormat("dd/MM/yyyy")
					.parse(request.getParameter("retirada")));
		} catch (Exception e) {
			int b = 9;
		}
		try {
			emprestimo.setDevolucao(new SimpleDateFormat("dd/MM/yyyy")
					.parse(request.getParameter("devolucao")));
		} catch (Exception e) {
			int c = 10;
		}
		emprestimo.setAluno(new Aluno().setId(
				Long.valueOf(request.getParameter("aluno"))).buscarUm());
		emprestimo.setExemplar(new Exemplar().setId(
				Long.valueOf(request.getParameter("exemplar"))).buscarUm());
		emprestimo.salvar();
		request.setAttribute("emprestimo", emprestimo);
		return "/paginas/emprestimo_incluido.jsp";
	}

	public String emprestimoAlterar(HttpServletRequest request) throws Exception {
		Emprestimo emprestimo = new Emprestimo().setId(
				Long.valueOf(request.getParameter("id"))).buscarUm();
		try {
			emprestimo.setRetirada(new SimpleDateFormat("dd/MM/yyyy")
					.parse(request.getParameter("retirada")));
		} catch (Exception e) {

		}
		try {
			emprestimo.setDevolucao(new SimpleDateFormat("dd/MM/yyyy")
					.parse(request.getParameter("devolucao")));
		} catch (Exception e) {

		}
		emprestimo.setAluno(new Aluno().setId(
				Long.valueOf(request.getParameter("aluno"))).buscarUm());
		emprestimo.setExemplar(new Exemplar().setId(
				Long.valueOf(request.getParameter("exemplar"))).buscarUm());
		emprestimo.salvar();
		request.setAttribute("emprestimo", emprestimo);
		return "/paginas/emprestimo_incluido.jsp";
	}

	public String emprestimoExcluir(HttpServletRequest request) {
		Long id = new Long(request.getParameter("id"));
		new Emprestimo().setId(id).buscarUm().excluir();
		request.setAttribute("id", id);
		return "/paginas/emprestimo_excluido.jsp";
	}

}