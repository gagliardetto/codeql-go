// Code generated by depstubber. DO NOT EDIT.
// This is a simple stub for clevergo.tech/clevergo, strictly for use in testing.

// See the LICENSE file for information about the licensing of the original library.
// Source: clevergo.tech/clevergo (exports: ; functions: )

// Package clevergo is a stub of clevergo.tech/clevergo, generated by depstubber.
package clevergo

import (
	context "context"
	io "io"
	net "net"
	http "net/http"
	url "net/url"
	os "os"
	time "time"
)

type Application struct {
	Server                 *http.Server
	ShutdownTimeout        time.Duration
	ShutdownSignals        []os.Signal
	RedirectTrailingSlash  bool
	RedirectFixedPath      bool
	HandleMethodNotAllowed bool
	HandleOPTIONS          bool
	GlobalOPTIONS          http.Handler
	NotFound               http.Handler
	MethodNotAllowed       http.Handler
	UseRawPath             bool
	Renderer               Renderer
	Decoder                Decoder
	Logger                 interface{}
}

func (_ *Application) Any(_ string, _ Handle, _ ...RouteOption) {}

func (_ *Application) Delete(_ string, _ Handle, _ ...RouteOption) {}

func (_ *Application) Get(_ string, _ Handle, _ ...RouteOption) {}

func (_ *Application) Group(_ string, _ ...RouteGroupOption) Router {
	return nil
}

func (_ *Application) Handle(_ string, _ string, _ Handle, _ ...RouteOption) {}

func (_ *Application) Handler(_ string, _ string, _ http.Handler, _ ...RouteOption) {}

func (_ *Application) HandlerFunc(_ string, _ string, _ http.HandlerFunc, _ ...RouteOption) {}

func (_ *Application) Head(_ string, _ Handle, _ ...RouteOption) {}

func (_ *Application) Lookup(_ string, _ string) (*Route, Params, bool) {
	return nil, nil, false
}

func (_ *Application) Options(_ string, _ Handle, _ ...RouteOption) {}

func (_ *Application) Patch(_ string, _ Handle, _ ...RouteOption) {}

func (_ *Application) Post(_ string, _ Handle, _ ...RouteOption) {}

func (_ *Application) Put(_ string, _ Handle, _ ...RouteOption) {}

func (_ *Application) RouteURL(_ string, _ ...string) (*url.URL, error) {
	return nil, nil
}

func (_ *Application) Run(_ string) error {
	return nil
}

func (_ *Application) RunTLS(_ string, _ string, _ string) error {
	return nil
}

func (_ *Application) RunUnix(_ string) error {
	return nil
}

func (_ *Application) Serve(_ net.Listener) error {
	return nil
}

func (_ *Application) ServeFiles(_ string, _ http.FileSystem, _ ...RouteOption) {}

func (_ *Application) ServeHTTP(_ http.ResponseWriter, _ *http.Request) {}

func (_ *Application) Use(_ ...MiddlewareFunc) {}

func CleanPath(_ string) string {
	return ""
}

type Context struct {
	Params   Params
	Route    *Route
	Request  *http.Request
	Response http.ResponseWriter
}

func (_ *Context) BasicAuth() (string, string, bool) {
	return "", "", false
}

func (_ *Context) Blob(_ int, _ string, _ []byte) error {
	return nil
}

func (_ *Context) Context() context.Context {
	return nil
}

func (_ *Context) Cookie(_ string) (*http.Cookie, error) {
	return nil, nil
}

func (_ *Context) Cookies() []*http.Cookie {
	return nil
}

func (_ *Context) Decode(_ interface{}) error {
	return nil
}

func (_ *Context) DefaultQuery(_ string, _ string) string {
	return ""
}

func (_ *Context) Emit(_ int, _ string, _ string) error {
	return nil
}

func (_ *Context) Error(_ int, _ string) error {
	return nil
}

func (_ *Context) FormValue(_ string) string {
	return ""
}

func (_ *Context) GetHeader(_ string) string {
	return ""
}

func (_ *Context) HTML(_ int, _ string) error {
	return nil
}

func (_ *Context) HTMLBlob(_ int, _ []byte) error {
	return nil
}

func (_ *Context) Host() string {
	return ""
}

func (_ *Context) IsAJAX() bool {
	return false
}

func (_ *Context) IsDelete() bool {
	return false
}

func (_ *Context) IsGet() bool {
	return false
}

func (_ *Context) IsMethod(_ string) bool {
	return false
}

func (_ *Context) IsOptions() bool {
	return false
}

func (_ *Context) IsPatch() bool {
	return false
}

func (_ *Context) IsPost() bool {
	return false
}

func (_ *Context) IsPut() bool {
	return false
}

func (_ *Context) JSON(_ int, _ interface{}) error {
	return nil
}

func (_ *Context) JSONBlob(_ int, _ []byte) error {
	return nil
}

func (_ *Context) JSONP(_ int, _ interface{}) error {
	return nil
}

func (_ *Context) JSONPBlob(_ int, _ []byte) error {
	return nil
}

func (_ *Context) JSONPCallback(_ int, _ string, _ interface{}) error {
	return nil
}

func (_ *Context) JSONPCallbackBlob(_ int, _ string, _ []byte) error {
	return nil
}

func (_ *Context) Logger() interface{} {
	return nil
}

func (_ *Context) NotFound() error {
	return nil
}

func (_ *Context) PostFormValue(_ string) string {
	return ""
}

func (_ *Context) QueryParam(_ string) string {
	return ""
}

func (_ *Context) QueryParams() url.Values {
	return nil
}

func (_ *Context) QueryString() string {
	return ""
}

func (_ *Context) Redirect(_ int, _ string) error {
	return nil
}

func (_ *Context) Render(_ int, _ string, _ interface{}) error {
	return nil
}

func (_ *Context) RouteURL(_ string, _ ...string) (*url.URL, error) {
	return nil, nil
}

func (_ *Context) SendFile(_ string, _ io.Reader) error {
	return nil
}

func (_ *Context) ServeContent(_ string, _ time.Time, _ io.ReadSeeker) error {
	return nil
}

func (_ *Context) ServeFile(_ string) error {
	return nil
}

func (_ *Context) SetContentType(_ string) {}

func (_ *Context) SetContentTypeHTML() {}

func (_ *Context) SetContentTypeJSON() {}

func (_ *Context) SetContentTypeText() {}

func (_ *Context) SetContentTypeXML() {}

func (_ *Context) SetCookie(_ *http.Cookie) {}

func (_ *Context) SetHeader(_ string, _ string) {}

func (_ *Context) String(_ int, _ string) error {
	return nil
}

func (_ *Context) StringBlob(_ int, _ []byte) error {
	return nil
}

func (_ *Context) Stringf(_ int, _ string, _ ...interface{}) error {
	return nil
}

func (_ *Context) Value(_ interface{}) interface{} {
	return nil
}

func (_ *Context) WithValue(_ interface{}, _ interface{}) {}

func (_ *Context) Write(_ []byte) (int, error) {
	return 0, nil
}

func (_ *Context) WriteHeader(_ int) {}

func (_ *Context) WriteString(_ string) (int, error) {
	return 0, nil
}

func (_ *Context) XML(_ int, _ interface{}) error {
	return nil
}

func (_ *Context) XMLBlob(_ int, _ []byte) error {
	return nil
}

type Decoder interface {
	Decode(_ *http.Request, _ interface{}) error
}

type Handle func(*Context) error

type MiddlewareFunc func(Handle) Handle

type Param struct {
	Key   string
	Value string
}

type Params []Param

func (_ Params) Bool(_ string) (bool, error) {
	return false, nil
}

func (_ Params) Float64(_ string) (float64, error) {
	return 0, nil
}

func (_ Params) Int(_ string) (int, error) {
	return 0, nil
}

func (_ Params) Int64(_ string) (int64, error) {
	return 0, nil
}

func (_ Params) String(_ string) string {
	return ""
}

func (_ Params) Uint64(_ string) (uint64, error) {
	return 0, nil
}

type Renderer interface {
	Render(_ io.Writer, _ string, _ interface{}, _ *Context) error
}

type Route struct{}

func (_ *Route) URL(_ ...string) (*url.URL, error) {
	return nil, nil
}

type RouteGroup struct{}

func (_ *RouteGroup) Any(_ string, _ Handle, _ ...RouteOption) {}

func (_ *RouteGroup) Delete(_ string, _ Handle, _ ...RouteOption) {}

func (_ *RouteGroup) Get(_ string, _ Handle, _ ...RouteOption) {}

func (_ *RouteGroup) Group(_ string, _ ...RouteGroupOption) Router {
	return nil
}

func (_ *RouteGroup) Handle(_ string, _ string, _ Handle, _ ...RouteOption) {}

func (_ *RouteGroup) Handler(_ string, _ string, _ http.Handler, _ ...RouteOption) {}

func (_ *RouteGroup) HandlerFunc(_ string, _ string, _ http.HandlerFunc, _ ...RouteOption) {}

func (_ *RouteGroup) Head(_ string, _ Handle, _ ...RouteOption) {}

func (_ *RouteGroup) Options(_ string, _ Handle, _ ...RouteOption) {}

func (_ *RouteGroup) Patch(_ string, _ Handle, _ ...RouteOption) {}

func (_ *RouteGroup) Post(_ string, _ Handle, _ ...RouteOption) {}

func (_ *RouteGroup) Put(_ string, _ Handle, _ ...RouteOption) {}

type RouteGroupOption func(*RouteGroup)

type RouteOption func(*Route)

type Router interface {
	Any(_ string, _ Handle, _ ...RouteOption)
	Delete(_ string, _ Handle, _ ...RouteOption)
	Get(_ string, _ Handle, _ ...RouteOption)
	Group(_ string, _ ...RouteGroupOption) Router
	Handle(_ string, _ string, _ Handle, _ ...RouteOption)
	Handler(_ string, _ string, _ http.Handler, _ ...RouteOption)
	HandlerFunc(_ string, _ string, _ http.HandlerFunc, _ ...RouteOption)
	Head(_ string, _ Handle, _ ...RouteOption)
	Options(_ string, _ Handle, _ ...RouteOption)
	Patch(_ string, _ Handle, _ ...RouteOption)
	Post(_ string, _ Handle, _ ...RouteOption)
	Put(_ string, _ Handle, _ ...RouteOption)
}
