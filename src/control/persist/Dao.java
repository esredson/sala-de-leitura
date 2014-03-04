package control.persist;

import java.io.Serializable;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

public class Dao {

	Session session = null;
	Transaction transaction = null;

	public Dao() { // constructor
		session = HibernateUtil.getSessionFactory().openSession();
	}

	public List todos(Class clazz) {
		return session.createCriteria(clazz).list();
	}
	
	public Object salvar(Object o){
		session.saveOrUpdate(o);
		return o;
	}
	
	public Object porId(Class clazz, Long id){
		return session.load(clazz, id);
	}
	
	public void excluir(Long id, Class clazz){
		Object o = session.load(clazz, id);
		session.delete(o);
	}
	
	public void transacao(){
		transaction = session.beginTransaction();
	}
	
	public void commit(){
		transaction.commit();
	}

}
