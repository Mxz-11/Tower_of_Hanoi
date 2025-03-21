# 🗼 Towers of Hanoi Automaton (Flex & Bison)

This project implements an automaton-based solver for the **Towers of Hanoi** puzzle with 3 disks and 3 pegs. It uses **Flex** for lexical analysis and **Bison** for syntax parsing to process a custom-defined input format representing state transitions.

<p align="center">
  <img src="https://media.tenor.com/GfSX-u7VGM4AAAAC/dancing-bird.gif" alt="Dancing Bird" width="250">
</p>

---

## 📦 Project Files

| File | Description |
|------|-------------|
| `th_plantilla.l` | Flex definition (scanner) to tokenize the automaton input. |
| `th_plantilla.y` | Bison grammar (parser) to build the automaton and compute shortest paths. |
| `y.tab.c / y.tab.h` | Generated by Bison – parser implementation and token definitions. |
| `lex.yy.c` | Generated by Flex – lexical analyzer code. |

## 🧠 Overview

- Each **state** is a base-3 representation of the positions of 3 disks.
- There are **27 possible states** (`3³`) and transitions are stored in a **27x27 matrix**.
- The automaton builds and processes transitions via symbolic matrix multiplication.
- It computes the **shortest path (minimal number of moves)** between two given states.

## 🧪 Sample Input Format

Example of a transition (where disk movement goes from one peg to another):

123 -> 213 : M

Each line represents a transition from one state to another, labeled by a move name or symbol.

## ⚙️ How to Compile and Run

### 🔧 Requirements

- `flex`
- `bison`
- `gcc`

### 🛠️ Compilation

```bash
bison -d th_plantilla.y
flex th_plantilla.l
gcc y.tab.c lex.yy.c -o hanoi -lm
```

### ▶️ Execution

```bash
./hanoi < input.txt
```

Where input.txt contains your transition rules.

### 📚 Features

- Parses transitions and builds an adjacency matrix.
- Uses matrix multiplication to simulate automaton state transitions.
- Finds the shortest path (minimum number of moves) between any two valid states.
- Clean modular design with separation between parsing, scanning, and logic.

### 📁 Automaton Visualization

The optional file estados.pdf can be used to visualize the finite automaton representing all possible states and transitions of the Hanoi system.

---

## 📖 Flex & Bison Basics

### 📘 What is Flex?

**Flex** is a tool for generating **scanners**: programs that perform lexical analysis. It takes a `.l` file as input and produces a C file (`lex.yy.c`) containing a function `yylex()` that matches patterns (tokens) from the input stream.

- You define **regex-based patterns** and associate them with **actions** in C.
- Ideal for tokenizing inputs before parsing them with a tool like Bison.

### 📙 What is Bison?

**Bison** is a **parser generator** compatible with Yacc. It reads a `.y` file defining a context-free grammar and produces a parser in C (`y.tab.c`) which calls `yylex()` (from Flex) to get tokens.

- It uses **LALR(1)** parsing.
- You define grammar rules and the associated **semantic actions** in C.
- The generated parser calls functions like `yyparse()` and uses `yylval` to handle data.

### 🔗 Resources

- [Flex Manual](https://westes.github.io/flex/manual/)
- [Bison Manual](https://www.gnu.org/software/bison/manual/)

