// https://github.com/LNReader/lnreader/blob/master/src/plugins/helpers/isAbsoluteUrl.ts

export const isUrlAbsolute = url => {
  if (url) {
    if (url.indexOf("//") === 0) {
      return true
    } // URL is protocol-relative (= absolute)
    if (url.indexOf("://") === -1) {
      return false
    } // URL has no protocol (= relative)
    if (url.indexOf(".") === -1) {
      return false
    } // URL does not contain a dot, i.e. no TLD (= relative, possibly REST)
    if (url.indexOf("/") === -1) {
      return false
    } // URL does not contain a single slash (= relative)
    if (url.indexOf(":") > url.indexOf("/")) {
      return false
    } // The first colon comes after the first slash (= relative)
    if (url.indexOf("://") < url.indexOf(".")) {
      return true
    } // Protocol is defined before first dot (= absolute)
  }
  return false // Anything else must be relative
}
