
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{arabicClass}[2024/9/20 Example LaTeX class]

\LoadClass[14pt, a4paper]{extreport}

\RequirePackage{forest, qtree, nccmath}

\RequirePackage{titletoc, titlesec, setspace, enumitem, tasks}
\setlist{nosep}
\settasks{
	after-item-skip=0pt,
	before-skip=0pt,
	label-align=left,
	item-indent=1.3em,   % item-indent = label-width + label-offset 
	label-width=1.3em, label-offset=0em,
	column-sep=0.75em,
	label=\arabic*),
}
\onehalfspacing


% For the title page 
\RequirePackage{geometry, graphicx, float}

\RequirePackage{tikz}
\usetikzlibrary{arrows.meta}

\RequirePackage{pgfplots}
\pgfplotsset{compat=1.8}
\usepgfplotslibrary{fillbetween}

% For changing the headers formatting
\RequirePackage{titletoc, titlesec}

% For math
\RequirePackage{amsmath, amssymb, amsthm}
\allowdisplaybreaks

% For inserting MATLAB code
\RequirePackage[framed]{matlab-prettifier}
\lstset{style=Matlab-editor, basicstyle=\small\ttfamily, morestring=[m]"}

% To use the arabic language
\RequirePackage{polyglossia}

% For the refrences
\RequirePackage{biblatex} 
\DeclareFieldFormat[book]{title}{#1}

% For fancy headers
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhead{}
\fancyfoot{}
\fancyhead[L]{\thepage}
\fancyhead[C]{\small \leftmark}
\fancyhead[R]{\small \thechapter}
\renewcommand{\chaptermark}[1]{\markboth{\MakeUppercase{#1}}{}}

% Set the arabic language as default and english as side langiage
\setmainlanguage[numerals=maghrib]{arabic}
\setotherlanguage{english}

% Set the arabic and the english font
\newfontfamily{\arabicfont}[Script=Arabic]{Times New Roman}

\usepackage[T1]{fontenc}
\usepackage{times}

% Aliases for fast inserting arabic or english text
\newcommand{\ar}{\textarabic}
\newcommand{\en}{\textenglish}

% Load the MathTime Proffesional package
\usepackage[lite, subscriptcorrection, zswash]{mtpro2}

% Change the chapter header format
\makeatletter
\def\@makechapterhead#1{%
	\begin{center}
		\vspace*{190pt}
		\Huge\bfseries
		\fbox{\parbox{1\textwidth}{\centering \thechapter\\[25pt]#1}} 
		\vspace{20pt}
	\end{center}
	\thispagestyle{empty}   % No page number
	\addtocounter{page}{-1} % Adjust page number
	\cleardoublepage         % Start on a new page
	\newpage
}

\def\@makeschapterhead#1{%
	\vspace*{1cm}
	{\centering\Large\bfseries #1\par}
	\vspace{1cm}	
}
\makeatother

% Chnage the section header format
\titleformat{\section}[block]
{\bfseries\fontsize{14}{17}\selectfont} 
{\thesection}{1em}{}  

% Change the subsection header format
\titleformat{\subsection}[block]
{\bfseries\fontsize{14}{17}\selectfont} 
{\thesubsection}{1em}{}  

% Change the chapter numbering to suit the arabic style
\renewcommand{\thechapter}  {\ifnum\value{chapter}=1 الفصل الأول
	\else
	\ifnum\value{chapter}=2 الفصل الثاني
	\else
	\ifnum\value{chapter}=3 الفصل الثالث
	\else
	\ifnum\value{chapter}=4 الفصل الرابع
	\else
	\ifnum\value{chapter}=5 الفصل الخامس
	\else
	\ifnum\value{chapter}=6 الفصل السادس
	\else
	\ifnum\value{chapter}=7 الفصل السابع
	\else
	\Numberstring{chapter}
	\fi
	\fi
	\fi
	\fi
	\fi
	\fi
	\fi}
	
\renewcommand{\thesection}{\arabic{chapter} - \arabic{section}}

\renewcommand{\thesubsection}{\arabic{chapter} - \arabic{section} - \arabic{subsection}}

\titlecontents{chapter}[0em]{\bfseries\vspace{15pt}}{\thecontentslabel: }{}{\hfill}

\titlecontents{chapter*}[0em]{\bfseries\vspace{15pt}}{}{}{\hfill\normalfont{\contentspage}}

\titlecontents{section}[1em]
{\normalfont}
{\thecontentslabel\hspace*{5pt} }
{}{\titlerule*[0.5pc]{.}\contentspage}

\titlecontents{subsection}[1em]
{\normalfont}
{\thecontentslabel\hspace*{5pt} }
{}{\titlerule*[0.5pc]{.}\contentspage}

\renewcommand{\thetable}{\arabic{chapter} - \arabic{table}}

\renewcommand{\thefigure}{\arabic{chapter} - \arabic{figure}}


\newtheoremstyle{theoremstyle}
{\topsep}
{\topsep}
{\normalfont}
{}
{\bfseries}
{\vspace{5pt}\\}
{.5ex}  
{#1 #2 \textbf{#3}}

\theoremstyle{theoremstyle}

\newtheorem*{theorem}{مبرهنة}

\newtheoremstyle{mystyle}
{\topsep}
{\topsep}
{}
{}
{\bfseries}
{\vspace{5pt}\\}
{.5ex}  
{#1 #2 \textbf{#3}}

\theoremstyle{mystyle}

\newtheorem*{definition}{تعريف}
\newtheorem*{example}{مثال}
\newtheorem*{corollary}{نتيجة}
\newtheorem*{note}{ملاحظة}

\newenvironment{myproof}{\noindent\textbf{البرهان}\vspace{5pt}\\ \noindent}{\hfill \(\qedsymbol\)}

\newenvironment{solution}{\noindent\textbf{الحل}\vspace{5pt}\\}{}

\renewcommand*\newunitpunct{\addcomma\space}
\makeatletter
\def\abx@comma{\ifdim\lastkern>\z@\unkern\fi\abx@puncthook{،}}

\newcommand{\N}{\mathbb{N}}
\newcommand{\Z}{\mathbb{Z}}
\newcommand{\Q}{\mathbb{Q}}
\newcommand{\R}{\mathbb{R}}
\newcommand{\C}{\mathbb{C}}
\newcommand{\LL}{\mathcal{L}}

% Define new math operators
\DeclareMathOperator{\Log}{Log}
\DeclareMathOperator{\lcm}{lcm}
\DeclareMathOperator{\arcsec}{arcsin}
\DeclareMathOperator{\arccsc}{arccsc}
\DeclareMathOperator{\arccot}{arccot}

\renewcommand{\mathbf}[1]{\textbf{\en{#1}}}

\endinput














