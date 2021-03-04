/**
 * @name HTML template escaping passthrough
 * @description If a user-provided value is converted to a special type that avoids escaping when fed into a HTML
 *              template, it may result in XSS.
 * @kind path-problem
 * @problem.severity warning
 * @id go/html-template-escaping-passthrough
 * @tags security
 *       external/cwe/cwe-79
 */

import go
import DataFlow::PathGraph

/**
 * Holds if the provided src node flows into a conversion to a PassthroughType.
 */
predicate isConvertedToPassthroughType(
  DataFlow::Node src, string targetType, DataFlow::PathNode conversionSink
) {
  exists(ConversionFlowToPassthroughTypeConf cfg, DataFlow::PathNode source |
    cfg.hasFlowPath(source, conversionSink) and
    source.getNode() = src and
    targetType = cfg.getDstTypeName()
  )
}

/**
 * Gets the names of the types that will not be escaped when passed to
 * a `html/template` template.
 */
string getAPassthroughTypeName() {
  result = ["HTML", "HTMLAttr", "JS", "JSStr", "CSS", "Srcset", "URL"]
}

/**
 * A taint-tracking configuration for reasoning about when an UntrustedFlowSource
 * is converted into a special type which will not be escaped by the template generator;
 * this allows the injection of arbitrary content (html, css, js) into the generated
 * output of the templates.
 */
class ConversionFlowToPassthroughTypeConf extends TaintTracking::Configuration {
  string dstTypeName;

  ConversionFlowToPassthroughTypeConf() {
    dstTypeName = getAPassthroughTypeName() and
    this = "UnsafeConversion" + dstTypeName
  }

  string getDstTypeName() { result = dstTypeName }

  override predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  predicate isSinkToPassthroughType(DataFlow::TypeCastNode sink, string name) {
    exists(Type typ |
      typ = sink.getResultType() and
      typ.getUnderlyingType*().hasQualifiedName("html/template", name) and
      name = getAPassthroughTypeName()
    )
  }

  override predicate isSink(DataFlow::Node sink) { isSinkToPassthroughType(sink, dstTypeName) }
}

/**
 * Holds if the the sink is a data value argument of a template execution call.
 */
predicate isSinkToTemplateExec(DataFlow::Node sink, DataFlow::CallNode call) {
  exists(Method fn, string methodName |
    fn.hasQualifiedName("html/template", "Template", methodName) and
    call = fn.getACall()
  |
    methodName = "Execute" and sink = call.getArgument(1)
    or
    methodName = "ExecuteTemplate" and sink = call.getArgument(2)
  )
}

/**
 * A taint-tracking configuration for reasoning about when an UntrustedFlowSource
 * flows into a template executor call.
 */
class TemplateExecutionFlowConf extends TaintTracking::Configuration {
  TemplateExecutionFlowConf() { this = "TemplateExecutionFlowConf" }

  override predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  override predicate isSink(DataFlow::Node sink) { isSinkToTemplateExec(sink, _) }
}

from
  TemplateExecutionFlowConf cfg, DataFlow::PathNode source, DataFlow::PathNode sink,
  string targetTypeName, DataFlow::PathNode conversionSink
where
  cfg.hasFlowPath(source, sink) and
  isConvertedToPassthroughType(source.getNode(), targetTypeName, conversionSink)
select sink.getNode(), source, sink,
  "Data from an $@ will not be auto-escaped because it was $@ to template." + targetTypeName,
  source.getNode(), "untrusted source", conversionSink.getNode(), "converted"
