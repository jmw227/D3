require 'sinatra'
require 'sinatra/reloader'

# The secret number to guess.  This will start as an invalid value
# Generate a secret number from 1 to 100


def get_binary(numbits)
  arr = []
  maxnum = 2**numbits
  (0..maxnum-1).each do |i|
    arr.push(("%0"+numbits.to_s+"b")%i)
  end
  arr
end

def get_ands(arr,truthSym,falseSym)
  andres = []
  for i in arr
      result = /0/ =~ i
	  if(result.nil?)
	    andres.push(truthSym)
	  else
	    andres.push(falseSym)
	  end
  end
  andres
end

def get_ors(arr,truthSym,falseSym)
  orres = []
  for i in arr
      result = /1/ =~ i
	  if(result.nil?)
	    orres.push(falseSym)
	  else
	    orres.push(truthSym)
	  end
  end
  orres
end

def get_xors(arr,truthSym,falseSym)
  xorres = []
  for i in arr
    temp = i.gsub(/[0]/, '')
	puts(temp)
	  if((temp.length % 2) != 0)
	    xorres.push(truthSym)
	  else
	    xorres.push(falseSym)
	  end
  end
  xorres
end
# If a GET request comes in at /, do the following.

get '/' do
  # Get the parameter named guess and store it in pg
  truthSym = params['truthSym']
  falseSym = params['falseSym']
  tabsize = params['size']
  # Setting these variables here so that they are accessible
  # outside the conditional
  if (tabsize.nil?)
	tabsize = -1
  else
    tabsize = tabsize.to_i
  end
  
  strings = get_binary(tabsize)
  andres = get_ands(strings,truthSym,falseSym)
  orres = get_ors(strings,truthSym,falseSym)
  xorres = get_xors(strings,truthSym,falseSym)
  # If there was no guess parameter, this is a brand new game.
  # Generate a secret number and set the guess to nil.
  erb :index, :locals => { truthSym:truthSym, falseSym:falseSym, tabsize:tabsize, strings:strings, andres:andres, orres:orres, xorres:xorres }
end

not_found do
  status 404
  erb :error
end