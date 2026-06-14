# SQL Notes & Cheat Sheet

My working reference for SQL, built while learning. Two halves:
1. **The four questions** — how to figure out *what* to write.
2. **The command reference** — *what to type* once you know the plan.

---

## Part 1 — Before writing any query, answer four questions in order

1. **What columns does the final answer need to show?**
   Look at the task's nouns. "names of buildings" → `Building_name`. This is your `SELECT`.

2. **Which table(s) hold those columns?**
   One table → no join. Two tables → you'll join.

3. **Is anything being filtered or restricted?**
   Words like "not", "no", "only", "more than", "between" → that's your `WHERE`.
   "no employees" → an `IS NULL` check.

4. **Does the question imply combining tables?**
   Phrases like "and their", "for each", "including empty" → a join.
   "including empty / all" specifically means `LEFT JOIN`.

**Bonus 5th question (aggregates):** Is it asking for one number *per group*?
"per", "each", "for every" + a summary number → aggregate function + `GROUP BY`.

> Read every task **twice** before writing. First read for the gist, second read
> hunting trap words: "number of" (count, not list), "each/per" (group by),
> "without" (a method constraint), and the exact column name.

---

## Part 2 — Command reference

### Retrieving & shaping output
| Command | What it does |
|---|---|
| `SELECT col1, col2` | Pick which columns to show |
| `SELECT *` | All columns |
| `SELECT DISTINCT col` | Remove duplicate rows (right after SELECT, applies to whole row) |
| `AS new_name` | Rename a column/expression in the output |
| `FROM table` | Which table to pull from |

### Filtering rows (WHERE)
| Command | What it does |
|---|---|
| `WHERE col = value` | Exact match |
| `WHERE col != value` / `WHERE col <> value` | Not equal (both work; `!=` and `<>` are identical) |
| `WHERE col > / < / >= / <=` | Comparisons |
| `WHERE col LIKE "abc%"` | Pattern match (`%` = any number of chars, `_` = exactly one char) |
| `WHERE col IN (a, b, c)` | Matches any in the list |
| `WHERE col BETWEEN x AND y` | Range (inclusive) |
| `WHERE col IS NULL` / `IS NOT NULL` | Missing-value check |
| `AND` / `OR` | Combine conditions |

> **LIKE patterns — one condition each.** To test several patterns, write a
> separate `LIKE` joined by `AND`/`OR`. You CANNOT comma-pack them into one string.
> Wrong: `LIKE '%a%,%e%,%i%'`  ·  Right: `name LIKE '%a%' AND name LIKE '%e%' AND name LIKE '%i%'`
>
> **A space is a normal character.** Match it by typing a literal space in the
> pattern. `'% %'` = "contains a space somewhere". `name NOT LIKE '% %'` = "no spaces in name".
> (`_` is NOT a space — it's any single character.)

### Sorting & limiting
| Command | What it does |
|---|---|
| `ORDER BY col ASC` / `DESC` | Sort ascending / descending |
| `LIMIT n` | Cap number of rows |
| `OFFSET n` | Skip the first n rows |

### Combining tables (JOINs)
| Command | What it does |
|---|---|
| `INNER JOIN t2 ON t1.id = t2.key` | Keep only matching rows |
| `LEFT JOIN t2 ON ...` | Keep ALL left-table rows, even unmatched (unmatched right side = NULL) |

### Aggregate functions (summarise many rows into one number)
| Command | What it does |
|---|---|
| `COUNT(*)` | Number of rows |
| `SUM(col)` | Total |
| `AVG(col)` | Average |
| `MAX(col)` / `MIN(col)` | Highest / lowest |

### String functions
| Command | What it does |
|---|---|
| `LENGTH(col)` | Number of characters in a string (`LEN` in Microsoft SQL Server) |
| `LEFT(col, n)` | First n characters of a string, e.g. `LEFT(name, 1)` = first letter |

### Grouping & filtering groups
| Command | What it does |
|---|---|
| `GROUP BY col` | Bundle rows sharing a value; aggregates run per bundle ("per / each / for every") |
| `HAVING condition` | Filter the *groups* after aggregating (vs WHERE = filter raw rows before) |

### Maths inside queries
| Command | What it does |
|---|---|
| `+ - * /` | Arithmetic on columns, e.g. `(a + b) / 1000000` |
| `%` | Modulo (remainder); `col % 2 = 0` → even |
| `ROUND(value, n)` | Round to n decimal places, e.g. `ROUND(gdp/1000000000.0, 2)` |

---

## Part 3 — Golden rules (the stuff that actually trips me up)

- **SELECT** = *what to show* · **WHERE** = *which rows to keep*
- **WHERE** filters raw rows · **HAVING** filters groups
- A calculation you want to **display** → SELECT. A calculation that's a **true/false test** → WHERE.
- Semicolon `;` goes at the **very end only** — never mid-query.
- Column names must match the table **exactly** (case + spelling).
- Don't reach for `LEFT JOIN` by default — only when the task implies missing matches ("including empty", "all X even without Y").
- **Integer division drops the decimals.** `pop/1000000` truncates to a whole number;
  `pop/1000000.0` (divide by a decimal) keeps the decimal places. Use `.0` when you want decimal output.
- **After editing a query, re-scan the line you touched** for orphaned commas/keywords.
  Most of my errors are leftover commas from trimming a column out of SELECT.
- Each `LIKE` tests one pattern — chain multiples with `AND`/`OR`, don't comma-pack one string.

---

## Order of execution (Lesson 12) — the order SQL actually runs clauses

Not the order you write them. This explains *why* WHERE can't use an aggregate but HAVING can:

1. `FROM` / `JOIN` — get and combine the tables
2. `WHERE` — filter raw rows
3. `GROUP BY` — bundle rows
4. `HAVING` — filter the bundles
5. `SELECT` — pick/compute columns to show
6. `DISTINCT` — drop duplicate rows
7. `ORDER BY` — sort
8. `LIMIT` / `OFFSET` — cap / skip
