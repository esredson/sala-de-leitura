package model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import control.persist.Modelo;

@Entity
public class Genero extends Modelo<Genero> {

	static {
		int a = 0;
	}

    private String nome;

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}
    
	
}
