import random
number = random.randint(1,11)
guess = int( input(" guess a number between 1 to 10 ") )
if guess == number : 
    print("You win")
else:
    print("You lose")
