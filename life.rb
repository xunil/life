#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

ROWS = 40
COLS = 100
GRID_SIZE = ROWS * COLS

def each_cell
  ROWS.times do |row|
    COLS.times do |col|
      i = (COLS*row)+col
      yield i, row, col
    end
  end
end

def display_board(cells)
  print "\e[2J"
  $stdout.flush
  each_cell do |i,row,col|
    print "%s" % (cells[i] ? '█' : ' ')
    puts if i % COLS == 0
  end
end

# assuming 10x10 grid:
# [  ][  ][  ][  ][  ][  ][  ][  ][  ][  ]
# [  ][  ][  ][AL][ A][AR][  ][  ][  ][  ]
# [  ][  ][  ][ L][ 0][ R][  ][  ][  ][  ] <- 0 == row 2, col 4
# [  ][  ][  ][BL][ B][BR][  ][  ][  ][  ]
# [  ][  ][  ][  ][  ][  ][  ][  ][  ][  ]
# [  ][  ][  ][  ][  ][  ][  ][  ][  ][  ]
# [  ][  ][  ][  ][  ][  ][  ][  ][  ][  ]
# [  ][  ][  ][  ][  ][  ][  ][  ][  ][  ]
# [  ][  ][  ][  ][  ][  ][  ][  ][  ][  ]
# [  ][  ][  ][  ][  ][  ][  ][  ][  ][  ]
# So:
# L and R are easy; col-1 and col+1 respectively
# A and B are easy; row-1 and row+1
# AL == row-1, col-1
# AR == row-1, col+1
# BL == row+1, col-1
# BR == row+1, col+1
#
# if row == 0, don't check above
# if col == 0, don't check left
# if row == ROWS, don't check below
# if col == COLS, don't check right
# Any live cell with fewer than two live neighbours dies, as if caused by under-population.
# Any live cell with two or three live neighbours lives on to the next generation.
# Any live cell with more than three live neighbours dies, as if by overcrowding.
# Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
def living?(cells, row, col)
  return cells[COLS*row+col]
end
def generation(cells)
  each_cell do |i,row,col|
    living_neighbors = 0
    if row > 0
      if col > 0
        living_neighbors += 1 if living?(cells, row-1, col-1)
        living_neighbors += 1 if living?(cells, row, col-1)
        if row < ROWS
          living_neighbors += 1 if living?(cells, row+1, col-1)
        end
      end
      living_neighbors += 1 if living?(cells, row-1, col)
      if col < COLS
        living_neighbors += 1 if living?(cells, row-1, col+1)
        living_neighbors += 1 if living?(cells, row, col+1)
        if row < ROWS
          living_neighbors += 1 if living?(cells, row+1, col+1)
        end
      end
    end
    cells[i] = false
    cells[i] = true if (living_neighbors == 2 or living_neighbors == 3)
  end
end

cells = Array.new(GRID_SIZE)
(GRID_SIZE).times {|i| cells[i] = (rand(GRID_SIZE) % (ARGV.first.to_i) == 0)}

GRID_SIZE.times do
  display_board(cells)
  generation(cells)
  sleep(0.5)
end

