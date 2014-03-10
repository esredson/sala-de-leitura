package model;

import java.text.SimpleDateFormat;
import java.util.Date;

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

}
