package org.uqbar.xtrest.api;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Server;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;

/**
 * Main program class
 * This starts an embedded jetty webserver that will be
 * listening for requests and calling you controllers.
 */
@SuppressWarnings("all")
public class XTRest {
  public static Server start(final Class<? extends Handler> controller, final int port) {
    Server _server = new Server(port);
    final Procedure1<Server> _function = new Procedure1<Server>() {
      public void apply(final Server it) {
        try {
          Handler _newInstance = controller.newInstance();
          it.setHandler(_newInstance);
          it.start();
          it.join();
        } catch (Throwable _e) {
          throw Exceptions.sneakyThrow(_e);
        }
      }
    };
    return ObjectExtensions.<Server>operator_doubleArrow(_server, _function);
  }
}
