
if [ module-info mode load ] {
  if [ is-loaded PrgEnv-gnu ] {
  } else {
    if [ is-loaded PrgEnv-cray ] {
      module swap PrgEnv-cray PrgEnv-gnu
    }
    if [ is-loaded PrgEnv-intel ] {
      module swap PrgEnv-intel PrgEnv-gnu
    }
  }
  # altd may cause random job hangs
  if [ is-loaded altd ] {
    module unload altd
  }
  # darshan may cause overhead
  if [ is-loaded darshan ] {
    module unload darshan
  }
  module unload cray-libsci
  module unload craype-hugepages2M
  setenv CRAYPE_LINK_TYPE dynamic
}
