/**
 * Provides imports of all the standard libraries.
 */

import go
import semmle.go.frameworks.stdlib.ArchiveTarTaintTracking
import semmle.go.frameworks.stdlib.ArchiveZipTaintTracking
import semmle.go.frameworks.stdlib.BufioTaintTracking
import semmle.go.frameworks.stdlib.BytesTaintTracking
import semmle.go.frameworks.stdlib.CompressBzip2TaintTracking
import semmle.go.frameworks.stdlib.CompressFlateTaintTracking
import semmle.go.frameworks.stdlib.CompressGzipTaintTracking
import semmle.go.frameworks.stdlib.CompressLzwTaintTracking
import semmle.go.frameworks.stdlib.CompressZlibTaintTracking
import semmle.go.frameworks.stdlib.ContainerHeapTaintTracking
import semmle.go.frameworks.stdlib.ContainerListTaintTracking
import semmle.go.frameworks.stdlib.ContainerRingTaintTracking
import semmle.go.frameworks.stdlib.ContextTaintTracking
import semmle.go.frameworks.stdlib.CryptoCipherTaintTracking
import semmle.go.frameworks.stdlib.CryptoEcdsaTaintTracking
import semmle.go.frameworks.stdlib.CryptoEd25519TaintTracking
import semmle.go.frameworks.stdlib.CryptoRsaTaintTracking
import semmle.go.frameworks.stdlib.CryptoTaintTracking
import semmle.go.frameworks.stdlib.CryptoTlsTaintTracking
import semmle.go.frameworks.stdlib.CryptoX509TaintTracking
import semmle.go.frameworks.stdlib.DatabaseSqlDriverTaintTracking
import semmle.go.frameworks.stdlib.DatabaseSqlTaintTracking
import semmle.go.frameworks.stdlib.EncodingAscii85TaintTracking
import semmle.go.frameworks.stdlib.EncodingAsn1TaintTracking
import semmle.go.frameworks.stdlib.EncodingBase32TaintTracking
import semmle.go.frameworks.stdlib.EncodingBase64TaintTracking
import semmle.go.frameworks.stdlib.EncodingBinaryTaintTracking
import semmle.go.frameworks.stdlib.EncodingCsvTaintTracking
import semmle.go.frameworks.stdlib.EncodingGobTaintTracking
import semmle.go.frameworks.stdlib.EncodingHexTaintTracking
import semmle.go.frameworks.stdlib.EncodingJsonTaintTracking
import semmle.go.frameworks.stdlib.EncodingPemTaintTracking
import semmle.go.frameworks.stdlib.EncodingTaintTracking
import semmle.go.frameworks.stdlib.EncodingXmlTaintTracking
import semmle.go.frameworks.stdlib.ErrorsTaintTracking
import semmle.go.frameworks.stdlib.ExpvarTaintTracking
import semmle.go.frameworks.stdlib.FmtTaintTracking
import semmle.go.frameworks.stdlib.HtmlTaintTracking
import semmle.go.frameworks.stdlib.HtmlTemplateTaintTracking
import semmle.go.frameworks.stdlib.IoIoutilTaintTracking
import semmle.go.frameworks.stdlib.IoTaintTracking
import semmle.go.frameworks.stdlib.LogTaintTracking
import semmle.go.frameworks.stdlib.MimeMultipartTaintTracking
import semmle.go.frameworks.stdlib.MimeQuotedprintableTaintTracking
import semmle.go.frameworks.stdlib.MimeTaintTracking
import semmle.go.frameworks.stdlib.NetHttpHttputilTaintTracking
import semmle.go.frameworks.stdlib.NetHttpTaintTracking
import semmle.go.frameworks.stdlib.NetMailTaintTracking
import semmle.go.frameworks.stdlib.NetTaintTracking
import semmle.go.frameworks.stdlib.NetTextprotoTaintTracking
import semmle.go.frameworks.stdlib.NetUrlTaintTracking
import semmle.go.frameworks.stdlib.OsTaintTracking
import semmle.go.frameworks.stdlib.PathFilepathTaintTracking
import semmle.go.frameworks.stdlib.PathTaintTracking
import semmle.go.frameworks.stdlib.ReflectTaintTracking
import semmle.go.frameworks.stdlib.RegexpTaintTracking
import semmle.go.frameworks.stdlib.SortTaintTracking
import semmle.go.frameworks.stdlib.StrconvTaintTracking
import semmle.go.frameworks.stdlib.StringsTaintTracking
import semmle.go.frameworks.stdlib.SyncAtomicTaintTracking
import semmle.go.frameworks.stdlib.SyncTaintTracking
import semmle.go.frameworks.stdlib.SyscallTaintTracking
import semmle.go.frameworks.stdlib.TextScannerTaintTracking
import semmle.go.frameworks.stdlib.TextTabwriterTaintTracking
import semmle.go.frameworks.stdlib.TextTemplateTaintTracking
import semmle.go.frameworks.stdlib.UnicodeTaintTracking
import semmle.go.frameworks.stdlib.UnicodeUtf16TaintTracking
import semmle.go.frameworks.stdlib.UnicodeUtf8TaintTracking
