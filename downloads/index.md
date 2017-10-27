---
layout: default
title:  Julia Downloads
---

# Current Release (v0.6.1)

We provide several ways for you to run Julia:

* In the terminal using the built-in Julia command line.
* In the browser on [JuliaBox.com](https://www.juliabox.com) with Jupyter notebooks. No installation is required -- just point your browser there, login and start computing.
* [JuliaPro](http://juliacomputing.com/products/juliapro.html) by [Julia Computing](http://juliacomputing.com) is a batteries included distribution of Julia. It includes the [Juno IDE](http://junolab.org), the [Gallium debugger](https://github.com/Keno/Gallium.jl), and a number of packages for plotting, optimization, machine learning, databases and much more (requires registration).

A package which integrates most of Julia's plotting backends into one convenient and
well-documented API is [Plots.jl](https://github.com/JuliaPlots/Plots.jl).
Plotting capabilities are also provided by external packages such as
[PyPlot.jl](https://github.com/JuliaPy/PyPlot.jl) and [Gadfly.jl](http://gadflyjl.org).
Look at the [plotting instructions](plotting.html) to install a plotting package. If you are using
JuliaBox, all of these plotting packages are pre-installed.

## Julia (command line version)
<table class="downloads"><tbody>
<tr>
    <th> Windows Self-Extracting Archive (.exe) <a href="platform.html#windows">[help]</a></th>
    <td colspan="3"> <a href="https://julialang-s3.julialang.org/bin/winnt/x86/0.6/julia-0.6.1-win32.exe">32-bit</a> </td>
    <td colspan="3"> <a href="https://julialang-s3.julialang.org/bin/winnt/x64/0.6/julia-0.6.1-win64.exe">64-bit</a> </td>
</tr>
<tr>
    <th> macOS Package (.dmg) <a href="platform.html#macos">[help]</a></th>
    <td colspan="6"> <a href="https://julialang-s3.julialang.org/bin/mac/x64/0.6/julia-0.6.1-mac64.dmg">10.8+ 64-bit</a> </td>
</tr>
<tr>
    <th> Generic Linux Binaries for x86 <a href="platform.html#generic-linux-binaries">[help]</a></th>
    <td colspan="3"> <a href="https://julialang-s3.julialang.org/bin/linux/x86/0.6/julia-0.6.1-linux-i686.tar.gz">32-bit</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/x86/0.6/julia-0.6.1-linux-i686.tar.gz.asc">GPG</a>)</td>
    <td colspan="3"> <a href="https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.1-linux-x86_64.tar.gz">64-bit</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.1-linux-x86_64.tar.gz.asc">GPG</a>)</td>
</tr>
<tr>
    <th> Generic Linux Binaries for ARM </th>
    <td colspan="3"> <a href="https://julialang-s3.julialang.org/bin/linux/armv7l/0.6/julia-0.6.1-linux-armv7l.tar.gz">32-bit (armv7-a hard float)</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/armv7l/0.6/julia-0.6.1-linux-armv7l.tar.gz.asc">GPG</a>)</td>
    <td colspan="3"> <a href="https://julialang-s3.julialang.org/bin/linux/aarch64/0.6/julia-0.6.1-linux-aarch64.tar.gz">64-bit (armv8-a)</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/aarch64/0.6/julia-0.6.1-linux-aarch64.tar.gz.asc">GPG</a>)</td>
</tr>
<tr>
    <th> Source </th>
    <td colspan="2"> <a href="https://github.com/JuliaLang/julia/releases/download/v0.6.1/julia-0.6.1.tar.gz">Tarball</a>
        (<a href="https://github.com/JuliaLang/julia/releases/download/v0.6.1/julia-0.6.1.tar.gz.asc">GPG</a>) </td>
    <td colspan="2"> <a href="https://github.com/JuliaLang/julia/releases/download/v0.6.1/julia-0.6.1-full.tar.gz">Tarball with dependencies</a>
        (<a href="https://github.com/JuliaLang/julia/releases/download/v0.6.1/julia-0.6.1-full.tar.gz.asc">GPG</a>) </td>
    <td colspan="2"> <a href="https://github.com/JuliaLang/julia/tree/v0.6.1">GitHub</a> </td>
</tr>
</tbody></table>

Please see [platform specific instructions](platform.html) if you have
trouble installing Julia.  Checksums for this release are available in both [MD5](https://julialang-s3.julialang.org/bin/checksums/julia-0.6.1.md5) and [SHA256](https://julialang-s3.julialang.org/bin/checksums/julia-0.6.1.sha256) format.

If the provided download files do not work for you, please [file an
issue in the Julia project](https://github.com/JuliaLang/julia/issues).

# Older Releases

Older releases of Julia for all platforms are available on the [Older releases page](http://julialang.org/downloads/oldreleases.html).

For Julia 0.5, only bugfixes are being supported. Releases older than 0.5 are now unmaintained.

# Nightly builds

These are bleeding-edge binaries of the latest version of Julia under
development, which you can use to get a preview of the latest work.
The nightly builds are for developer previews and not intended for
normal use. You can expect many packages not to work with this version.
Most users are advised to use the latest official release version of Julia, above.

<table class="downloads"><tbody>
<tr>
    <th> Windows Self-Extracting Archive (.exe) </th>
    <td> <a href="https://julialangnightlies-s3.julialang.org/bin/winnt/x86/julia-latest-win32.exe">32-bit</a> </td>
    <td colspan="2"> <a href="https://julialangnightlies-s3.julialang.org/bin/winnt/x64/julia-latest-win64.exe">64-bit</a> </td>
</tr>
<tr>
    <th> macOS Package (.dmg) </th>
    <td colspan="3"> <a href="https://julialangnightlies-s3.julialang.org/bin/mac/x64/julia-latest-mac64.dmg">10.8+ 64-bit</a> </td>
</tr>
<tr>
    <th> Generic Linux binaries for X86 </th>
    <td> <a href="https://julialangnightlies-s3.julialang.org/bin/linux/x86/julia-latest-linux32.tar.gz">32-bit</a> </td>
    <td> <a href="https://julialangnightlies-s3.julialang.org/bin/linux/x64/julia-latest-linux64.tar.gz">64-bit</a> </td>
</tr>
<tr>
    <th> Generic Linux binaries for ARM </th>
    <td> <a href="https://julialangnightlies-s3.julialang.org/bin/linux/armv7l/julia-latest-linuxarmv7l.tar.gz">32-bit (armv7-a hard float)</a> </td>
    <td> <a href="https://julialangnightlies-s3.julialang.org/bin/linux/aarch64/julia-latest-linuxaarch64.tar.gz">64-bit (armv8-a)</a> </td>
</tr>
<tr>
    <th> Fedora/RHEL/CentOS/SL packages (.rpm) </th>
    <td colspan="3"> <a href="https://copr.fedoraproject.org/coprs/nalimilan/julia-nightlies/">32/64-bit</a> </td>
</tr>
<tr>
    <th> Source </th>
    <td colspan="3"> <a href="https://github.com/JuliaLang/julia">GitHub</a> </td>
</tr>
</tbody></table>

---

# Download verification
All Julia binary releases are cryptographically secured using the traditional methods on each
operating system platform.  macOS and Windows releases are codesigned by certificates that are
verified by the operating system before installation.  Generic Linux tarballs and source tarballs
are signed via GPG using [this key](../juliareleases.asc).  Ubuntu and Fedora/RHEL/CentOS/SL
releases are signed by their own keys that are verified by the package managers when installing.
