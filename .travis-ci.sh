# OPAM packages needed to build tests.
OPAM_PACKAGES="lwt io-page cmdliner mirage-profile"


case "$OCAML_VERSION,$OPAM_VERSION" in
4.00.1,1.1.0) ppa=avsm/ocaml40+opam11 ;;
4.00.1,1.2.0) ppa=avsm/ocaml40+opam12 ;;
4.01.0,1.1.0) ppa=avsm/ocaml41+opam11 ;;
4.01.0,1.2.0) ppa=avsm/ocaml41+opam12 ;;
4.02.1,1.1.0) ppa=avsm/ocaml42+opam11 ;;
4.02.1,1.2.0) ppa=avsm/ocaml42+opam12 ;;
*) echo Unknown $OCAML_VERSION,$OPAM_VERSION; exit 1 ;;
esac

echo "yes" | sudo add-apt-repository ppa:$ppa
sudo apt-get update -qq
sudo apt-get install -qq ocaml ocaml-native-compilers camlp4-extra opam
export OPAMYES=1
export OPAMVERBOSE=1
echo OCaml version
ocaml -version
echo OPAM versions
opam --version
opam --git-version

opam init 
opam update
opam install ${OPAM_PACKAGES}

eval `opam config env`
# build without xen
make
# .. then build with xen
sudo apt-get install -qq libxen-dev
make clean
make
make test
