# List of Things TODO

### In Type `Grade`

- [ ] Make `Match` field of `Grade`type more efficient: read description in
  [source code](src/hilbert-grade.ads#L17)

- [ ] Sort output by "Surname, Name"

### In Pool files

- [ ] Add support for comments

- [ ] Add error handling for malformed items with line info

- [ ] Add support to load only certain types of items, depending on flags or
  its difficulty level

- [ ] Add a command to check Pool correctness and to explore Pool properties
  (number o items, etc)

- [ ] Add support for version number

### For Items

- [ ] Add support for flags (vspace, figures, in-all-exams, etc)

- [ ] Add support for bomb items (items with options that, if selected,
  suspend the exam immediately)

- [ ] Add support for jackpot items (items with options that, if selected,
  approve the exam regardless of other answers)

- [ ] Add support for grouping: one flag defines a group of items, then one
  item of the group appears in all exams

### Generation of Exams

- [ ] Allow more than one pool to generate exams (useful for June 'repesca')

### Command Line

- [ ] Accept filenames (also) as Pool names, Exams and Answers.

### Exam Visualizer

- [ ] Use new match field of grade file: depends on Type Grade TODO.

- [ ] Improve visual effects, possibly based on the Advent Of Code website.