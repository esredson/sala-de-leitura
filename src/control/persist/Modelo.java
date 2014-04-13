package control.persist;

import java.io.Serializable;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.List;

import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;

import org.hibernate.Session;
import org.hibernate.Transaction;

@MappedSuperclass
public class Modelo<T extends Modelo> {

	private static ThreadLocal<Session> session = new ThreadLocal<Session>();
	
	@Id
    @GeneratedValue
    private Long id;
	
	public Long getId() {
		return id;
	}

	public T setId(Long id) {
		this.id = id;
		return (T)this;
	}
	
	public static void setSessao(Session sessao){
		session.set(sessao);
	}
	
	public static Session getSessao(){
		return session.get();
	}

	public List<T> buscar() {
		return session.get().createCriteria(this.getClass()).list();
	}
	
	public T buscarUm(){
		return (T) session.get().load(this.getClass(), getId());
	}
	
	public void salvar() throws Exception{
		session.get().saveOrUpdate(this);
	}
	
	public void excluir(){
		session.get().delete(this);
	}

}
