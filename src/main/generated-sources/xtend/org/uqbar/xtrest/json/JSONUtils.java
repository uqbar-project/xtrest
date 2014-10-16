package org.uqbar.xtrest.json;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.eclipse.xtext.xbase.lib.Exceptions;

/**
 * Provides JSON utility methods
 * as facade to json libraries.
 * 
 * Also implements them as extension methods
 * so they can be used nicely in your controller class.
 * 
 * @author jfernandes
 */
@SuppressWarnings("all")
public class JSONUtils {
  private ObjectMapper mapper = new ObjectMapper();
  
  public String toJson(final Object obj) {
    try {
      return this.mapper.writeValueAsString(obj);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
}
