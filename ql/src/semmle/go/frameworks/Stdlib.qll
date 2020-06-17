/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 */

import go
import semmle.go.frameworks.stdlib.ImportAll

/** A `String()` method. */
class StringMethod extends TaintTracking::FunctionModel, Method {
  StringMethod() { getName() = "String" and getNumParameter() = 0 }

  override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
    inp.isReceiver() and outp.isResult()
  }
}

/**
 * A model of the built-in `append` function, which propagates taint from its arguments to its
 * result.
 */
private class AppendFunction extends TaintTracking::FunctionModel {
  AppendFunction() { this = Builtin::append() }

  override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
    inp.isParameter(_) and outp.isResult()
  }
}

/**
 * A model of the built-in `copy` function, which propagates taint from its second argument
 * to its first.
 */
private class CopyFunction extends TaintTracking::FunctionModel {
  CopyFunction() { this = Builtin::copy() }

  override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
    inp.isParameter(1) and outp.isParameter(0)
  }
}

/** A `Read([]byte) (int, error)` method. */
class ReadMethod extends TaintTracking::FunctionModel, Method {
  ReadMethod() {
    getName() = "Read" and
    getNumParameter() = 1 and
    getNumResult() = 2 and
    getParameterType(0) instanceof ByteSliceType and
    getResultType(0) instanceof IntegerType and
    getResultType(1) = Builtin::error().getType()
  }

  override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
    inp.isReceiver() and outp.isParameter(0)
  }
}

/** A `ReadAt(p []byte, off int64) (n int, err error)` method. */
class ReadAtMethod extends TaintTracking::FunctionModel, Method {
  ReadAtMethod() {
    getName() = "ReadAt" and
    getNumParameter() = 2 and
    getNumResult() = 2 and
    getParameterType(0) instanceof ByteSliceType and
    getParameterType(1) instanceof Int64Type and
    getResultType(0) instanceof IntegerType and
    getResultType(1) = Builtin::error().getType()
  }

  override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
    inp.isReceiver() and outp.isParameter(0)
  }
}

/** A `Write([]byte) (int, error)` method. */
class WriteMethod extends TaintTracking::FunctionModel, Method {
  WriteMethod() {
    getName() = "Write" and
    getNumParameter() = 1 and
    getNumResult() = 2 and
    getParameterType(0) instanceof ByteSliceType and
    getResultType(0) instanceof IntegerType and
    getResultType(1) = Builtin::error().getType()
  }

  override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
    inp.isParameter(0) and outp.isReceiver()
  }
}

/** A `WriteAt(p []byte, off int64) (n int, err error)` method. */
class WriteAtMethod extends TaintTracking::FunctionModel, Method {
  WriteAtMethod() {
    getName() = "WriteAt" and
    getNumParameter() = 2 and
    getNumResult() = 2 and
    getParameterType(0) instanceof ByteSliceType and
    getParameterType(1) instanceof Int64Type and
    getResultType(0) instanceof IntegerType and
    getResultType(1) = Builtin::error().getType()
  }

  override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
    inp.isParameter(0) and outp.isReceiver()
  }
}

/** Provides models of commonly used functions in the `path/filepath` package. */
module PathFilePath {
  /** A path-manipulating function in the `path/filepath` package. */
  private class PathManipulatingFunction extends TaintTracking::FunctionModel {
    PathManipulatingFunction() {
      exists(string fn | hasQualifiedName("path/filepath", fn) |
        fn = "Abs" or
        fn = "Base" or
        fn = "Clean" or
        fn = "Dir" or
        fn = "EvalSymlinks" or
        fn = "Ext" or
        fn = "FromSlash" or
        fn = "Glob" or
        fn = "Join" or
        fn = "Rel" or
        fn = "Split" or
        fn = "SplitList" or
        fn = "ToSlash" or
        fn = "VolumeName"
      )
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(_) and
      (outp.isResult() or outp.isResult(_))
    }
  }
}

/** Provides models of commonly used functions in the `bytes` package. */
private module Bytes {
  class Fields extends TaintTracking::FunctionModel {
    Fields() { hasQualifiedName("bytes", ["Fields", "FieldsFunc"]) }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  class Join extends TaintTracking::FunctionModel {
    Join() { hasQualifiedName("bytes", "Join") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(_) and outp.isResult()
    }
  }

  class Map extends TaintTracking::FunctionModel {
    Map() { hasQualifiedName("bytes", "Map") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(1) and outp.isResult()
    }
  }

  class Repeat extends TaintTracking::FunctionModel {
    Repeat() { hasQualifiedName("bytes", "Repeat") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  class Replace extends TaintTracking::FunctionModel {
    Replace() { hasQualifiedName("bytes", ["Replace", "ReplaceAll"]) }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter([0, 2]) and outp.isResult()
    }
  }

  class Runes extends TaintTracking::FunctionModel {
    Runes() { hasQualifiedName("bytes", "Runes") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  class Split extends TaintTracking::FunctionModel {
    Split() { hasQualifiedName("bytes", ["Split", "SplitAfter", "SplitAfterN", "SplitN"]) }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  class AlterCase extends TaintTracking::FunctionModel {
    AlterCase() { hasQualifiedName("bytes", ["Title", "ToLower", "ToTitle", "ToUpper"]) }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  class AlterCaseSpecial extends TaintTracking::FunctionModel {
    AlterCaseSpecial() {
      hasQualifiedName("bytes", ["ToLowerSpecial", "ToTitleSpecial", "ToUpperSpecial"])
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(1) and outp.isResult()
    }
  }

  class ToValidUTF8 extends TaintTracking::FunctionModel {
    ToValidUTF8() { hasQualifiedName("bytes", "ToValidUTF8") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter([0, 1]) and outp.isResult()
    }
  }

  class Trimmers extends TaintTracking::FunctionModel {
    Trimmers() { exists(string split | split.matches("Trim%") | hasQualifiedName("bytes", split)) }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  class NewBuffer extends TaintTracking::FunctionModel {
    NewBuffer() { hasQualifiedName("bytes", ["NewBuffer", "NewBufferString"]) }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  private class BufferBytes extends TaintTracking::FunctionModel, Method {
    BufferBytes() { this.hasQualifiedName("bytes", "Buffer", ["Bytes", "String"]) }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isReceiver() and output.isResult()
    }
  }

  class BufferReadFrom extends TaintTracking::FunctionModel, Method {
    BufferReadFrom() { this.(Method).hasQualifiedName("bytes", "Buffer", "ReadFrom") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isReceiver()
    }
  }

  private string getAReadMethod() {
    result = ["Bytes", "Next", "ReadByte", "ReadBytes", "ReadRune", "ReadString", "String"]
  }

  class ReadMethods extends TaintTracking::FunctionModel, Method {
    ReadMethods() {
      this.(Method).hasQualifiedName("bytes", ["Buffer", "Reader"], getAReadMethod())
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and
      (outp.isResult() or outp.isResult(0))
    }
  }

  class WriteTo extends TaintTracking::FunctionModel, Method {
    WriteTo() { this.(Method).hasQualifiedName("bytes", ["Buffer", "Reader"], "WriteTo") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isParameter(0)
    }
  }

  class NewReader extends TaintTracking::FunctionModel {
    NewReader() { hasQualifiedName("bytes", "NewReader") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  class ReaderRead extends TaintTracking::FunctionModel, Method {
    ReaderRead() { this.(Method).hasQualifiedName("bytes", "Reader", ["Read", "ReadAt"]) }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isParameter(0)
    }
  }

  class ReaderReset extends TaintTracking::FunctionModel, Method {
    ReaderReset() { this.(Method).hasQualifiedName("bytes", "Reader", "Reset") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isReceiver()
    }
  }

  private string getAWriteMethod() { result = ["Write", "WriteByte", "WriteRune", "WriteString"] }

  class WriteMethods extends TaintTracking::FunctionModel, Method {
    WriteMethods() { this.(Method).hasQualifiedName("bytes", "Buffer", getAWriteMethod()) }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isReceiver()
    }
  }
}

/** Provides models of commonly used functions in the `fmt` package. */
module Fmt {
  /** The `Sprint` function or one of its variants. */
  class Sprinter extends TaintTracking::FunctionModel {
    Sprinter() { this.hasQualifiedName("fmt", ["Sprint", "Sprintf", "Sprintln"]) }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(_) and outp.isResult()
    }
  }

  /** The `Print` function or one of its variants. */
  private class Printer extends Function {
    Printer() { this.hasQualifiedName("fmt", ["Print", "Printf", "Println"]) }
  }

  /** A call to `Print`, `Fprint`, or similar. */
  private class PrintCall extends LoggerCall::Range, DataFlow::CallNode {
    PrintCall() { this.getTarget() instanceof Printer or this.getTarget() instanceof Fprinter }

    override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
  }

  /** The `Fprint` function or one of its variants. */
  private class Fprinter extends TaintTracking::FunctionModel {
    Fprinter() { this.hasQualifiedName("fmt", ["Fprint", "Fprintf", "Fprintln"]) }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(any(int i | i > 0)) and output.isParameter(0)
    }
  }

  /** The `Sscan` function or one of its variants. */
  private class Sscanner extends TaintTracking::FunctionModel {
    Sscanner() { this.hasQualifiedName("fmt", ["Sscan", "Sscanf", "Sscanln"]) }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(0) and
      exists(int i | if getName() = "Sscanf" then i > 1 else i > 0 | output.isParameter(i))
    }
  }
}

/** Provides models of commonly used functions in the `io` package. */
module Io {
  private class Copy extends TaintTracking::FunctionModel {
    Copy() {
      // func Copy(dst Writer, src Reader) (written int64, err error)
      // func CopyBuffer(dst Writer, src Reader, buf []byte) (written int64, err error)
      // func CopyN(dst Writer, src Reader, n int64) (written int64, err error)
      hasQualifiedName("io", "Copy") or
      hasQualifiedName("io", "CopyBuffer") or
      hasQualifiedName("io", "CopyN")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(1) and output.isParameter(0)
    }
  }

  private class Pipe extends TaintTracking::FunctionModel {
    Pipe() {
      // func Pipe() (*PipeReader, *PipeWriter)
      hasQualifiedName("io", "Pipe")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isResult(0) and output.isResult(1)
    }
  }

  private class ReadAtLeast extends TaintTracking::FunctionModel {
    ReadAtLeast() {
      // func ReadAtLeast(r Reader, buf []byte, min int) (n int, err error)
      // func ReadFull(r Reader, buf []byte) (n int, err error)
      hasQualifiedName("io", "ReadAtLeast") or
      hasQualifiedName("io", "ReadFull")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(0) and output.isParameter(1)
    }
  }

  private class WriteString extends TaintTracking::FunctionModel {
    WriteString() {
      // func WriteString(w Writer, s string) (n int, err error)
      this.hasQualifiedName("io", "WriteString")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(1) and output.isParameter(0)
    }
  }

  private class ByteReaderReadByte extends TaintTracking::FunctionModel, Method {
    ByteReaderReadByte() {
      // func ReadByte() (byte, error)
      this.implements("io", "ByteReader", "ReadByte")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isReceiver() and output.isResult(0)
    }
  }

  private class ByteWriterWriteByte extends TaintTracking::FunctionModel, Method {
    ByteWriterWriteByte() {
      // func WriteByte(c byte) error
      this.implements("io", "ByteWriter", "WriteByte")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(0) and output.isReceiver()
    }
  }

  private class ReaderRead extends TaintTracking::FunctionModel, Method {
    ReaderRead() {
      // func Read(p []byte) (n int, err error)
      this.implements("io", "Reader", "Read")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isReceiver() and output.isParameter(0)
    }
  }

  private class LimitReader extends TaintTracking::FunctionModel {
    LimitReader() {
      // func LimitReader(r Reader, n int64) Reader
      this.hasQualifiedName("io", "LimitReader")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(0) and output.isResult()
    }
  }

  private class MultiReader extends TaintTracking::FunctionModel {
    MultiReader() {
      // func MultiReader(readers ...Reader) Reader
      this.hasQualifiedName("io", "MultiReader")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(_) and output.isResult()
    }
  }

  private class TeeReader extends TaintTracking::FunctionModel {
    TeeReader() {
      // func TeeReader(r Reader, w Writer) Reader
      this.hasQualifiedName("io", "TeeReader")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(0) and output.isResult()
      or
      input.isParameter(0) and output.isParameter(1)
    }
  }

  private class ReaderAtReadAt extends TaintTracking::FunctionModel, Method {
    ReaderAtReadAt() {
      // func ReadAt(p []byte, off int64) (n int, err error)
      this.implements("io", "ReaderAt", "ReadAt")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isReceiver() and output.isParameter(0)
    }
  }

  private class ReaderFromReadFrom extends TaintTracking::FunctionModel, Method {
    ReaderFromReadFrom() {
      // func ReadFrom(r Reader) (n int64, err error)
      this.implements("io", "ReaderFrom", "ReadFrom")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(0) and output.isReceiver()
    }
  }

  private class RuneReaderReadRune extends TaintTracking::FunctionModel, Method {
    RuneReaderReadRune() {
      // func ReadRune() (r rune, size int, err error)
      this.implements("io", "RuneReader", "ReadRune")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isReceiver() and output.isResult(0)
    }
  }

  private class NewSectionReader extends TaintTracking::FunctionModel {
    NewSectionReader() {
      // func NewSectionReader(r ReaderAt, off int64, n int64) *SectionReader
      this.hasQualifiedName("io", "NewSectionReader")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(0) and output.isResult()
    }
  }

  private class StringWriterWriteString extends TaintTracking::FunctionModel, Method {
    StringWriterWriteString() {
      // func WriteString(s string) (n int, err error)
      this.implements("io", "StringWriter", "WriteString")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(0) and output.isReceiver()
    }
  }

  private class WriterWrite extends TaintTracking::FunctionModel, Method {
    WriterWrite() {
      // func Write(p []byte) (n int, err error)
      this.implements("io", "Writer", "Write")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(0) and output.isReceiver()
    }
  }

  private class MultiWriter extends TaintTracking::FunctionModel {
    MultiWriter() {
      // func MultiWriter(writers ...Writer) Writer
      hasQualifiedName("io", "MultiWriter")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isResult() and output.isParameter(_)
    }
  }

  private class WriterAtWriteAt extends TaintTracking::FunctionModel, Method {
    WriterAtWriteAt() {
      // func WriteAt(p []byte, off int64) (n int, err error)
      this.implements("io", "WriterAt", "WriteAt")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(0) and output.isReceiver()
    }
  }

  private class WriterToWriteTo extends TaintTracking::FunctionModel, Method {
    WriterToWriteTo() {
      // func WriteTo(w Writer) (n int64, err error)
      this.implements("io", "WriterTo", "WriteTo")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isReceiver() and output.isParameter(0)
    }
  }
}

/** Provides models of commonly used functions in the `bufio` package. */
module Bufio {
  class NewScanner extends TaintTracking::FunctionModel {
    NewScanner() { hasQualifiedName("bufio", "NewScanner") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  class ScannerText extends TaintTracking::FunctionModel, Method {
    ScannerText() { this.(Method).hasQualifiedName("bufio", "Scanner", "Text") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }

  class ScannerBytes extends TaintTracking::FunctionModel, Method {
    ScannerBytes() { this.(Method).hasQualifiedName("bufio", "Scanner", "Bytes") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }

  class ScannerBuffer extends TaintTracking::FunctionModel, Method {
    ScannerBuffer() { this.(Method).hasQualifiedName("bufio", "Scanner", "Buffer") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isParameter(0)
    }
  }

  class SplitFunctions extends TaintTracking::FunctionModel {
    SplitFunctions() {
      hasQualifiedName("bufio", ["ScanBytes", "ScanLines", "ScanRunes", "ScanWords"])
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult(1)
    }
  }

  // Reader:
  class NewReader extends TaintTracking::FunctionModel {
    NewReader() { hasQualifiedName("bufio", ["NewReader", "NewReaderSize", "NewReadWriter"]) }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  private string getAReadMethod() {
    result = ["Peek", "ReadByte", "ReadBytes", "ReadLine", "ReadRune", "ReadSlice", "ReadString"]
  }

  class ReadMethods extends TaintTracking::FunctionModel, Method {
    ReadMethods() {
      this.(Method).hasQualifiedName("bufio", ["Reader", "ReadWriter"], getAReadMethod())
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult(0)
    }
  }

  class ReaderReset extends TaintTracking::FunctionModel, Method {
    ReaderReset() { this.(Method).hasQualifiedName("bufio", ["Reader", "ReadWriter"], "Reset") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isReceiver()
    }
  }

  private class NewWriter extends TaintTracking::FunctionModel {
    NewWriter() { this.hasQualifiedName("bufio", "NewWriter") }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isResult() and output.isParameter(0)
    }
  }

  private string getAWriteMethod() { result = ["Write", "WriteByte", "WriteRune", "WriteString"] }

  class WriteMethods extends TaintTracking::FunctionModel, Method {
    WriteMethods() {
      this.(Method).hasQualifiedName("bufio", ["Writer", "ReadWriter"], getAWriteMethod())
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isReceiver()
    }
  }

  class WriterReadFrom extends TaintTracking::FunctionModel, Method {
    WriterReadFrom() {
      this.(Method).hasQualifiedName("bufio", ["Writer", "ReadWriter"], "ReadFrom")
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isReceiver()
    }
  }

  class WriterReset extends TaintTracking::FunctionModel, Method {
    WriterReset() { this.(Method).hasQualifiedName("bufio", ["Writer", "ReadWriter"], "Reset") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isParameter(0)
    }
  }
}

/** Provides models of commonly used functions in the `io/ioutil` package. */
module IoUtil {
  private class IoUtilFileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
    IoUtilFileSystemAccess() {
      exists(string fn | getTarget().hasQualifiedName("io/ioutil", fn) |
        fn = "ReadDir" or
        fn = "ReadFile" or
        fn = "TempDir" or
        fn = "TempFile" or
        fn = "WriteFile"
      )
    }

    override DataFlow::Node getAPathArgument() { result = getAnArgument() }
  }

  /**
   * A taint model of the `ioutil.ReadAll` function, recording that it propagates taint
   * from its first argument to its first result.
   */
  private class ReadAll extends TaintTracking::FunctionModel {
    ReadAll() { hasQualifiedName("io/ioutil", "ReadAll") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult(0)
    }
  }
}

/** Provides models of commonly used functions in the `os` package. */
module OS {
  /**
   * A call to a function in `os` that accesses the file system.
   */
  private class OsFileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
    int pathidx;

    OsFileSystemAccess() {
      exists(string fn | getTarget().hasQualifiedName("os", fn) |
        fn = "Chdir" and pathidx = 0
        or
        fn = "Chmod" and pathidx = 0
        or
        fn = "Chown" and pathidx = 0
        or
        fn = "Chtimes" and pathidx = 0
        or
        fn = "Create" and pathidx = 0
        or
        fn = "Lchown" and pathidx = 0
        or
        fn = "Link" and pathidx in [0 .. 1]
        or
        fn = "Lstat" and pathidx = 0
        or
        fn = "Mkdir" and pathidx = 0
        or
        fn = "MkdirAll" and pathidx = 0
        or
        fn = "NewFile" and pathidx = 1
        or
        fn = "Open" and pathidx = 0
        or
        fn = "OpenFile" and pathidx = 0
        or
        fn = "Readlink" and pathidx = 0
        or
        fn = "Remove" and pathidx = 0
        or
        fn = "RemoveAll" and pathidx = 0
        or
        fn = "Rename" and pathidx in [0 .. 1]
        or
        fn = "Stat" and pathidx = 0
        or
        fn = "Symlink" and pathidx in [0 .. 1]
        or
        fn = "Truncate" and pathidx = 0
      )
    }

    override DataFlow::Node getAPathArgument() { result = getArgument(pathidx) }
  }

  /** The `Expand` function. */
  class Expand extends TaintTracking::FunctionModel {
    Expand() { hasQualifiedName("os", "Expand") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  /** The `ExpandEnv` function. */
  class ExpandEnv extends TaintTracking::FunctionModel {
    ExpandEnv() { hasQualifiedName("os", "ExpandEnv") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }
}

/** Provides models of commonly used functions in the `path` package. */
module Path {
  /** A path-manipulating function in the `path` package. */
  class PathManipulatingFunction extends TaintTracking::FunctionModel {
    PathManipulatingFunction() {
      exists(string fn | hasQualifiedName("path", fn) |
        fn = "Base" or
        fn = "Clean" or
        fn = "Dir" or
        fn = "Ext" or
        fn = "Join" or
        fn = "Split"
      )
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(_) and
      (outp.isResult() or outp.isResult(_))
    }
  }
}

/** Provides models of commonly used functions in the `strings` package. */
module Strings {
  /** The `Join` function. */
  class Join extends TaintTracking::FunctionModel {
    Join() { hasQualifiedName("strings", "Join") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter([0 .. 1]) and outp.isResult()
    }
  }

  /** The `Repeat` function. */
  class Repeat extends TaintTracking::FunctionModel {
    Repeat() { hasQualifiedName("strings", "Repeat") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  /** The `Replace` or `ReplaceAll` function. */
  class Replacer extends TaintTracking::FunctionModel {
    Replacer() {
      hasQualifiedName("strings", "Replace") or hasQualifiedName("strings", "ReplaceAll")
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      (inp.isParameter(0) or inp.isParameter(2)) and
      outp.isResult()
    }
  }

  /** The `Split` function or one of its variants. */
  class Splitter extends TaintTracking::FunctionModel {
    Splitter() {
      exists(string split | split.matches("Split%") | hasQualifiedName("strings", split))
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  /** One of the case-converting functions in the `strings` package. */
  class CaseConverter extends TaintTracking::FunctionModel {
    CaseConverter() {
      exists(string conv | conv.matches("To%") | hasQualifiedName("strings", conv))
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(getNumParameter() - 1) and outp.isResult()
    }
  }

  /** The `Trim` function or one of its variants. */
  class Trimmer extends TaintTracking::FunctionModel {
    Trimmer() { exists(string split | split.matches("Trim%") | hasQualifiedName("strings", split)) }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  // func NewReader(s string) *strings.Reader
  class NewReader extends TaintTracking::FunctionModel {
    NewReader() { hasQualifiedName("strings", "NewReader") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(_) and outp.isResult()
    }
  }
}

/** Provides models of commonly used functions in the `text/template` package. */
module Template {
  private class TemplateEscape extends EscapeFunction::Range {
    string kind;

    TemplateEscape() {
      exists(string fn |
        fn.matches("HTMLEscape%") and kind = "html"
        or
        fn.matches("JSEscape%") and kind = "js"
        or
        fn.matches("URLQueryEscape%") and kind = "url"
      |
        this.hasQualifiedName("text/template", fn)
        or
        this.hasQualifiedName("html/template", fn)
      )
    }

    override string kind() { result = kind }
  }

  private class TextTemplateInstantiation extends TemplateInstantiation::Range,
    DataFlow::MethodCallNode {
    int dataArg;

    TextTemplateInstantiation() {
      exists(string m | getTarget().hasQualifiedName("text/template", "Template", m) |
        m = "Execute" and
        dataArg = 1
        or
        m = "ExecuteTemplate" and
        dataArg = 2
      )
    }

    override DataFlow::Node getTemplateArgument() { result = this.getReceiver() }

    override DataFlow::Node getADataArgument() { result = this.getArgument(dataArg) }
  }
}

/** Provides models of commonly used functions in the `net/url` package. */
module URL {
  /** The `PathEscape` or `QueryEscape` function. */
  class Escaper extends TaintTracking::FunctionModel {
    Escaper() {
      hasQualifiedName("net/url", "PathEscape") or hasQualifiedName("net/url", "QueryEscape")
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  /** The `PathUnescape` or `QueryUnescape` function. */
  class Unescaper extends TaintTracking::FunctionModel {
    Unescaper() {
      hasQualifiedName("net/url", "PathUnescape") or hasQualifiedName("net/url", "QueryUnescape")
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult(0)
    }
  }

  /** The `Parse`, `ParseQuery` or `ParseRequestURI` function, or the `URL.Parse` method. */
  class Parser extends TaintTracking::FunctionModel {
    Parser() {
      hasQualifiedName("net/url", "Parse") or
      this.(Method).hasQualifiedName("net/url", "URL", "Parse") or
      hasQualifiedName("net/url", "ParseQuery") or
      hasQualifiedName("net/url", "ParseRequestURI")
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and
      outp.isResult(0)
      or
      this instanceof Method and
      inp.isReceiver() and
      outp.isResult(0)
    }
  }

  /** A method that returns a part of a URL. */
  class UrlGetter extends TaintTracking::FunctionModel, Method {
    UrlGetter() {
      exists(string m | hasQualifiedName("net/url", "URL", m) |
        m = "EscapedPath" or
        m = "Hostname" or
        m = "Port" or
        m = "Query" or
        m = "RequestURI"
      )
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }

  /** The method `URL.MarshalBinary`. */
  class UrlMarshalBinary extends TaintTracking::FunctionModel, Method {
    UrlMarshalBinary() { hasQualifiedName("net/url", "URL", "MarshalBinary") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isReceiver() and outp.isResult(0)
    }
  }

  /** The method `URL.ResolveReference`. */
  class UrlResolveReference extends TaintTracking::FunctionModel, Method {
    UrlResolveReference() { hasQualifiedName("net/url", "URL", "ResolveReference") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      (inp.isReceiver() or inp.isParameter(0)) and
      outp.isResult()
    }
  }

  /** The function `User` or `UserPassword`. */
  class UserinfoConstructor extends TaintTracking::FunctionModel {
    UserinfoConstructor() {
      hasQualifiedName("net/url", "User") or
      hasQualifiedName("net/url", "UserPassword")
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(_) and outp.isResult()
    }
  }

  /** A method that returns a part of a Userinfo struct. */
  class UserinfoGetter extends TaintTracking::FunctionModel, Method {
    UserinfoGetter() {
      exists(string m | hasQualifiedName("net/url", "Userinfo", m) |
        m = "Password" or
        m = "Username"
      )
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isReceiver() and
      if getName() = "Password" then outp.isResult(0) else outp.isResult()
    }
  }

  /** A method that returns all or part of a Values map. */
  class ValuesGetter extends TaintTracking::FunctionModel, Method {
    ValuesGetter() {
      exists(string m | hasQualifiedName("net/url", "Values", m) |
        m = "Encode" or
        m = "Get"
      )
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }
}

/** Provides models of commonly used APIs in the `regexp` package. */
module Regexp {
  private class Pattern extends RegexpPattern::Range, DataFlow::ArgumentNode {
    string fnName;

    Pattern() {
      exists(Function fn | fnName.matches("Match%") or fnName.matches("%Compile%") |
        fn.hasQualifiedName("regexp", fnName) and
        this = fn.getACall().getArgument(0)
      )
    }

    override DataFlow::Node getAParse() { result = this.getCall() }

    override string getPattern() { result = this.asExpr().getStringValue() }

    override DataFlow::Node getAUse() {
      fnName.matches("MustCompile%") and
      result = this.getCall().getASuccessor*()
      or
      fnName.matches("Compile%") and
      result = this.getCall().getResult(0).getASuccessor*()
      or
      result = this
    }
  }

  private class MatchFunction extends RegexpMatchFunction::Range, Function {
    MatchFunction() {
      exists(string fn | fn.matches("Match%") | this.hasQualifiedName("regexp", fn))
    }

    override FunctionInput getRegexpArg() { result.isParameter(0) }

    override FunctionInput getValue() { result.isParameter(1) }

    override FunctionOutput getResult() { result.isResult(0) }
  }

  private class MatchMethod extends RegexpMatchFunction::Range, Method {
    MatchMethod() {
      exists(string fn | fn.matches("Match%") | this.hasQualifiedName("regexp", "Regexp", fn))
    }

    override FunctionInput getRegexpArg() { result.isReceiver() }

    override FunctionInput getValue() { result.isParameter(0) }

    override FunctionOutput getResult() { result.isResult() }
  }

  private class ReplaceFunction extends RegexpReplaceFunction::Range, Method {
    ReplaceFunction() {
      exists(string fn | fn.matches("ReplaceAll%") | this.hasQualifiedName("regexp", "Regexp", fn))
    }

    override FunctionInput getRegexpArg() { result.isReceiver() }

    override FunctionInput getSource() { result.isParameter(0) }

    override FunctionOutput getResult() { result.isResult() }
  }
}

/** Provides models of commonly used functions in the `log` package. */
module Log {
  private class LogCall extends LoggerCall::Range, DataFlow::CallNode {
    LogCall() {
      exists(string fn |
        fn.matches("Fatal%")
        or
        fn.matches("Panic%")
        or
        fn.matches("Print%")
      |
        this.getTarget().hasQualifiedName("log", fn)
        or
        this.getTarget().(Method).hasQualifiedName("log", "Logger", fn)
      )
    }

    override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
  }
}

/** Provides models of some functions in the `encoding/json` package. */
module EncodingJson {
  /** The `Marshal` or `MarshalIndent` function in the `encoding/json` package. */
  class MarshalFunction extends TaintTracking::FunctionModel, MarshalingFunction::Range {
    MarshalFunction() {
      this.hasQualifiedName("encoding/json", "Marshal") or
      this.hasQualifiedName("encoding/json", "MarshalIndent")
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = getAnInput() and outp = getOutput()
    }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

    override DataFlow::FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() { result = "JSON" }
  }

  private class UnmarshalFunction extends TaintTracking::FunctionModel, UnmarshalingFunction::Range {
    UnmarshalFunction() { this.hasQualifiedName("encoding/json", "Unmarshal") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = getAnInput() and outp = getOutput()
    }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(1) }

    override string getFormat() { result = "JSON" }
  }

  class NewDecoder extends TaintTracking::FunctionModel {
    NewDecoder() { hasQualifiedName("encoding/json", "NewDecoder") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  class DecoderDecode extends TaintTracking::FunctionModel, Method {
    DecoderDecode() { this.(Method).hasQualifiedName("encoding/json", "Decoder", "Decode") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isParameter(0)
    }
  }

  class NewEncoder extends TaintTracking::FunctionModel {
    NewEncoder() { hasQualifiedName("encoding/json", "NewEncoder") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isResult() and outp.isParameter(0)
    }
  }

  class EncoderEncode extends TaintTracking::FunctionModel, Method {
    EncoderEncode() { this.(Method).hasQualifiedName("encoding/json", "Encoder", "Encode") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isReceiver()
    }
  }

  class Compact extends TaintTracking::FunctionModel {
    Compact() { hasQualifiedName("encoding/json", "Compact") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(1) and outp.isParameter(0)
    }
  }

  class HTMLEscape extends TaintTracking::FunctionModel {
    HTMLEscape() { hasQualifiedName("encoding/json", "HTMLEscape") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(1) and outp.isParameter(0)
    }
  }

  class Indent extends TaintTracking::FunctionModel {
    Indent() { hasQualifiedName("encoding/json", "Indent") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(1) and outp.isParameter(0)
    }
  }
}

/** Provides models of some functions in the `encoding/hex` package. */
module EncodingHex {
  private class DecodeStringFunction extends TaintTracking::FunctionModel {
    DecodeStringFunction() { this.hasQualifiedName("encoding/hex", "DecodeString") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and
      outp.isResult(0)
    }
  }
}

/** Provides models of some functions in the `encoding/gob` package. */
module EncodingGob {
  class NewDecoder extends TaintTracking::FunctionModel {
    NewDecoder() { hasQualifiedName("encoding/gob", "NewDecoder") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  class DecoderDecode extends TaintTracking::FunctionModel, Method {
    DecoderDecode() { this.(Method).hasQualifiedName("encoding/gob", "Decoder", "Decode") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isParameter(0)
    }
  }

  class NewEncoder extends TaintTracking::FunctionModel {
    NewEncoder() { hasQualifiedName("encoding/gob", "NewEncoder") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isResult() and outp.isParameter(0)
    }
  }

  class EncoderEncode extends TaintTracking::FunctionModel, Method {
    EncoderEncode() { this.(Method).hasQualifiedName("encoding/gob", "Encoder", "Encode") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isReceiver()
    }
  }
}

/** Provides models of some functions in the `encoding/xml` package. */
module EncodingXml {
  private class MarshalFunction extends TaintTracking::FunctionModel, MarshalingFunction::Range {
    MarshalFunction() {
      this.hasQualifiedName("encoding/xml", "Marshal") or
      this.hasQualifiedName("encoding/xml", "MarshalIndent")
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = getAnInput() and outp = getOutput()
    }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

    override DataFlow::FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() { result = "XML" }
  }

  private class UnmarshalFunction extends TaintTracking::FunctionModel, UnmarshalingFunction::Range {
    UnmarshalFunction() { this.hasQualifiedName("encoding/xml", "Unmarshal") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = getAnInput() and outp = getOutput()
    }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(1) }

    override string getFormat() { result = "XML" }
  }

  class NewDecoder extends TaintTracking::FunctionModel {
    NewDecoder() { hasQualifiedName("encoding/xml", "NewDecoder") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  class DecoderDecode extends TaintTracking::FunctionModel, Method {
    DecoderDecode() { this.(Method).hasQualifiedName("encoding/xml", "Decoder", "Decode") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isParameter(0)
    }
  }

  class DecoderDecodeElement extends TaintTracking::FunctionModel, Method {
    DecoderDecodeElement() {
      this.(Method).hasQualifiedName("encoding/xml", "Decoder", "DecodeElement")
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isParameter(0)
    }
  }

  class DecoderToken extends TaintTracking::FunctionModel, Method {
    DecoderToken() {
      this.(Method).hasQualifiedName("encoding/xml", "Decoder", ["Token", "RawToken"])
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult(0)
    }
  }

  class NewEncoder extends TaintTracking::FunctionModel {
    NewEncoder() { hasQualifiedName("encoding/xml", "NewEncoder") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isResult() and outp.isParameter(0)
    }
  }

  class EncoderEncode extends TaintTracking::FunctionModel, Method {
    EncoderEncode() { this.(Method).hasQualifiedName("encoding/xml", "Encoder", "Encode") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isReceiver()
    }
  }

  class CopyToken extends TaintTracking::FunctionModel {
    CopyToken() { hasQualifiedName("encoding/xml", "CopyToken") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  class EscapeText extends TaintTracking::FunctionModel {
    EscapeText() { hasQualifiedName("encoding/xml", "EscapeText") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(1) and outp.isParameter(0)
    }
  }

  class NewTokenDecoder extends TaintTracking::FunctionModel {
    NewTokenDecoder() { hasQualifiedName("encoding/xml", "NewTokenDecoder") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }
}

module GoPkgYaml {
  private string getAPkgVersion() {
    result = ["gopkg.in/yaml.v1", "gopkg.in/yaml.v2", "gopkg.in/yaml.v3"]
  }

  private class MarshalFunction extends TaintTracking::FunctionModel, MarshalingFunction::Range {
    MarshalFunction() { hasQualifiedName(getAPkgVersion(), "Marshal") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = getAnInput() and outp = getOutput()
    }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

    override DataFlow::FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() { result = "YAML" }
  }

  private class UnmarshalFunction extends TaintTracking::FunctionModel, UnmarshalingFunction::Range {
    UnmarshalFunction() {
      this.hasQualifiedName(getAPkgVersion(), ["Unmarshal", "UnmarshalStrict"])
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = getAnInput() and outp = getOutput()
    }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(1) }

    override string getFormat() { result = "YAML" }
  }

  class NewDecoder extends TaintTracking::FunctionModel {
    NewDecoder() { hasQualifiedName(getAPkgVersion(), "NewDecoder") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  class DecoderDecode extends TaintTracking::FunctionModel, Method {
    DecoderDecode() { this.(Method).hasQualifiedName(getAPkgVersion(), "Decoder", "Decode") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isParameter(0)
    }
  }

  class NewEncoder extends TaintTracking::FunctionModel {
    NewEncoder() { hasQualifiedName(getAPkgVersion(), "NewEncoder") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isResult() and outp.isParameter(0)
    }
  }

  class EncoderEncode extends TaintTracking::FunctionModel, Method {
    EncoderEncode() { this.(Method).hasQualifiedName(getAPkgVersion(), "Encoder", "Encode") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isReceiver()
    }
  }
}

module GhodssYaml {
  private string getPkg() { result = "github.com/ghodss/yaml" }

  private class MarshalFunction extends TaintTracking::FunctionModel, MarshalingFunction::Range {
    MarshalFunction() { hasQualifiedName(getPkg(), "Marshal") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = getAnInput() and outp = getOutput()
    }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

    override DataFlow::FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() { result = "YAML" }
  }

  private class UnmarshalFunction extends TaintTracking::FunctionModel, UnmarshalingFunction::Range {
    UnmarshalFunction() { this.hasQualifiedName(getPkg(), ["Unmarshal", "UnmarshalStrict"]) }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = getAnInput() and outp = getOutput()
    }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(1) }

    override string getFormat() { result = "YAML" }
  }

  class DisallowUnknownFields extends TaintTracking::FunctionModel {
    DisallowUnknownFields() { hasQualifiedName(getPkg(), "DisallowUnknownFields") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  class JSONToYAML extends TaintTracking::FunctionModel {
    JSONToYAML() { hasQualifiedName(getPkg(), "JSONToYAML") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult(0)
    }
  }

  class YAMLToJSON extends TaintTracking::FunctionModel {
    YAMLToJSON() { hasQualifiedName(getPkg(), ["YAMLToJSON", "YAMLToJSONStrict"]) }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult(0)
    }
  }
}

module GoccyYaml {
  private string getPkg() { result = "github.com/goccy/go-yaml" }

  private class MarshalFunction extends TaintTracking::FunctionModel, MarshalingFunction::Range {
    MarshalFunction() { hasQualifiedName(getPkg(), "Marshal") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = getAnInput() and outp = getOutput()
    }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

    override DataFlow::FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() { result = "YAML" }
  }

  private class UnmarshalFunction extends TaintTracking::FunctionModel, UnmarshalingFunction::Range {
    UnmarshalFunction() { this.hasQualifiedName(getPkg(), "Unmarshal") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = getAnInput() and outp = getOutput()
    }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(1) }

    override string getFormat() { result = "YAML" }
  }

  class NewDecoder extends TaintTracking::FunctionModel {
    NewDecoder() { hasQualifiedName(getPkg(), "NewDecoder") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  class DecoderDecode extends TaintTracking::FunctionModel, Method {
    DecoderDecode() { this.(Method).hasQualifiedName(getPkg(), "Decoder", "Decode") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isParameter(0)
    }
  }

  class NewEncoder extends TaintTracking::FunctionModel {
    NewEncoder() { hasQualifiedName(getPkg(), "NewEncoder") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isResult() and outp.isParameter(0)
    }
  }

  class EncoderEncode extends TaintTracking::FunctionModel, Method {
    EncoderEncode() { this.(Method).hasQualifiedName(getPkg(), "Encoder", "Encode") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isReceiver()
    }
  }
}

/** Provides models of some functions in the `crypto/cipher` package. */
module CryptoCipher {
  private class AeadOpenFunction extends TaintTracking::FunctionModel, Method {
    AeadOpenFunction() { this.hasQualifiedName("crypto/cipher", "AEAD", "Open") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(2) and
      outp.isResult(0)
    }
  }
}

module TextScanner {
  class InitFunc extends TaintTracking::FunctionModel, Method {
    InitFunc() { this.(Method).hasQualifiedName("text/scanner", "Scanner", "Init") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isReceiver()
    }
  }

  private string getAReadMethod() { result = ["Next", "Peek", "Scan", "String", "TokenText"] }

  class ScannerReadMethods extends TaintTracking::FunctionModel, Method {
    ScannerReadMethods() {
      this.(Method).hasQualifiedName("text/scanner", "Scanner", getAReadMethod())
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }
}

module EncodingCsv {
  class NewReader extends TaintTracking::FunctionModel {
    NewReader() { hasQualifiedName("encoding/csv", "NewReader") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  class ReaderRead extends TaintTracking::FunctionModel, Method {
    ReaderRead() { this.(Method).hasQualifiedName("encoding/csv", "Reader", ["Read", "ReadAll"]) }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult(0)
    }
  }
}

module CompressGzip {
  class NewReader extends TaintTracking::FunctionModel {
    NewReader() { hasQualifiedName("compress/gzip", "NewReader") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult(0)
    }
  }

  class ReaderReset extends TaintTracking::FunctionModel, Method {
    ReaderReset() { this.(Method).hasQualifiedName("compress/gzip", "Reader", "Reset") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isReceiver()
    }
  }

  private class NewWriter extends TaintTracking::FunctionModel {
    NewWriter() { this.hasQualifiedName("compress/gzip", ["NewWriter", "NewWriterLevel"]) }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      (input.isResult() or input.isResult(0)) and
      output.isParameter(0)
    }
  }

  class WriterReset extends TaintTracking::FunctionModel, Method {
    WriterReset() { this.(Method).hasQualifiedName("compress/gzip", "Writer", "Reset") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isParameter(0)
    }
  }

  class WriterWrite extends TaintTracking::FunctionModel, Method {
    WriterWrite() { this.(Method).hasQualifiedName("compress/gzip", "Writer", "Write") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isReceiver()
    }
  }
}

module CompressBzip2 {
  class NewReader extends TaintTracking::FunctionModel {
    NewReader() { hasQualifiedName("compress/bzip2", "NewReader") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  class WriterWrite extends TaintTracking::FunctionModel, Method {
    WriterWrite() { this.(Method).hasQualifiedName("compress/bzip2", "Writer", "Write") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isReceiver()
    }
  }
}

module CompressFlate {
  class NewReader extends TaintTracking::FunctionModel {
    NewReader() { hasQualifiedName("compress/flate", ["NewReader", "NewReaderDict"]) }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  private class NewWriter extends TaintTracking::FunctionModel {
    NewWriter() { this.hasQualifiedName("compress/flate", ["NewWriter", "NewWriterDict"]) }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isResult(0) and output.isParameter(0)
    }
  }

  class WriterReset extends TaintTracking::FunctionModel, Method {
    WriterReset() { this.(Method).hasQualifiedName("compress/flate", "Writer", "Reset") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isParameter(0)
    }
  }

  class WriterWrite extends TaintTracking::FunctionModel, Method {
    WriterWrite() { this.(Method).hasQualifiedName("compress/flate", "Writer", "Write") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isReceiver()
    }
  }
}

module CompressLzw {
  class NewReader extends TaintTracking::FunctionModel {
    NewReader() { hasQualifiedName("compress/lzw", "NewReader") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  private class NewWriter extends TaintTracking::FunctionModel {
    NewWriter() { this.hasQualifiedName("compress/lzw", "NewWriter") }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isResult() and output.isParameter(0)
    }
  }

  class WriterWrite extends TaintTracking::FunctionModel, Method {
    WriterWrite() { this.(Method).hasQualifiedName("compress/lzw", "Writer", "Write") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isReceiver()
    }
  }
}
