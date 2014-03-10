package control.persist;

import model.Aluno;
import model.Autor;
import model.Emprestimo;
import model.Exemplar;
import model.Genero;
import model.Livro;
import model.Turma;

import org.hibernate.SessionFactory;
import org.hibernate.SessionFactoryObserver;
import org.hibernate.cfg.Configuration;
import org.hibernate.service.ServiceRegistry;
import org.hibernate.service.ServiceRegistryBuilder;

public class HibernateUtil {

	private static SessionFactory factory;
	private static ServiceRegistry registry;

	public static SessionFactory getSessionFactory() {
		
		if (factory == null){
			
			Configuration cf = new Configuration();

			registry = new ServiceRegistryBuilder().applySettings(
					cf.getProperties()).buildServiceRegistry();

			cf.setSessionFactoryObserver(new SessionFactoryObserver() {

				private static final long serialVersionUID = 1L;

				@Override
				public void sessionFactoryCreated(SessionFactory arg0) {
					// TODO Auto-generated method stub
				}

				@Override
				public void sessionFactoryClosed(SessionFactory arg0) {
					// TODO Auto-generated method stub
				}
				
			});

			
			cf.addAnnotatedClass(Autor.class);
			cf.addAnnotatedClass(Genero.class);
			cf.addAnnotatedClass(Aluno.class);
			cf.addAnnotatedClass(Turma.class);
			cf.addAnnotatedClass(Livro.class);
			cf.addAnnotatedClass(Exemplar.class);
			cf.addAnnotatedClass(Emprestimo.class);

			factory = cf.buildSessionFactory(registry);
		}
		
		return factory;
	}
}