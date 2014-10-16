package org.uqbar.xtrest.result;

import javax.servlet.http.HttpServletResponse;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;

/**
 * @author jfernandes
 */
@SuppressWarnings("all")
public class ResultCombinators {
  public static Procedure1<? super HttpServletResponse> operator_doubleGreaterThan(final Procedure1<? super HttpServletResponse> one, final Procedure1<? super HttpServletResponse> then) {
    final Procedure1<HttpServletResponse> _function = new Procedure1<HttpServletResponse>() {
      public void apply(final HttpServletResponse r) {
        one.apply(r);
        then.apply(r);
      }
    };
    return _function;
  }
  
  public static Procedure1<? super HttpServletResponse> result(final Procedure1<? super HttpServletResponse> responseConfigurer) {
    return responseConfigurer;
  }
}
