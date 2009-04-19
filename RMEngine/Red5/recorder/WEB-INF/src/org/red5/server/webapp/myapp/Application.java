package org.red5.server.webapp.myapp;

import org.red5.server.adapter.ApplicationAdapter;

public class Application extends ApplicationAdapter
{
	public double addSomething(double a, double b)
	{
		log.info("adding " + a + " + " + b);
		return a + b;
	}
	

}