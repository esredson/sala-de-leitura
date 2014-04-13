package model;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.ManyToOne;

import control.persist.Modelo;

@Entity
public class Emprestimo extends Modelo<Emprestimo> {

	@ManyToOne
	private Exemplar exemplar;

	@ManyToOne
	private Aluno aluno;

	private Date retirada;

	private Date devolucao;

	public Exemplar getExemplar() {
		return exemplar;
	}

	public void setExemplar(Exemplar exemplar) {
		this.exemplar = exemplar;
	}

	public Aluno getAluno() {
		return aluno;
	}

	public void setAluno(Aluno aluno) {
		this.aluno = aluno;
	}

	public Date getRetirada() {
		return retirada;
	}

	public void setRetirada(Date retirada) {
		this.retirada = retirada;
	}

	public Date getDevolucao() {
		return devolucao;
	}

	public void setDevolucao(Date devolucao) {
		this.devolucao = devolucao;
	}

	public String getRetiradaDDMMYYYY() {
		try {
			return new SimpleDateFormat("dd/MM/yyyy").format(getRetirada());
		} catch (Exception e) {
			return "";
		}
	}

	public String getDevolucaoDDMMYYYY() {
		try {
			return new SimpleDateFormat("dd/MM/yyyy").format(getDevolucao());
		} catch (Exception e) {
			return "";
		}
	}

	@Override
	public void salvar() throws Exception{
		if (getRetirada() == null)
			throw new Exception("Data de retirada não pode ser nula");
		if (getDevolucao() != null && getDevolucao().before(getRetirada()))
			throw new Exception("Data de devolução não pode ser anterior à de retirada");
		if (getExemplar().isEmprestado())
			throw new Exception("O exemplar selecionado não está disponível");
		super.salvar();
		List<Emprestimo> emprestimosDoExemplar = getExemplar().getEmprestimos();
		if (!emprestimosDoExemplar.contains(this)) {
			emprestimosDoExemplar.add(this);
		}
	}

}
