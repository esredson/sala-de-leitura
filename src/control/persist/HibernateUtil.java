package control.persist;

import model.Autor;

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

			factory = cf.buildSessionFactory(registry);
		}
		
		return factory;
	}
}