require 'sinatra'
require 'sinatra/reloader'


def get_binary(numbits)
  arr = []
  maxnum = 2**numbits
  (0..maxnum-1).each do |i|
    arr.push(("%0"+numbits.to_s+"b")%i)
  end
  arr.reverse
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

  # Get the parameters
  truthSym = params['truthSym']
  falseSym = params['falseSym']
  tabsize = params['size']
  
  error = false
  strings = []
  andres = []
  orres = []
  xorres = []
 
  if (truthSym.nil? || truthSym == '')
	truthSym = 'T'
  end
  if (falseSym.nil? || falseSym == '')
	falseSym = 'F'
  end
  if (tabsize.nil? || tabsize == '')
    tabsize = '3'
  end

  tabsize = tabsize.to_i
  if tabsize <= 2
	error = true
  end

  if (truthSym.length != 1)
    error = true
  end
  
  if (falseSym.length != 1)
    error = true
  end
  
  if(truthSym == falseSym)
    error = true
  end
  
  if error
    erb :error
  else
    strings = get_binary(tabsize)
    andres = get_ands(strings,truthSym,falseSym)
    orres = get_ors(strings,truthSym,falseSym)
    xorres = get_xors(strings,truthSym,falseSym)
    erb :index, :locals => { truthSym:truthSym, falseSym:falseSym, tabsize:tabsize, strings:strings, andres:andres, orres:orres, xorres:xorres }
  end
end

not_found do
  status 404
  erb :error404
end