I'm an Ops guy, not a software engineer, so I've never written Conway's Game of Life for a CS class or anything.  Thought it might be a fun project, so here we are.

# TODO
- Implement wraparound liveness checking - make the game board a sphere, not a 2D grid
- Figure out better seeding of the board
- Implement seeding with arbitrary predefined shapes on an otherwise empty board (e.g. puffer glider factory)
- Graphical display instead of text?
- Use escape codes or SIGWINCH or something to determine terminal size
- Quit via keypress
- Step generation via keypress
- Status bar showing generation number, timing stats
