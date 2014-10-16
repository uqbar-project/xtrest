package org.uqbar.xtrest.api;

import com.google.common.base.Objects;
import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;
import java.io.IOException;
import java.lang.annotation.Annotation;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.eclipse.jetty.server.Request;
import org.eclipse.xtend.lib.macro.TransformationContext;
import org.eclipse.xtend.lib.macro.TransformationParticipant;
import org.eclipse.xtend.lib.macro.declaration.AnnotationReference;
import org.eclipse.xtend.lib.macro.declaration.CompilationStrategy;
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration;
import org.eclipse.xtend.lib.macro.declaration.MutableMethodDeclaration;
import org.eclipse.xtend.lib.macro.declaration.MutableParameterDeclaration;
import org.eclipse.xtend.lib.macro.declaration.Type;
import org.eclipse.xtend.lib.macro.declaration.TypeReference;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.eclipse.xtext.xbase.lib.Extension;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.ListExtensions;
import org.eclipse.xtext.xbase.lib.Pair;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.uqbar.xtrest.api.Delete;
import org.uqbar.xtrest.api.Get;
import org.uqbar.xtrest.result.ResultFactory;

@SuppressWarnings("all")
public class HttpHandlerProcessor implements TransformationParticipant<MutableClassDeclaration> {
  private final static List<? extends Class<? extends Annotation>> verbs = Collections.<Class<? extends Annotation>>unmodifiableList(Lists.<Class<? extends Annotation>>newArrayList(Get.class, Delete.class));
  
  public void doTransform(final List<? extends MutableClassDeclaration> annotatedTargetElements, @Extension final TransformationContext context) {
    for (final MutableClassDeclaration clazz : annotatedTargetElements) {
      {
        TypeReference _newTypeReference = context.newTypeReference(ResultFactory.class);
        clazz.setExtendedClass(_newTypeReference);
        this.createHandlerMethod(clazz, context);
        this.addParametersToActionMethods(clazz, context);
      }
    }
  }
  
  public void addParametersToActionMethods(final MutableClassDeclaration clazz, @Extension final TransformationContext context) {
    Iterable<MutableMethodDeclaration> _httpMethods = this.httpMethods(clazz, context);
    final Procedure1<MutableMethodDeclaration> _function = new Procedure1<MutableMethodDeclaration>() {
      public void apply(final MutableMethodDeclaration it) {
        ArrayList<String> _variables = HttpHandlerProcessor.this.getVariables(it, context);
        final Procedure1<String> _function = new Procedure1<String>() {
          public void apply(final String v) {
            TypeReference _string = context.getString();
            it.addParameter(v, _string);
          }
        };
        IterableExtensions.<String>forEach(_variables, _function);
        TypeReference _string = context.getString();
        it.addParameter("target", _string);
        TypeReference _newTypeReference = context.newTypeReference(Request.class);
        it.addParameter("baseRequest", _newTypeReference);
        TypeReference _newTypeReference_1 = context.newTypeReference(HttpServletRequest.class);
        it.addParameter("request", _newTypeReference_1);
        TypeReference _newTypeReference_2 = context.newTypeReference(HttpServletResponse.class);
        it.addParameter("response", _newTypeReference_2);
      }
    };
    IterableExtensions.<MutableMethodDeclaration>forEach(_httpMethods, _function);
  }
  
  protected MutableMethodDeclaration createHandlerMethod(final MutableClassDeclaration clazz, @Extension final TransformationContext context) {
    final Procedure1<MutableMethodDeclaration> _function = new Procedure1<MutableMethodDeclaration>() {
      public void apply(final MutableMethodDeclaration it) {
        TypeReference _primitiveVoid = context.getPrimitiveVoid();
        it.setReturnType(_primitiveVoid);
        TypeReference _string = context.getString();
        it.addParameter("target", _string);
        TypeReference _newTypeReference = context.newTypeReference(Request.class);
        it.addParameter("baseRequest", _newTypeReference);
        TypeReference _newTypeReference_1 = context.newTypeReference(HttpServletRequest.class);
        it.addParameter("request", _newTypeReference_1);
        TypeReference _newTypeReference_2 = context.newTypeReference(HttpServletResponse.class);
        it.addParameter("response", _newTypeReference_2);
        TypeReference _newTypeReference_3 = context.newTypeReference(IOException.class);
        TypeReference _newTypeReference_4 = context.newTypeReference(ServletException.class);
        it.setExceptions(_newTypeReference_3, _newTypeReference_4);
        final CompilationStrategy _function = new CompilationStrategy() {
          public CharSequence compile(final CompilationStrategy.CompilationContext it) {
            StringConcatenation _builder = new StringConcatenation();
            {
              Iterable<MutableMethodDeclaration> _httpMethods = HttpHandlerProcessor.this.httpMethods(clazz, context);
              for(final MutableMethodDeclaration m : _httpMethods) {
                _builder.append("{");
                _builder.newLine();
                _builder.append("\t");
                TypeReference _newTypeReference = context.newTypeReference(Matcher.class);
                String _javaCode = it.toJavaCode(_newTypeReference);
                _builder.append(_javaCode, "\t");
                _builder.append(" matcher = ");
                _builder.newLineIfNotEmpty();
                _builder.append("\t\t");
                TypeReference _newTypeReference_1 = context.newTypeReference(Pattern.class);
                String _javaCode_1 = it.toJavaCode(_newTypeReference_1);
                _builder.append(_javaCode_1, "\t\t");
                _builder.append(".compile(\"");
                String _pattern = HttpHandlerProcessor.this.getPattern(m, context);
                _builder.append(_pattern, "\t\t");
                _builder.append("\").matcher(target);");
                _builder.newLineIfNotEmpty();
                _builder.append("\t");
                _builder.append("if (request.getMethod().equalsIgnoreCase(\"");
                Type _httpAnnotation = HttpHandlerProcessor.this.httpAnnotation(m, context);
                String _simpleName = _httpAnnotation.getSimpleName();
                _builder.append(_simpleName, "\t");
                _builder.append("\") && matcher.matches()) {");
                _builder.newLineIfNotEmpty();
                _builder.append("\t\t");
                _builder.append("// take parameters from request");
                _builder.newLine();
                _builder.append("\t\t");
                final ArrayList<String> variables = HttpHandlerProcessor.this.getVariables(m, context);
                _builder.newLineIfNotEmpty();
                {
                  Iterable<? extends MutableParameterDeclaration> _httpParameters = HttpHandlerProcessor.this.getHttpParameters(m);
                  final Function1<MutableParameterDeclaration, Boolean> _function = new Function1<MutableParameterDeclaration, Boolean>() {
                    public Boolean apply(final MutableParameterDeclaration it) {
                      String _simpleName = it.getSimpleName();
                      boolean _contains = variables.contains(_simpleName);
                      return Boolean.valueOf((!_contains));
                    }
                  };
                  Iterable<? extends MutableParameterDeclaration> _filter = IterableExtensions.filter(_httpParameters, _function);
                  for(final MutableParameterDeclaration p : _filter) {
                    _builder.append("\t\t");
                    _builder.append("String ");
                    String _simpleName_1 = p.getSimpleName();
                    _builder.append(_simpleName_1, "\t\t");
                    _builder.append(" = request.getParameter(\"");
                    String _simpleName_2 = p.getSimpleName();
                    _builder.append(_simpleName_2, "\t\t");
                    _builder.append("\");");
                    _builder.newLineIfNotEmpty();
                  }
                }
                _builder.append("\t\t");
                _builder.newLine();
                _builder.append("\t\t");
                _builder.append("// take variables from url");
                _builder.newLine();
                _builder.append("\t\t");
                int i = 0;
                _builder.newLineIfNotEmpty();
                {
                  for(final String v : variables) {
                    _builder.append("\t\t");
                    _builder.append("String ");
                    _builder.append(v, "\t\t");
                    _builder.append(" = matcher.group(");
                    int _i = i = (i + 1);
                    _builder.append(_i, "\t\t");
                    _builder.append(");");
                    _builder.newLineIfNotEmpty();
                  }
                }
                _builder.append("\t\t");
                _builder.newLine();
                _builder.append("\t\t");
                _builder.newLine();
                _builder.append("\t    ");
                _builder.append("Procedure1<? super HttpServletResponse> result = ");
                String _simpleName_3 = m.getSimpleName();
                _builder.append(_simpleName_3, "\t    ");
                _builder.append("(");
                Iterable<? extends MutableParameterDeclaration> _httpParameters_1 = HttpHandlerProcessor.this.getHttpParameters(m);
                final Function1<MutableParameterDeclaration, Boolean> _function_1 = new Function1<MutableParameterDeclaration, Boolean>() {
                  public Boolean apply(final MutableParameterDeclaration it) {
                    String _simpleName = it.getSimpleName();
                    boolean _contains = variables.contains(_simpleName);
                    return Boolean.valueOf((!_contains));
                  }
                };
                Iterable<? extends MutableParameterDeclaration> _filter_1 = IterableExtensions.filter(_httpParameters_1, _function_1);
                final Function1<MutableParameterDeclaration, String> _function_2 = new Function1<MutableParameterDeclaration, String>() {
                  public String apply(final MutableParameterDeclaration it) {
                    String _simpleName = it.getSimpleName();
                    return (_simpleName + ", ");
                  }
                };
                Iterable<String> _map = IterableExtensions.map(_filter_1, _function_2);
                String _join = IterableExtensions.join(_map);
                _builder.append(_join, "\t    ");
                final Function1<String, String> _function_3 = new Function1<String, String>() {
                  public String apply(final String it) {
                    return (it + ", ");
                  }
                };
                List<String> _map_1 = ListExtensions.<String, String>map(variables, _function_3);
                String _join_1 = IterableExtensions.join(_map_1);
                _builder.append(_join_1, "\t    ");
                _builder.append("target, baseRequest, request, response);");
                _builder.newLineIfNotEmpty();
                _builder.append("\t    ");
                _builder.append("result.apply(response);");
                _builder.newLine();
                _builder.append("\t    ");
                _builder.newLine();
                _builder.append("\t    ");
                _builder.append("baseRequest.setHandled(true);");
                _builder.newLine();
                _builder.append("\t");
                _builder.append("}");
                _builder.newLine();
                _builder.append("}");
                _builder.newLine();
              }
            }
            return _builder;
          }
        };
        it.setBody(_function);
      }
    };
    return clazz.addMethod("handle", _function);
  }
  
  public Iterable<MutableMethodDeclaration> httpMethods(final MutableClassDeclaration clazz, @Extension final TransformationContext context) {
    Iterable<MutableMethodDeclaration> _xblockexpression = null;
    {
      final Function1<Class<? extends Annotation>, Type> _function = new Function1<Class<? extends Annotation>, Type>() {
        public Type apply(final Class<? extends Annotation> it) {
          return context.findTypeGlobally(it);
        }
      };
      final List<Type> verbAnnotations = ListExtensions.map(HttpHandlerProcessor.verbs, _function);
      final Function1<Type, Iterable<? extends MutableMethodDeclaration>> _function_1 = new Function1<Type, Iterable<? extends MutableMethodDeclaration>>() {
        public Iterable<? extends MutableMethodDeclaration> apply(final Type annotation) {
          Iterable<? extends MutableMethodDeclaration> _declaredMethods = clazz.getDeclaredMethods();
          final Function1<MutableMethodDeclaration, Boolean> _function = new Function1<MutableMethodDeclaration, Boolean>() {
            public Boolean apply(final MutableMethodDeclaration it) {
              AnnotationReference _findAnnotation = it.findAnnotation(annotation);
              Object _value = null;
              if (_findAnnotation!=null) {
                _value=_findAnnotation.getValue("value");
              }
              return Boolean.valueOf((!Objects.equal(_value, null)));
            }
          };
          return IterableExtensions.filter(_declaredMethods, _function);
        }
      };
      List<Iterable<? extends MutableMethodDeclaration>> _map = ListExtensions.<Type, Iterable<? extends MutableMethodDeclaration>>map(verbAnnotations, _function_1);
      _xblockexpression = Iterables.<MutableMethodDeclaration>concat(_map);
    }
    return _xblockexpression;
  }
  
  private final static List<String> ADDED_PARAMETER = Collections.<String>unmodifiableList(Lists.<String>newArrayList("target", "baseRequest", "request", "response"));
  
  public Iterable<? extends MutableParameterDeclaration> getHttpParameters(final MutableMethodDeclaration m) {
    Iterable<? extends MutableParameterDeclaration> _parameters = m.getParameters();
    final Function1<MutableParameterDeclaration, Boolean> _function = new Function1<MutableParameterDeclaration, Boolean>() {
      public Boolean apply(final MutableParameterDeclaration it) {
        String _simpleName = it.getSimpleName();
        boolean _contains = HttpHandlerProcessor.ADDED_PARAMETER.contains(_simpleName);
        return Boolean.valueOf((!_contains));
      }
    };
    return IterableExtensions.filter(_parameters, _function);
  }
  
  private ArrayList<String> getVariables(final MutableMethodDeclaration m, @Extension final TransformationContext context) {
    Type _httpAnnotation = this.httpAnnotation(m, context);
    Pair<String, ArrayList<String>> _variablesAndGroupedPattern = this.getVariablesAndGroupedPattern(m, _httpAnnotation);
    return _variablesAndGroupedPattern.getValue();
  }
  
  private String getPattern(final MutableMethodDeclaration m, @Extension final TransformationContext context) {
    Type _httpAnnotation = this.httpAnnotation(m, context);
    Pair<String, ArrayList<String>> _variablesAndGroupedPattern = this.getVariablesAndGroupedPattern(m, _httpAnnotation);
    return _variablesAndGroupedPattern.getKey();
  }
  
  public Type httpAnnotation(final MutableMethodDeclaration m, @Extension final TransformationContext context) {
    Type _xblockexpression = null;
    {
      final Function1<Class<? extends Annotation>, Type> _function = new Function1<Class<? extends Annotation>, Type>() {
        public Type apply(final Class<? extends Annotation> it) {
          return context.findTypeGlobally(it);
        }
      };
      final List<Type> verbAnnotations = ListExtensions.map(HttpHandlerProcessor.verbs, _function);
      final Function1<Type, Boolean> _function_1 = new Function1<Type, Boolean>() {
        public Boolean apply(final Type it) {
          AnnotationReference _findAnnotation = m.findAnnotation(it);
          return Boolean.valueOf((!Objects.equal(_findAnnotation, null)));
        }
      };
      _xblockexpression = IterableExtensions.<Type>findFirst(verbAnnotations, _function_1);
    }
    return _xblockexpression;
  }
  
  private Pair<String, ArrayList<String>> getVariablesAndGroupedPattern(final MutableMethodDeclaration m, final Type annotationType) {
    Pair<String, ArrayList<String>> _xblockexpression = null;
    {
      AnnotationReference _findAnnotation = m.findAnnotation(annotationType);
      Object _value = _findAnnotation.getValue("value");
      String pattern = _value.toString();
      _xblockexpression = this.createRegexp(pattern);
    }
    return _xblockexpression;
  }
  
  public Pair<String, ArrayList<String>> createRegexp(final String pattern) {
    Pattern _compile = Pattern.compile("(:\\w+)");
    final Matcher variableMatcher = _compile.matcher(pattern);
    final StringBuilder builder = new StringBuilder();
    int i = 0;
    final ArrayList<String> variables = CollectionLiterals.<String>newArrayList();
    boolean _find = variableMatcher.find();
    boolean _while = _find;
    while (_while) {
      {
        String _group = variableMatcher.group();
        String _substring = _group.substring(1);
        variables.add(_substring);
        int _start = variableMatcher.start();
        String _substring_1 = pattern.substring(i, _start);
        String _replace = _substring_1.replace("/", "\\\\/");
        builder.append(_replace);
        builder.append("(\\\\w+)");
        int _end = variableMatcher.end();
        i = _end;
      }
      boolean _find_1 = variableMatcher.find();
      _while = _find_1;
    }
    int _length = pattern.length();
    boolean _lessThan = (i < _length);
    if (_lessThan) {
      int _length_1 = pattern.length();
      String _substring = pattern.substring(i, _length_1);
      builder.append(_substring);
    }
    String _string = builder.toString();
    return Pair.<String, ArrayList<String>>of(_string, variables);
  }
}
