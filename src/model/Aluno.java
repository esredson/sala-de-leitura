package model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import control.persist.Modelo;

@Entity
public class Aluno extends Modelo<Aluno> {

	public Turma getTurma() {
		return turma;
	}

	public void setTurma(Turma turma) {
		this.turma = turma;
	}

	static {
		int a = 0;
	}

	private String nome;

	private String matricula;

	@ManyToOne()
	private Turma turma;

	public String getMatricula() {
		return matricula;
	}

	public void setMatricula(String matricula) {
		this.matricula = matricula;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public String getResumo() {
		return getNome() + " (nº " + matricula + " da " + getTurma().getNome() + ")";
	}

}
