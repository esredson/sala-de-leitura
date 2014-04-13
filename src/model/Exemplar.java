package model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;

import control.persist.Modelo;

@Entity
public class Exemplar extends Modelo<Exemplar> {

	private Long sequencial;

	@ManyToOne
	private Livro livro;

	@OneToMany(mappedBy = "exemplar", cascade = CascadeType.REMOVE)
	private List<Emprestimo> emprestimos;

	public List<Emprestimo> getEmprestimos() {
		if (emprestimos == null)
			emprestimos = new ArrayList<Emprestimo>();
		return emprestimos;
	}

	public void setEmprestimos(List<Emprestimo> emprestimos) {
		this.emprestimos = emprestimos;
	}

	public Long getSequencial() {
		return sequencial;
	}

	public void setSequencial(Long sequencial) {
		this.sequencial = sequencial;
	}

	public Livro getLivro() {
		return livro;
	}

	public void setLivro(Livro livro) {
		this.livro = livro;
	}

	@Override
	public void salvar() throws Exception{
		if (getSequencial() == null)
			setSequencial((long) getLivro().getExemplares().size() + 1);

		super.salvar();
	}

	@Override
	public void excluir() {
		super.excluir();
		getLivro().getExemplares().remove(this);
	}

	public String getResumo() {
		return getLivro().getNome()
				+ (getLivro().getNumExemplares() > 1 ? " #" + sequencial : "");
	}

	public boolean isEmprestado() {
		for (Emprestimo e : getEmprestimos()) {
			if (e.getDevolucao() == null || e.getDevolucao().after(new Date()))
				return true;
		}
		return false;
	}

}
