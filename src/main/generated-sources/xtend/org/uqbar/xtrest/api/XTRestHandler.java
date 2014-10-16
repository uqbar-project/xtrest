package org.uqbar.xtrest.api;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.server.handler.AbstractHandler;

/**
 * Adapts a controller against jetty expected
 * HttpHandler interface
 * 
 * @author jfernandes
 */
@SuppressWarnings("all")
public class XTRestHandler extends AbstractHandler {
  public void handle(final String target, final Request baseRequest, final HttpServletRequest request, final HttpServletResponse response) throws IOException, ServletException {
  }
}
