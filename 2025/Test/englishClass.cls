\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{arabicClass}[2024/9/20 Example LaTeX class]

\LoadClass[a4paper]{book}

\RequirePackage[fontsize=13.7pt]{fontsize}

\RequirePackage[
top=1.5in,
left=0.8in,
right=0.8in
]{geometry}

\RequirePackage{setspace}

\setstretch{1.2}

\RequirePackage{amsmath, amssymb, amsthm}

\renewcommand{\theequation}{\arabic{equation}}

\RequirePackage[T1]{fontenc}
\RequirePackage{times}

\RequirePackage[lite, subscriptcorrection, zswash]{mtpro2}
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

\makeatletter
\def\@makechapterhead#1{%
	\begin{center}
		\vspace*{190pt}
		\Huge\bfseries
		\fbox{\parbox{1\textwidth}{\centering \chaptername\hspace{5pt}\thechapter\\[25pt]#1}} 
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

% For fancy headers
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhead{}
\fancyfoot{}
\fancyhead[R]{\thepage}
\fancyhead[C]{\small \leftmark}
\fancyhead[L]{\small \chaptername\,\thechapter}
\renewcommand{\chaptermark}[1]{\markboth{\MakeUppercase{#1}}{}}

\newtheoremstyle{theoremstyle}
{\topsep}
{\topsep}
{\itshape}
{}
{\bfseries}
{\vspace{5pt}\\}
{.5ex}  
{#1 #2 \textbf{#3}}

\theoremstyle{theoremstyle}

\newtheorem{theorem}{Theorem}[section]
\newtheorem{corollary}[theorem]{Corollary}
\newtheorem{lemma}[theorem]{Lemma}

\newtheoremstyle{defstyle}
{\topsep}
{\topsep}
{\normalfont}
{}
{\bfseries}
{\vspace{5pt}\\}
{.5ex}  
{#1 #2 \textbf{#3}}

\theoremstyle{defstyle}

\newtheorem{example}[theorem]{Example}
\newtheorem{definition}[theorem]{Definition}

\newcommand{\N}{\mathbb{N}}
\newcommand{\Z}{\mathbb{Z}}
\newcommand{\Q}{\mathbb{Q}}
\newcommand{\R}{\mathbb{R}}
\newcommand{\C}{\mathbb{C}}