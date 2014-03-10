package control;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.hibernate.Transaction;
import org.hibernate.Session;

import control.persist.HibernateUtil;
import control.persist.Modelo;

public class Filter implements javax.servlet.Filter {

	public void doFilter(ServletRequest req, ServletResponse res,
			FilterChain chain) throws IOException, ServletException {
		
		Session session = HibernateUtil.getSessionFactory().openSession();
		Modelo.setSessao(session);
		Transaction transaction = session.beginTransaction();
		
		chain.doFilter(req, res);
		
		transaction.commit();
	}

	public void init(FilterConfig config) throws ServletException {

		// Get init parameter
		String testParam = config.getInitParameter("test-param");

		// Print the init parameter
		System.out.println("Test Param: " + testParam);
	}

	public void destroy() {
		// add code to release any resource
	}
}