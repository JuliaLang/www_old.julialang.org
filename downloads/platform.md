---
layout: default
title:  Platform specific instructions for installing Julia
---

# Platform Specific Instructions

## Windows

Julia is available for Windows 7 and later, both 32 bit and 64 bit.

1. Download the Windows julia.exe installer for your platform. 32-bit julia works on both x86 and x86_64. 64-bit julia will only run on 64-bit Windows (x86_64).
2. Run the downloaded program to extract julia
3. Double-click the julia shortcut in the unpacked folder to start julia

Windows 7/Windows Server 2012 users will also need to install:
 - the [TLS easy_fix](https://support.microsoft.com/en-us/help/3140245/update-to-enable-tls-1-1-and-tls-1-2-as-a-default-secure-protocols-in) for the package manager to work, see [this Discourse thread](https://discourse.julialang.org/t/errors-for-git-pkg/9351) for more details.
 - [Windows Management Framework 3.0 or later](https://docs.microsoft.com/en-us/powershell/wmf/readme) to include PowerShell 3.0 or later.

The [Windows README](https://github.com/JuliaLang/julia/blob/master/README.windows.md) contains information on dependencies.

Uninstallation is performed by deleting the extracted directory and the packages directory in `%HOME%/.julia`. If you would also like to remove your preferences files, remove `%HOME%/.juliarc.jl` and `%HOME%/.julia_history`.

## macOS

On Mac, a `Julia-<version>.dmg` file is provided, which contains Julia.app. Installation is the same as any other Mac software -- copy the `Julia-<version>.app` to your hard-drive (anywhere) or run from the disk image. Julia runs on macOS 10.8 and later releases.

Uninstall Julia by deleting Julia.app and the packages directory in ~/.julia. Multiple Julia.app binaries can co-exist without interfering with each other. If you would also like to remove your preferences files, remove `~/.juliarc.jl`.

An alternative to installing Julia from the downloaded .dmg is by using the [Homebrew package manager](https://brew.sh/). 
In your terminal, run

    brew cask install julia

## Linux and FreeBSD

It is strongly recommended that the official generic binaries from the downloads page be used to install Julia on Linux and FreeBSD.

### Generic Binaries

The generic Linux and FreeBSD binaries do not require any special installation steps, but you will need to ensure that your system can find the `julia` executable. First, extract the `.tar.gz` file downloaded from the [downloads page](index.html) to a folder on your computer. To run Julia, you can do any of the following:

* Create a symbolic link to `julia` inside a folder which is on your system `PATH`
* Add Julia's `bin` folder to your system `PATH` environment variable
* Invoke the `julia` executable by using its full path, as in `<where you extracted Julia>/bin/julia`

For example, to create a symbolic link to `julia` inside the `/usr/local/bin` folder, you can do the following:

    sudo ln -s <where you extracted the julia archive>/bin/julia /usr/local/bin/julia

On some Linux distributions, you may need to use a folder other than `/usr/local/bin`. To check which folders are on your `PATH`, you can run `echo $PATH`.

### Distribution-Specific Packages

The following distribution-specific packages are community contributed. They may not use the right versions of Julia dependencies or include important patches that the official binaries ship with. In general, bug reports will only be accepted if they are reproducible on the official generic binaries on the downloads page.

Instructions will be added here as more linux distributions start including julia. If your Linux distribution is not listed here, you should still be able to run julia by building from source. See the [Julia README](https://github.com/JuliaLang/julia/blob/master/README.md) for more detailed information.

### Fedora/RHEL/CentOS/SL/OEL
A [Copr repository](https://copr.fedoraproject.org/coprs/nalimilan/julia/) is provided for Fedora, RHEL, CentOS, Scientific Linux and Oracle Enterprise Linux systems to allow for automatic updating to the latest stable version of Julia.

If you are using RHEL, CentOS, Scientific Linux or Oracle Enterprise Linux (version 5 or higher), first [enable EPEL](https://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F) for your distribution version. Then follow the steps below.

If you are using Fedora (version 19 or higher), directly run:

    sudo dnf copr enable nalimilan/julia
    sudo yum install julia

If you are using CentOS (version 7 or higher), directly run:

    sudo yum-config-manager --add-repo https://copr.fedorainfracloud.org/coprs/nalimilan/julia/repo/epel-7/nalimilan-julia-epel-7.repo
    sudo yum install julia

If both `dnf` and `yum-config-manager` are not available for your distribution, download the relevant `.repo` file from the Copr webpage, copy it to `/etc/yum.repos`, and run the second command.

Note that Fedora guidelines advise against uploading new breaking releases to official repositories: therefore your distribution will not provide the new major versions of Julia which were published after it. When reporting issues, please ensure you are using the latest available release by using one of the Copr repositories displayed on this page.

### Fedora/RHEL/CentOS/SL/OEL nightlies installation instructions
A [Copr repository](https://copr.fedoraproject.org/coprs/nalimilan/julia-nightlies/) is provided for Fedora, RHEL, CentOS, Scientific Linux and Oracle Enterprise Linux systems to allow for automatic updating to the latest development version of Julia.

If you are using RHEL, CentOS, Scientific Linux or Oracle Enterprise Linux (version 5 or higher), first [enable EPEL](https://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F) for your distribution version. Then follow the steps below.

If you are using Fedora (version 19 or higher), directly run:

    sudo dnf copr enable nalimilan/julia-nightlies
    sudo yum install julia

If `dnf` is not available for your distribution, download the relevant `.repo` file from the Copr webpage, copy it to `/etc/yum.repos`, and run the second command.

New versions are built every night. If you have already installed julia and you want to upgrade to the latest version, do:

    sudo yum upgrade julia

### FreeBSD Ports

Julia is available in the [Ports Collection](https://svnweb.freebsd.org/ports/head/lang/julia/).
To install from the FreeBSD binary package manager, `pkg`, run

    pkg install julia

To build and install Julia from source within the Ports framework, run

    cd /usr/ports/lang/julia
    make clean
    make install

## Uninstalling Julia

Uninstallation depends on the method you used to install Julia. If you installed from a package manager such as `apt-get` or `yum`, use the package manager to remove julia, for example `apt-get remove julia` or `yum remove julia`. If you did a source build, you can remove it by deleting your julia source folder. If you would also like to remove your preferences files, they are `~/.julia` and `~/.juliarc.jl`.
