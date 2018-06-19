---
layout: default
title:  Julia Downloads
---

If you like Julia, please consider starring us [on GitHub](https://github.com/JuliaLang/julia) and spreading the word!
<br>
<a class="github-button" href="https://github.com/JuliaLang/julia" data-size="large" data-show-count="true" aria-label="Star JuliaLang/julia on GitHub">Star</a>

# Current Release (v0.6.3)

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
    <th rowspan="2"> Windows Self-Extracting Archive (.exe) <a href="platform.html#windows">[help]</a></th>
    <td colspan="3"> <a href="https://julialang-s3.julialang.org/bin/winnt/x86/0.6/julia-0.6.3-win32.exe">32-bit</a> </td>
    <td colspan="3"> <a href="https://julialang-s3.julialang.org/bin/winnt/x64/0.6/julia-0.6.3-win64.exe">64-bit</a> </td>
</tr>
<tr>
    <td colspan="6">Windows 7/Windows Server 2012 users also require <a href="https://support.microsoft.com/en-us/help/3140245/update-to-enable-tls-1-1-and-tls-1-2-as-a-default-secure-protocols-in">TLS "Easy Fix" update</a>, and <a href="https://docs.microsoft.com/en-us/powershell/wmf/readme">Windows Management Framework 3.0 or later</a></td>
</tr>
<tr>
    <th> macOS Package (.dmg) <a href="platform.html#macos">[help]</a></th>
    <td colspan="6"> <a href="https://julialang-s3.julialang.org/bin/mac/x64/0.6/julia-0.6.3-mac64.dmg">10.8+ 64-bit</a> </td>
</tr>
<tr>
    <th> Generic Linux Binaries for x86 <a href="platform.html#generic-binaries">[help]</a></th>
    <td colspan="3"> <a href="https://julialang-s3.julialang.org/bin/linux/x86/0.6/julia-0.6.3-linux-i686.tar.gz">32-bit</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/x86/0.6/julia-0.6.3-linux-i686.tar.gz.asc">GPG</a>)</td>
    <td colspan="3"> <a href="https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.3-linux-x86_64.tar.gz">64-bit</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.3-linux-x86_64.tar.gz.asc">GPG</a>)</td>
</tr>
<tr>
    <th> Generic Linux Binaries for ARM </th>
    <td colspan="3"> <a href="https://julialang-s3.julialang.org/bin/linux/armv7l/0.6/julia-0.6.3-linux-armv7l.tar.gz">32-bit (armv7-a hard float)</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/armv7l/0.6/julia-0.6.3-linux-armv7l.tar.gz.asc">GPG</a>)</td>
    <td colspan="3"> <a href="https://julialang-s3.julialang.org/bin/linux/aarch64/0.6/julia-0.6.3-linux-aarch64.tar.gz">64-bit (armv8-a)</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/aarch64/0.6/julia-0.6.3-linux-aarch64.tar.gz.asc">GPG</a>)</td>
</tr>
<tr>
    <th> Generic FreeBSD Binaries for x86 <a href="platform.html#generic-binaries">[help]</a></th>
    <td colspan="6"> <a href="https://julialang-s3.julialang.org/bin/freebsd/x64/0.6/julia-0.6.3-freebsd-x86_64.tar.gz">64-bit</a>
        (<a href="https://julialang-s3.julialang.org/bin/freebsd/x64/0.6/julia-0.6.3-freebsd-x86_64.tar.gz.asc">GPG</a>)</td>
</tr>
<tr>
    <th> Source </th>
    <td colspan="2"> <a href="https://github.com/JuliaLang/julia/releases/download/v0.6.3/julia-0.6.3.tar.gz">Tarball</a>
        (<a href="https://github.com/JuliaLang/julia/releases/download/v0.6.3/julia-0.6.3.tar.gz.asc">GPG</a>) </td>
    <td colspan="2"> <a href="https://github.com/JuliaLang/julia/releases/download/v0.6.3/julia-0.6.3-full.tar.gz">Tarball with dependencies</a>
        (<a href="https://github.com/JuliaLang/julia/releases/download/v0.6.3/julia-0.6.3-full.tar.gz.asc">GPG</a>) </td>
    <td colspan="2"> <a href="https://github.com/JuliaLang/julia/tree/v0.6.3">GitHub</a> </td>
</tr>
</tbody></table>

Please see [platform specific instructions](platform.html) if you have
trouble installing Julia.  Checksums for this release are available in both [MD5](https://julialang-s3.julialang.org/bin/checksums/julia-0.6.3.md5) and [SHA256](https://julialang-s3.julialang.org/bin/checksums/julia-0.6.3.sha256) format.

If the provided download files do not work for you, please [file an
issue in the Julia project](https://github.com/JuliaLang/julia/issues).

# Upcoming Release (v0.7.0-alpha)

We are currently testing an alpha version for the next release of Julia, v0.7.0.
Please see [platform](platform.html) specific instructions if you have trouble installing Julia.
As with the latest stable release, checksums for this release are available in both
[MD5](https://julialang-s3.julialang.org/bin/checksums/julia-0.7.0-alpha.md5)
and [SHA256](https://julialang-s3.julialang.org/bin/checksums/julia-0.7.0-alpha.sha256) format.
Download the alpha version here, and please report any issues to the
[issue tracker](https://github.com/JuliaLang/julia/issues) on Github.

<table class="downloads">
<tbody>
<tr>
    <th rowspan="2"> Windows Self-Extracting Archive (.exe) <a href="platform.html#windows">[help]</a></th>
    <td colspan="3"> <a href="https://julialang-s3.julialang.org/bin/winnt/x86/0.7/julia-0.7.0-alpha-win32.exe">32-bit</a> </td>
    <td colspan="3"> <a href="https://julialang-s3.julialang.org/bin/winnt/x64/0.7/julia-0.7.0-alpha-win64.exe">64-bit</a> </td>
</tr>
<tr>
    <td colspan="6">Windows 7/Windows Server 2012 users also require <a href="https://support.microsoft.com/en-us/help/3140245/update-to-enable-tls-1-1-and-tls-1-2-as-a-default-secure-protocols-in">TLS "Easy Fix" update</a>, and <a href="https://docs.microsoft.com/en-us/powershell/wmf/readme">Windows Management Framework 3.0 or later</a></td>
</tr>
<tr>
    <th> macOS Package (.dmg) <a href="platform.html#macos">[help]</a></th>
    <td colspan="6"> <a href="https://julialang-s3.julialang.org/bin/mac/x64/0.7/julia-0.7.0-alpha-mac64.dmg">10.8+ 64-bit</a> </td>
</tr>
<tr>
    <th> Generic Linux Binaries for x86 <a href="platform.html#generic-binaries">[help]</a></th>
    <td colspan="3"> <a href="https://julialang-s3.julialang.org/bin/linux/x86/0.7/julia-0.7.0-alpha-linux-i686.tar.gz">32-bit</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/x86/0.7/julia-0.7.0-alpha-linux-i686.tar.gz.asc">GPG</a>)</td>
    <td colspan="3"> <a href="https://julialang-s3.julialang.org/bin/linux/x64/0.7/julia-0.7.0-alpha-linux-x86_64.tar.gz">64-bit</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/x64/0.7/julia-0.7.0-alpha-linux-x86_64.tar.gz.asc">GPG</a>)</td>
</tr>
<tr>
    <th> Source </th>
    <td colspan="2"> <a href="https://github.com/JuliaLang/julia/releases/download/v0.7.0-alpha/julia-0.7.0-alpha.tar.gz">Tarball</a>
        (<a href="https://github.com/JuliaLang/julia/releases/download/v0.7.0-alpha/julia-0.7.0-alpha.tar.gz.asc">GPG</a>) </td>
    <td colspan="2"> <a href="https://github.com/JuliaLang/julia/releases/download/v0.7.0-alpha/julia-0.7.0-alpha-full.tar.gz">Tarball with dependencies</a>
        (<a href="https://github.com/JuliaLang/julia/releases/download/v0.7.0-alpha/julia-0.7.0-alpha-full.tar.gz.asc">GPG</a>) </td>
    <td colspan="2"> <a href="https://github.com/JuliaLang/julia/tree/v0.7.0-alpha">GitHub</a> </td>
</tr>
</tbody>
</table>

# Older Releases

Older releases of Julia for all platforms are available on the [Older releases page](http://julialang.org/downloads/oldreleases.html).

Releases older than 0.6 are now unmaintained.

# Nightly builds

Nightly builds of the current unstable development version of Julia are available on the
[nightlies page](https://julialang.org/downloads/nightlies.html).
These are intended as developer previews into the latest work and are not intended for
normal use.
Most users are advised to use the current release version of Julia, above.

---

# Download verification
All Julia binary releases are cryptographically secured using the traditional methods on each
operating system platform.  macOS and Windows releases are codesigned by certificates that are
verified by the operating system before installation.  Generic Linux tarballs and source tarballs
are signed via GPG using [this key](../juliareleases.asc).  Ubuntu and Fedora/RHEL/CentOS/SL
releases are signed by their own keys that are verified by the package managers when installing.

<script async defer src="https://buttons.github.io/buttons.js"></script>
