package org.uqbar.xtrest;

import com.google.common.collect.Lists;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import org.eclipse.xtext.xbase.lib.Pair;
import org.junit.Assert;
import org.junit.Test;
import org.uqbar.xtrest.api.HttpHandlerProcessor;

/**
 * @author jfernandes
 */
@SuppressWarnings("all")
public class UrlPatternTestCase extends Assert {
  private HttpHandlerProcessor processor = new HttpHandlerProcessor();
  
  @Test
  public void testSimpleUrlWithoutVariables() {
    Pair<String, ArrayList<String>> regexp = this.processor.createRegexp("/libros");
    Pair<String, List<Object>> _mappedTo = Pair.<String, List<Object>>of("/libros", Collections.<Object>unmodifiableList(Lists.<Object>newArrayList()));
    Assert.assertEquals(_mappedTo, regexp);
    String _key = regexp.getKey();
    boolean _matches = _key.matches("/libros");
    Assert.assertTrue(_matches);
  }
  
  @Test
  public void testOneVar() {
    Pair<String, ArrayList<String>> regexp = this.processor.createRegexp("/libros/:id");
    Pair<String, List<String>> _mappedTo = Pair.<String, List<String>>of("\\\\/libros\\\\/(\\\\w+)", Collections.<String>unmodifiableList(Lists.<String>newArrayList("id")));
    Assert.assertEquals(_mappedTo, regexp);
    String _key = regexp.getKey();
    boolean _matches = _key.matches("/libros/2");
    Assert.assertTrue(_matches);
  }
}
