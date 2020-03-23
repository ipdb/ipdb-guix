# IPDB guix channel

This repository provides package definitions for bigchaindb,
tendermint and their dependencies. There is also a cuirass ci
specification and build procedure for building bigchaindb and
tendermint-bin packages.

It is still work in progress. Tendermint provided as precompiled binary at the
moment. Some package definitions might migrate to guix repository itself in the
future which will not affect general workflow.

## About GNU Guix

GNU Guix is a transactional package manager for the GNU system. The Guix System
Distribution or GuixSD is an advanced distribution of the GNU system that relies
on GNU Guix and respects the user's freedom.

In addition to standard package management features, Guix supports transactional
upgrades and roll-backs, unprivileged package management, per-user profiles, and
garbage collection. Guix uses low-level mechanisms from the Nix package manager,
except that packages are defined as native Guile modules, using extensions to
the Scheme language. GuixSD offers a declarative approach to operating system
configuration management, and is highly customizable and hackable.

GuixSD can be used on an i686, x86_64 and armv7 machines. It is also possible to
use Guix on top of an already installed GNU/Linux system, including on mips64el
and aarch64.
