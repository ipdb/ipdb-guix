;; -*- mode: scheme; coding: utf-8; -*-

;; Copyright (c) 2019 IPDB Foundation
;; Author: David Dashyan <mail@davie.li>

;; TODO Add tests phase to BigchainDB installation

(define-module (bigchaindb)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages check)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages protobuf)
  #:use-module (gnu packages web)
  #:use-module (guix build-system python)
  #:use-module (guix packages)
  #:use-module (guix download))

(define-public python-colorlog
  (package
    (name "python-colorlog")
    (version "4.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "colorlog" version))
       (sha256
        (base32
         "0hlv7x4qnb4jmccyv12087m0v5a0p3rjwn7g3z06xy68rcjipwrw"))))
    (build-system python-build-system)
    (arguments
     ;; FIXME: Tests fail
     '(#:tests? #f))
    ;; Python-colorama required on win32 systems only.
    ;; (propagated-inputs
    ;;  `(("python-colorama" ,python-colorama)))
    (home-page
     "https://github.com/borntyping/python-colorlog")
    (synopsis "Log formatting with colors!")
    (description "colorlog.ColoredFormatter is a formatter for use with Python's
logging module that outputs records using terminal colors.")
    (license license:expat)))

;; ~v2.3 required by cryptoconditions
(define-public python-cryptography-2.3
  (package
    (inherit python-cryptography)
    (name "python-cryptography-2.3")
    (version "2.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "cryptography" version))
       (sha256
        (base32
         "1mnzf168vlxirq7fw9dm9zbvma7z8phc9cl5bffw5916m0y1244d"))))
    (arguments
     ;; FIXME: Tests fail
     '(#:tests? #f))))

;; ~v1.1 required by cryptoconditions
(define-public python-pynacl-1.1
  (package
    (inherit python-pynacl)
    (name "python-pynacl-1.1")
    (version "1.1.2")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "PyNaCl" version))
       (modules '((guix build utils)))
       ;; Remove bundled libsodium.
       (snippet '(begin (delete-file-recursively "src/libsodium") #t))
       (sha256
        (base32
         "135gz0020fqx8fbr9izpwyq49aww202nkqacq0cw61xz99sjpx9j"))))))

(define-public python-pytest-pythonpath
  (package
    (name "python-pytest-pythonpath")
    (version "0.7.3")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pytest-pythonpath" version))
       (sha256
        (base32
         "0qhxh0z2b3p52v3i0za9mrmjnb1nlvvyi2g23rf88b3xrrm59z33"))))
    (build-system python-build-system)
    (arguments
     ;; FIXME: Tests fail
     '(#:tests? #f))
    (propagated-inputs
     `(("python-pytest" ,python-pytest)))
    (home-page
      "https://github.com/bigsassy/pytest-pythonpath")
    (synopsis
     "pytest plugin for adding to the PYTHONPATH from command line or configs")
    (description
     "This is a py.test plugin for adding to the PYTHONPATH from the pytests.ini
file before tests run.")
    (license license:expat)))

(define-public python-bigchaindb-abci
  (package
    (name "python-bigchaindb-abci")
    (version "0.7.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "bigchaindb-abci" version))
       (sha256
        (base32
         "0hgbifhcm23nfymwki8mnxv24fl8ag1fq677illjgq5xpgz6256h"))))
    (build-system python-build-system)
    (arguments
     ;; FIXME: Tests fail
     '(#:tests? #f))
    (propagated-inputs
     `(("python-colorlog" ,python-colorlog)
       ("python-gevent" ,python-gevent)
       ("python-protobuf" ,python-protobuf)
       ("python-pytest" ,python-pytest)
       ("python-pytest-cov" ,python-pytest-cov)
       ("python-pytest-pythonpath" ,python-pytest-pythonpath)))
    (home-page
     "https://github.com/davebryson/py-abci")
    (synopsis
     "Python based ABCI Server for Tendermint")
    (description
     "Python based ABCI Server for Tendermint")
    (license license:asl2.0)))

;; required by python-cryptoconditions
(define-public python-pytest-forked
  (package
    (name "python-pytest-forked")
    (version "1.1.3")
    (source
     (origin
      (method url-fetch)
      (uri (pypi-uri "pytest-forked" version))
      (sha256
       (base32
        "000i4q7my2fq4l49n8idx2c812dql97qv6qpm2vhrrn9v6g6j18q"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-pytest" ,python-pytest)))
    (native-inputs
     `(("python-setuptools-scm" ,python-setuptools-scm)))
    (home-page
     "https://github.com/pytest-dev/pytest-forked")
    (synopsis
     "run tests in isolated forked subprocesses")
    (description
     "run tests in isolated forked subprocesses")
    (license license:expat)))

(define-public python-cryptoconditions
  (package
    (name "python-cryptoconditions")
    (version "0.8.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "cryptoconditions" version))
       (sha256
        (base32
         "1g5b4gbagnx4d830d9dh22isdnapykxqpmxjivp5083a1kr3z3bb"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-base58" ,python-base58)
       ("python-cryptography-2.3" ,python-cryptography-2.3)
       ("python-pyasn1" ,python-pyasn1)
       ("python-pynacl-1.1" ,python-pynacl-1.1)))
    (native-inputs
     `(;; Tests requirements:
       ("python-coverage" ,python-coverage)
       ("python-hypothesis" ,python-hypothesis)
       ("python-pep8" ,python-pep8)
       ("python-pyflakes" ,python-pyflakes)
       ("python-pylint" ,python-pylint)
       ("python-pytest" ,python-pytest)
       ("python-pytest-cov" ,python-pytest-cov)
       ("python-pytest-forked" ,python-pytest-forked)
       ("python-pytest-xdist" ,python-pytest-xdist)
       ;; Dev requerements:
       ;; ("python-ipdb" ,python-ipdb)
       ;; ("python-ipython" ,python-ipython)
       ;; Setup requerements:
       ("python-pytest-runner" ,python-pytest-runner)
       ;; Docs requirements
       ;; NOTE: Maybe create docs output
       ;; ("python-recommonmark" ,python-recommonmark)
       ;; ("python-sphinx" ,python-sphinx)
       ;; ("python-sphinx-rtd-theme"
       ;;  ,python-sphinx-rtd-theme)
       ;; ("python-sphinxcontrib-napoleon"
       ;;  ,python-sphinxcontrib-napoleon)
       ))
    (home-page
     "https://github.com/bigchaindb/cryptoconditions/")
    (synopsis
     "Multi-algorithm, multi-level, multi-signature format for expressing
conditions and fulfillments according to the Interledger Protocol (ILP).")
    (description "Cryptoconditions provide a mechanism to describe a signed
message such that multiple actors in a distributed system can all verify the
same signed message and agree on whether it matches the description." )
    (license license:expat)))

(define-public python-flask-cors
  (package
    (name "python-flask-cors")
    (version "3.0.8")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "Flask-Cors" version))
       (sha256
        (base32
         "05id72xwvhni23yasdvpdd8vsf3v4j6gzbqqff2g04j6xcih85vj"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-flask" ,python-flask)
       ("python-six" ,python-six)))
    (native-inputs
     `(("python-nose" ,python-nose)))
    (home-page
     "https://github.com/corydolphin/flask-cors")
    (synopsis
     "A Flask extension adding a decorator for CORS support")
    (description
     "A Flask extension for handling Cross Origin Resource Sharing (CORS),
making cross-origin AJAX possible. This package has a simple philosophy, when
you want to enable CORS, you wish to enable it for all use cases on a domain.
This means no mucking around with different allowed headers, methods, etc. By
default, submission of cookies across domains is disabled due to the security
implications, please see the documentation for how to enable credential'ed
requests, and please make sure you add some sort of CSRF protection before doing
so!")
    (license license:expat)))


(define-public python-gunicorn
  (package
    (name "python-gunicorn")
    ;; NOTE: new version available
    (version "19.9.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "gunicorn" version))
       (sha256
        (base32
         "1wzlf4xmn6qjirh5w81l6i6kqjnab1n1qqkh7zsj1yb6gh4n49ps"))))
  (build-system python-build-system)
  (propagated-inputs
   `(("python-setuptools" ,python-setuptools)))
  ;; XXX Package has defined docs requirements and extras
  ;; extras_require = {
  ;;     'gevent':  ['gevent>=0.13'],
  ;;     'eventlet': ['eventlet>=0.9.7'],
  ;;     'tornado': ['tornado>=0.2'],
  ;;     'gthread': [],
  ;;     'setproctitle': ['setproctitle'],
  ;; }
  (arguments
   ;; FIXME: Tests require unpackaged inputs
   '(#:tests? #f))
  (home-page "http://gunicorn.org")
  (synopsis "WSGI HTTP Server for UNIX")
  (description "WSGI HTTP Server for UNIX")
  (license license:expat)))

(define-public python-jsonschema-2.5
  ;; NOTE New version is available
  (package
    (name "python-jsonschema-2.5")
    (version "2.6.0")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "jsonschema" version))
              (sha256
               (base32
                "00kf3zmpp9ya4sydffpifn0j0mzm342a2vzh82p6r0vh10cg7xbg"))))
    (build-system python-build-system)
    (arguments
     ;; FIXME: Tests fail
     '(#:tests? #f))
    (native-inputs
     `(("python-vcversioner" ,python-vcversioner)))
    ;; NOTE: has extra requerements
    (home-page "https://github.com/Julian/jsonschema")
    (synopsis "Implementation of JSON Schema for Python")
    (description
     "Jsonschema is an implementation of JSON Schema for Python.")
    (license license:expat)))

(define-public python-logstats
  ;; NOTE New version is available
  (package
    (name "python-logstats")
    (version "0.2.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "logstats" version))
       (sha256
        (base32
         "02b7bk99023j1bgs1as7qmndcwknxmq3m3lvhs7kqnqg2pkp34m1"))))
    (build-system python-build-system)
    (home-page "https://github.com/vrde/logstats")
    (synopsis
     "A module to collect and display stats for long running processes")
    (description
     "A util to output stats out of long running processes. Super useful when
you have daemons, or long running scripts, that need to output some data every
now and then. It supports the multiprocessing modules, so you can collect stats
from your child processes as well!")
    (license license:expat)))

(define-public python-packaging-18.0
  ;; NOTE New version is available
  (package
    (inherit python-packaging)
    (name "python-packaging-18.0")
    (version "18.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "packaging" version))
       (sha256
        (base32
         "01wq9c53ix5rz6qg2c98gy8n4ff768rmanifm8m5jpjiaizj51h8"))))))

(define-public python-pymongo-3.6
  ;; NOTE New version is available
  (package
    (inherit python-pymongo)
    (name "python-pymongo-3.6")
    (version "3.6.1")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "pymongo" version))
              (sha256
               (base32
                "15j7jxbag863axwqghb3ms1wkadyi5503ndj9lvl1vk2d62cpszp"))))))

(define-public python-pyyaml-5.1
  ;; NOTE This package definition supersedes guix's one.
  (package
    (name "python-pyyaml")
    (version "5.1.2")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "PyYAML" version))
       (sha256
        (base32
         "1r5faspz73477hlbjgilw05xsms0glmsa371yqdd26znqsvg1b81"))))
    (build-system python-build-system)
    (inputs
     `(("libyaml" ,libyaml)))
    (home-page "http://pyyaml.org/wiki/PyYAML")
    (synopsis "YAML parser and emitter for Python")
    (description
     "PyYAML is a YAML parser and emitter for Python. PyYAML features a complete
YAML 1.1 parser, Unicode support, pickle support, capable extension API, and
sensible error messages. PyYAML supports standard YAML tags and provides
Python-specific tags that allow to represent an arbitrary Python object.")
    (license license:expat)))

(define-public python-rapidjson
  (package
    (name "python-rapidjson")
    (version "0.6.3")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "python-rapidjson" version))
       (sha256
        (base32
         "11d0bld459pxly56c54q6br83qcqsd8likiq0rn2pgnr273jjxqa"))))
    ;; NOTE: There is rapidjson package in guix repo which is actually a
    ;; submodule of git repo of this wrapper. It maight be possible to include
    ;; it as input.
    (build-system python-build-system)
    (home-page
     "https://github.com/python-rapidjson/python-rapidjson")
    (synopsis "Python wrapper around rapidjson")
    (description "RapidJSON is an extremely fast C++ JSON parser and
serialization library: this module wraps it into a Python 3 extension, exposing
its serialization/deserialization (to/from either bytes, str or file-like
instances) and JSON Schema validation capabilities.")
    (license license:expat)))

(define-public bigchaindb
  (package
    (name "bigchaindb")
    (version "2.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "BigchainDB" version))
       (sha256
        (base32
         "02zmc66jkbhladpy93j21i8p3s7kg407120p1djvwk7in5hm8qzx"))))
    (build-system python-build-system)
    (arguments
     ;; FIXME: Tests
     '(#:tests? #f))
    (propagated-inputs
     `(("python-aiohttp" ,python-aiohttp)
       ("python-bigchaindb-abci"
        ,python-bigchaindb-abci)
       ("python-cryptoconditions"
        ,python-cryptoconditions)
       ("python-flask" ,python-flask)
       ("python-flask-cors" ,python-flask-cors)
       ("python-flask-restful" ,python-flask-restful)
       ("python-gunicorn" ,python-gunicorn)
       ("python-jsonschema-2.5" ,python-jsonschema-2.5)
       ("python-logstats" ,python-logstats)
       ("python-packaging-18.0" ,python-packaging-18.0)
       ("python-pymongo-3.6" ,python-pymongo-3.6)
       ("python-pyyaml-5.1" ,python-pyyaml-5.1)
       ("python-rapidjson" ,python-rapidjson)
       ("python-requests" ,python-requests)
       ("python-setproctitle" ,python-setproctitle)))
    (inputs
     `(("python-pytest-runner" ,python-pytest-runner)))
    ;; (native-inputs
    ;;  `(("python-aafigure" ,python-aafigure)
    ;;    ("python-coverage" ,python-coverage)
    ;;    ("python-flake8" ,python-flake8)
    ;;    ("python-flake8-quotes" ,python-flake8-quotes)
    ;;    ("python-hypothesis" ,python-hypothesis)
    ;;    ("python-hypothesis-regex"
    ;;     ,python-hypothesis-regex)
    ;;    ("python-ipdb" ,python-ipdb)
    ;;    ("python-ipython" ,python-ipython)
    ;;    ("python-logging-tree" ,python-logging-tree)
    ;;    ("python-pep8" ,python-pep8)
    ;;    ("python-pre-commit" ,python-pre-commit)
    ;;    ("python-pytest" ,python-pytest)
    ;;    ("python-pytest-aiohttp" ,python-pytest-aiohttp)
    ;;    ("python-pytest-asyncio" ,python-pytest-asyncio)
    ;;    ("python-pytest-cov" ,python-pytest-cov)
    ;;    ("python-pytest-flask" ,python-pytest-flask)
    ;;    ("python-pytest-mock" ,python-pytest-mock)
    ;;    ("python-pytest-xdist" ,python-pytest-xdist)
    ;;    ("python-recommonmark" ,python-recommonmark)
    ;;    ("python-sphinx" ,python-sphinx)
    ;;    ("python-sphinx-rtd-theme"
    ;;     ,python-sphinx-rtd-theme)
    ;;    ("python-sphinxcontrib-httpdomain"
    ;;     ,python-sphinxcontrib-httpdomain)
    ;;    ("python-sphinxcontrib-napoleon"
    ;;     ,python-sphinxcontrib-napoleon)
    ;;    ("python-tox" ,python-tox)
    ;;    ("python-watchdog" ,python-watchdog)
    ;;    ("python-wget" ,python-wget)))
    (home-page
     "https://github.com/BigchainDB/bigchaindb/")
    (synopsis "BigchainDB: The Blockchain Database")
    (description
     "BigchainDB: The Blockchain Database")
    (license #f)))
