#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

class Life
  attr_reader :rows, :cols, :grid_size
  def initialize(rows, cols, seed_modulo=rand(100))
    @rows = rows
    @cols = cols
    @seed_modulo = seed_modulo
    @grid_size = rows * cols
    @cells = Array.new(@grid_size)
    (@grid_size).times {|i| @cells[i] = (rand(@grid_size) % (@seed_modulo) == 0)}
  end

  def each_cell
    @rows.times do |row|
      @cols.times do |col|
        i = (@cols*row)+col
        yield i, row, col
      end
    end
  end

  def clear_screen!
    print "\e[2J" # Hope you like VT100 escape codes
    $stdout.flush
  end

  def display_board
    clear_screen!
    each_cell do |i,row,col|
      print "%s" % (@cells[i] ? '█' : ' ')
      puts if i % @cols == 0
    end
  end

  def living?(row, col)
    return @cells[@cols*row+col]
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
  def generation
    new_grid = Array.new(@grid_size)
    each_cell do |i,row,col|
      living_neighbors = 0
      if row > 0
        if col > 0
          living_neighbors += 1 if living?(row-1, col-1)
          living_neighbors += 1 if living?(row, col-1)
          if row < @rows
            living_neighbors += 1 if living?(row+1, col-1)
          end
        end
        living_neighbors += 1 if living?(row-1, col)
        if col < @cols
          living_neighbors += 1 if living?(row-1, col+1)
          living_neighbors += 1 if living?(row, col+1)
          if row < @rows
            living_neighbors += 1 if living?(row+1, col+1)
          end
        end
      end
      new_grid[i] = ((living_neighbors == 2 or living_neighbors == 3) ? true : false)
    end
    @cells = new_grid
  end
  def alive?
    @cells.include?(true)
  end
end

l = Life.new(40, 100, 103)

100.times do
  l.display_board
  l.generation
  sleep(0.1)
  break if not l.alive?
end

