package org.uqbar.xtrest.result;

import java.io.PrintWriter;
import javax.servlet.http.HttpServletResponse;
import org.eclipse.jetty.server.handler.AbstractHandler;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.uqbar.xtrest.result.ResultCombinators;

/**
 * Utility methods for creating HTTP results
 * 
 * @author jfernandes
 */
@SuppressWarnings("all")
public abstract class ResultFactory extends AbstractHandler {
  public static Procedure1<? super HttpServletResponse> ok() {
    final Procedure1<HttpServletResponse> _function = new Procedure1<HttpServletResponse>() {
      public void apply(final HttpServletResponse it) {
        it.setStatus(HttpServletResponse.SC_OK);
      }
    };
    return ResultCombinators.result(_function);
  }
  
  public static Procedure1<? super HttpServletResponse> ok(final String content) {
    Procedure1<? super HttpServletResponse> _ok = ResultFactory.ok();
    final Procedure1<HttpServletResponse> _function = new Procedure1<HttpServletResponse>() {
      public void apply(final HttpServletResponse it) {
        try {
          PrintWriter _writer = it.getWriter();
          _writer.write(content);
        } catch (Throwable _e) {
          throw Exceptions.sneakyThrow(_e);
        }
      }
    };
    return ResultCombinators.operator_doubleGreaterThan(_ok, _function);
  }
  
  public static Procedure1<? super HttpServletResponse> forbidden() {
    final Procedure1<HttpServletResponse> _function = new Procedure1<HttpServletResponse>() {
      public void apply(final HttpServletResponse it) {
        it.setStatus(HttpServletResponse.SC_FORBIDDEN);
      }
    };
    return ResultCombinators.result(_function);
  }
  
  public static Procedure1<? super HttpServletResponse> forbidden(final String content) {
    Procedure1<? super HttpServletResponse> _forbidden = ResultFactory.forbidden();
    final Procedure1<HttpServletResponse> _function = new Procedure1<HttpServletResponse>() {
      public void apply(final HttpServletResponse it) {
        try {
          PrintWriter _writer = it.getWriter();
          _writer.write(content);
        } catch (Throwable _e) {
          throw Exceptions.sneakyThrow(_e);
        }
      }
    };
    return ResultCombinators.operator_doubleGreaterThan(_forbidden, _function);
  }
  
  public static Procedure1<? super HttpServletResponse> notFound() {
    final Procedure1<HttpServletResponse> _function = new Procedure1<HttpServletResponse>() {
      public void apply(final HttpServletResponse it) {
        it.setStatus(HttpServletResponse.SC_NOT_FOUND);
      }
    };
    return ResultCombinators.result(_function);
  }
  
  public static Procedure1<? super HttpServletResponse> notFound(final String content) {
    Procedure1<? super HttpServletResponse> _notFound = ResultFactory.notFound();
    final Procedure1<HttpServletResponse> _function = new Procedure1<HttpServletResponse>() {
      public void apply(final HttpServletResponse it) {
        try {
          PrintWriter _writer = it.getWriter();
          _writer.write(content);
        } catch (Throwable _e) {
          throw Exceptions.sneakyThrow(_e);
        }
      }
    };
    return ResultCombinators.operator_doubleGreaterThan(_notFound, _function);
  }
  
  public static Procedure1<? super HttpServletResponse> internalServerError() {
    final Procedure1<HttpServletResponse> _function = new Procedure1<HttpServletResponse>() {
      public void apply(final HttpServletResponse it) {
        it.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      }
    };
    return ResultCombinators.result(_function);
  }
  
  public static Procedure1<? super HttpServletResponse> internalServerError(final String content) {
    Procedure1<? super HttpServletResponse> _internalServerError = ResultFactory.internalServerError();
    final Procedure1<HttpServletResponse> _function = new Procedure1<HttpServletResponse>() {
      public void apply(final HttpServletResponse it) {
        try {
          PrintWriter _writer = it.getWriter();
          _writer.write(content);
        } catch (Throwable _e) {
          throw Exceptions.sneakyThrow(_e);
        }
      }
    };
    return ResultCombinators.operator_doubleGreaterThan(_internalServerError, _function);
  }
}
