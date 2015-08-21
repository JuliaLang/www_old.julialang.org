---
layout: default
title:  Plotting in Julia
---

# Plotting in Julia

Plotting in Julia is available through external packages. This is a relatively complete list of packages available on GitHub that provide plotting capabilities as Julia packages. Most are still under active development.

## Graphical plotting packages

### PyPlot

[PyPlot](https://github.com/stevengj/PyPlot.jl) provides a Julia interface to the Matplotlib plotting library from Python, and specifically to the matplotlib.pyplot module. It uses the Julia PyCall package to call Python's matplotlib directly from Julia with little or no overhead (arrays are passed without making a copy). Make sure that Python and MatPlotlib are correctly installed.

This package takes advantage of Julia's multimedia I/O API to display plots in any Julia graphical backend, including as inline graphics in IJulia. Alternatively, you can use a Python-based graphical Matplotlib backend to support interactive plot zooming, etc.

Here's some example code that adds the PyPlot to your Julia installation, creates a graph of two functions, and displays the results:

{% highlight julia %}
Pkg.add("PyPlot")
using PyPlot
x = linspace(0,2*pi,1000); y = sin(3*x + 4*cos(2*x))
plot(x, y, color="red", linewidth=2.0, linestyle="--")
{% endhighlight %}

### Gadfly

[Gadfly](https://github.com/dcjones/Gadfly.jl) provides crafty statistical graphics. It's an implementation of [Hadley Wickham and Leland Wilkinson's](http://www.cs.uic.edu/%7Ewilkinson/TheGrammarOfGraphics/GOG.html) grammar of graphics. It renders publication-quality graphics to PNG, Postscript, PDF, and SVG. The SVG backend uses embedded JavaScript powered by Snap.svg, to add interactivity like panning, zooming, and toggling.

Here's some example code that adds the Gadfly package to your Julia installation, creates a graph of two functions, and saves the output to an SVG file:

{% highlight julia %}
Pkg.add("Gadfly")
using Gadfly
draw(SVG("output.svg", 6inch, 3inch), plot([sin, cos], 0, 25))
{% endhighlight %}

Gadfly's interface will be familiar to users of R's [ggplot2](http://ggplot2.org) package. See [examples](https://github.com/dcjones/Gadfly.jl/tree/master/doc) and documentation on the [Gadfly](https://github.com/dcjones/Gadfly.jl) homepage.

### Winston

[Winston.jl](https://github.com/nolta/Winston.jl) offers an easy to use plot command that lets you create figures without any fuss.

{% highlight julia %}
Pkg.add("Winston")
using Winston
x = linspace(0, 3pi, 100)
c = cos(x)
s = sin(x)
p = FramedPlot(
         title="title!",
         xlabel="\\Sigma x^2_i",
         ylabel="\\Theta_i")
add(p, FillBetween(x, c, x, s))
add(p, Curve(x, c, color="red"))
add(p, Curve(x, s, color="blue"))
{% endhighlight %}

### Vega

[Vega.jl](https://github.com/johnmyleswhite/Vega.jl) allows you to create Vega visualizations. Vega is a visualization grammar, a declarative format for creating and saving visualization designs. With Vega you can describe data visualizations in a JSON format, and generate interactive views using either HTML5 Canvas or SVG. You can produce:

-Area plots
-Bar plots/Histograms
-Line plots
-Scatter plots
-Pie/Donut charts
-Waterfall
-Wordclouds

The vega.js and d3.js libraries needed to render graphics are provided as part of the package. Vega.jl works with both IPython/Jupyter notebooks and the Julia REPL. When using Jupyter Notebooks, the graphics will automatically be printed in-line. Submitting commands via the REPL will either open a new tab in the currently open (default) browser, or trigger the default browser to open.

Here's a short example to create a stacked area plot. After the plot's created, the color scheme is changed:

{% highlight julia %}
Pkg.add("Vega")
using Vega

x = [0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9]
y = [28, 43, 81, 19, 52, 24, 87, 17, 68, 49, 55, 91, 53, 87, 48, 49, 66, 27, 16, 15]
g = [0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1]

a = areaplot(x = x, y = y, group = g, stacked = true)
colorscheme!(a, ("Reds", 3))
{% endhighlight %}

### Gaston

[Gaston.jl](https://github.com/mbaz/Gaston.jl) provides an interface to plot using gnuplot. Gaston requires gnuplot to be installed on your system. It has been tested with version 4.6.

### julia-plot

[julia-plot](https://github.com/Mononofu/julia-plot) uses the MathGL library for plotting. MathGL should be installed on your system.

### GLPlot

[GLPlot.jl](https://github.com/SimonDanisch/GLPlot.jl) is based on the GLVisualize.jl package, which is a visualization library written in Julia and OpenGL.

### Qwt

[Qwt.jl](https://github.com/tbreloff/Qwt.jl) provides 2D plotting drawing, and GUI capabilities, using Qwt and Qt. Python and PyQwt should be installed on your system.

### Bokeh

[Bokeh.jl](https://github.com/bokeh/Bokeh.jl) provides an interface to Bokeh, the Python interactive visualization library that targets modern web browsers for presentation. Its goal is to provide elegant, concise construction of novel graphics in the style of D3.js, but also deliver this capability with high-performance interactivity over very large or streaming datasets.

### Plotly

[Plotly.jl](https://github.com/plotly/Plotly.jl) provides an interface to the [Plot.ly]https://plot.ly/api/) web API for plotting. You'll need to create a free account and obtain an API key.

### GoogleCharts

[GoogleCharts.jl](https://github.com/jverzani/GoogleCharts.jl) provides an interface to the Google Chart tools. In IJulia, charts are drawn automatically. From the REPL, charts are rendered to your local browser.

## Text/terminal-based packages

### UnicodePlots.jl

[UnicodePlots.jl](https://github.com/Evizero/UnicodePlots.jl) creates plots in a terminal window using Unicode characters. You can produce the following plots:

- Scatterplot
- Lineplot
- Barplot (horizontal)
- Staircase Plot
- Histogram (horizontal)
- Sparsity Pattern
- Density Plot

### ASCIIPlots.jl

[ASCIIPlots.jl](https://github.com/johnmyleswhite/ASCIIPlots.jl) creates plots in a terminal window using ASCII characters. It can make line plots, scatter plots, and array (scaled image) plots.

### TextPlots.jl

[TextPlots.jl](https://github.com/sunetos/TextPlots.jl) creates plots in a terminal window using Braille characters. TextPlots.jl aims for as much elegance and aesthetics as possible for a terminal (Unicode) plotting library. It should be able to plot any continuous real-valued function, and any small-to-medium collection of points.

### Sparklines.jl

[Sparklines.jl](https://github.com/mbauman/Sparklines.jl) creates Edward Tufte-inspired sparklines in a terminal window using Unicode characters.

### Hinton.jl (also outputs vector graphics)

[Hintont.jl](https://github.com/ninjin/Hinton.jl) is a Julia package for generating Hinton diagrams. It supports standard graphics formats such as PNG, SVG, and PDF, as well as generating diagrams in a terminal with Unicode and colour support. Hinton diagrams are commonly used to analyse the relative values of matrices. The diagram consists of rectangles whose area corresponds to the magnitude of the given element.

As well as creating diagrams in the terminal using Unicode characters, Hinton diagrams can be exported to vector graphics via [Compose.jl](https://github.com/dcjones/Compose.jl).

### ImageTerm.jl

[ImageTerm.jl](https://github.com/meggart/ImageTerm.jl) creates colorful maps in a terminal window.
