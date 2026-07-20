\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{arabicClass}[2024/9/20 Example LaTeX class]

\LoadClass[14pt, a4paper]{extreport}

\RequirePackage[
top=1in,
left=1in,
right=1in
]{geometry}

%Tikz
\RequirePackage{tikz, pgfplots, subcaption}

% For the title page 
\RequirePackage{graphicx, float}

% For changing the headers formatting
\RequirePackage{titletoc, titlesec, setspace, enumitem, tasks}
\setlist{noitemsep, topsep=5pt, partopsep=5pt, itemsep=5pt}
\settasks{after-item-skip=2pt, before-skip=2pt, label=\en{\alph*})}
\onehalfspacing

% For math
\RequirePackage{amsmath, amssymb, amsthm, nicematrix}

% For inserting MATLAB code
\RequirePackage[framed]{matlab-prettifier}
\lstset{style=Matlab-editor, basicstyle=\small\ttfamily, morestring=[m]"}

% To use the arabic language
\RequirePackage{polyglossia}

% For the refrences
\RequirePackage{biblatex} 
\DeclareFieldFormat[book]{title}{#1}


\RequirePackage{tocbasic}
\addtotoclist[report.cls]{toc}
\renewcommand{\tableofcontents}{\listoftoc[{\contentsname}]{toc}}
\AfterTOCHead[toc]{\thispagestyle{empty}\pagestyle{empty}}
\AfterStartingTOC[toc]{\clearpage}


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
\straightbraces

\DeclareMathSymbol{0}{\mathalpha}{operators}{`0}
\DeclareMathSymbol{1}{\mathalpha}{operators}{`1}
\DeclareMathSymbol{2}{\mathalpha}{operators}{`2}
\DeclareMathSymbol{3}{\mathalpha}{operators}{`3}
\DeclareMathSymbol{4}{\mathalpha}{operators}{`4}
\DeclareMathSymbol{5}{\mathalpha}{operators}{`5}
\DeclareMathSymbol{6}{\mathalpha}{operators}{`6}
\DeclareMathSymbol{7}{\mathalpha}{operators}{`7}
\DeclareMathSymbol{8}{\mathalpha}{operators}{`8}
\DeclareMathSymbol{9}{\mathalpha}{operators}{`9}

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
	\vspace*{0cm}
	{\centering\Large\bfseries #1\par}
	\vspace{1cm}	
}
\makeatother

% Chnage the section header format
\titleformat{\section}[block]
{\bfseries\fontsize{16}{17}\selectfont} 
{\thesection}{1em}{}  

% Change the subsection header format
\titleformat{\subsection}[block]
{\bfseries\fontsize{15}{17}\selectfont} 
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

\titlecontents{chapter}[0em]{\bfseries\vspace{10pt}}{\thecontentslabel: }{}{\hfill}

\titlecontents{chapter*}[0em]{\bfseries\vspace{10pt}}{}{}{\hfill\normalfont{\contentspage}}

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














