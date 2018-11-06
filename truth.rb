require 'sinatra'
require 'sinatra/reloader'

# The secret number to guess.  This will start as an invalid value
# Generate a secret number from 1 to 100
def secret_num(test)
  if test.nil?
    rand(1..100)
  else
    test = test.to_i
    if (test > 100) || (test < 1) ||(!test.is_a? Integer)
	  50
	else
      test
	end
  end
end

# Determine the message to send depending on whether the guess is higher,
# lower, or the same as the secret number
def determine_msg(number, guess)
  to_return = ""
  if guess == number
    to_return = "That's exactly right!"
  elsif guess > number
    to_return = "That's too high!"
  else
    to_return = "That's too low!"
  end
  if (number - guess).abs > 10
    to_return += " You're way off!"
  end
  if ((number - guess).abs <= 5) &&  ((number - guess).abs != 0)
    to_return += " You're really close!"
  end
  to_return
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
    tabsize *= tabsize	
  end
  
  # If there was no guess parameter, this is a brand new game.
  # Generate a secret number and set the guess to nil.
  erb :index, :locals => { truthSym:truthSym, falseSym:falseSym, tabsize:tabsize }
end

not_found do
  status 404
  erb :error
end