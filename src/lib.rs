#![allow(non_camel_case_types)]

//! This library builds Tor and a minimal set of its dependencies into a single library that can be
//! loaded like any other Rust crate dependency.
//!
//! By default it only uses the minimal set of dependencies required by Tor, namely OpenSSL,
//! Libevent and Zlib. The `with-lzma` and `with-zstd` features can be used to enable the
//! respective dependencies, and the `vendored-lzma` and `vendored-zstd` features can be used
//! to compile and like those libraries statically.
//!
//! The interface simply re-exports Tor's functions defined in its tor_api.h header.
//!
//! # Example
//!
//! ```no_run
//! # use std::ffi::CString;
//! # use tor_sys::*;
//! unsafe {
//!     let config = tor_main_configuration_new();
//!     let argv = vec![
//!         CString::new("tor").unwrap(),
//!         CString::new("--version").unwrap(),
//!     ];
//!     let argv: Vec<_> = argv.iter().map(|s| s.as_ptr()).collect();
//!     tor_main_configuration_set_command_line(config, argv.len() as i32, argv.as_ptr());
//!
//!     assert_eq!(tor_run_main(config), 0);
//!
//!     tor_main_configuration_free(config);
//! }
//! ```

use std::os::raw::{c_char, c_int, c_void};

type tor_main_configuration_t = c_void;

extern "C" {
    pub fn tor_main_configuration_new() -> *mut tor_main_configuration_t;
    pub fn tor_main_configuration_set_command_line(
        config: *mut tor_main_configuration_t,
        argc: c_int,
        argv: *const *const c_char,
    ) -> c_int;
    pub fn tor_main_configuration_free(config: *mut tor_main_configuration_t);
    pub fn tor_run_main(configuration: *const tor_main_configuration_t) -> c_int;
}

#[cfg(test)]
mod test {
    #[test]
    fn test_tor_version() {
        use super::*;
        use std::ffi::CString;

        let args = [
            CString::new("tor").unwrap(),
            CString::new("--version").unwrap(),
        ];
        let args_ptr = [args[0].as_ptr(), args[1].as_ptr()];

        unsafe {
            let config = tor_main_configuration_new();
            tor_main_configuration_set_command_line(config, 2, args_ptr.as_ptr());
            tor_run_main(config);
            tor_main_configuration_free(config);
        }
    }
}
