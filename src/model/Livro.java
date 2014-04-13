package model;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Transient;

import control.persist.Modelo;

@Entity
public class Livro extends Modelo<Livro> {

	static {
		int a = 0;
	}

	private String nome;

	@ManyToOne()
	private Autor autor;

	@ManyToOne()
	private Genero genero;

	@OneToMany(mappedBy = "livro", cascade = CascadeType.REMOVE)
	private List<Exemplar> exemplares;

	public Autor getAutor() {
		return autor;
	}

	public void setAutor(Autor autor) {
		this.autor = autor;
	}

	public Genero getGenero() {
		return genero;
	}

	public void setGenero(Genero genero) {
		this.genero = genero;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	@Override
	public void salvar() throws Exception{
		long numJaExistentes = getNumExemplares();
		if (numJaExistentes == 0)
			salvar(1);
		else
			salvar(numJaExistentes);
	}

	public void salvar(long exemplaresASalvar) throws Exception{
		super.salvar();
		int numJaExistentes = getNumExemplares();
		if (exemplaresASalvar <= 0)
			exemplaresASalvar = 1;
		if (exemplaresASalvar < numJaExistentes) {
			for (int i = numJaExistentes - 1; i >= exemplaresASalvar; i--) {
				getExemplares().get(i).excluir();
				//getExemplares().remove(i);
			}
		} else if (exemplaresASalvar > numJaExistentes) {
			for (int i = 0; i < exemplaresASalvar - numJaExistentes; i++) {
				Exemplar exemplar = new Exemplar();
				exemplar.setLivro(this);
				exemplar.salvar();
				getExemplares().add(exemplar);
			}
		}
	}

	public List<Exemplar> getExemplares() {
		if (exemplares == null)
			exemplares = new ArrayList<Exemplar>();
		return exemplares;
	}

	public void setExemplares(List<Exemplar> exemplares) {
		this.exemplares = exemplares;
	}
	
	public int getNumExemplares(){
		return getExemplares().size();
	}

	public String getStatus() {
		int nExemplares = 0;
		String nExemplaresString = "";
		nExemplares = getNumExemplares();
		nExemplaresString = nExemplares
				+ (nExemplares == 1 ? " exemplar; " : " exemplares; ");

		int nEmprestados = 0;
		String nEmprestadosString = "";
		for (Exemplar e : getExemplares())
			if (e.isEmprestado())
				nEmprestados++;
		if (nEmprestados == 0)
			nEmprestadosString = "nenhum emprestado";
		else if (nEmprestados == 1)
			nEmprestadosString = "1 emprestado";
		else
			nEmprestadosString = nEmprestados + " emprestados";

		return nExemplaresString + nEmprestadosString;
	}
}
