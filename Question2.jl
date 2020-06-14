#SETTING UP THE GAME BOARD
#number of rows and columns
rows = 3
columns = 3

#Initializing the game board
gameBoard = zeros((rows,columns))
playerTurn = 1.0
function displayBoard()
    for i = 1:rows
        print("|")
        for j = 1:columns
            if gameBoard[i,j]==0.0
                print(" _ |") #0 implies blank cell
            elseif gameBoard[i,j]==1.0
                print(" X |") #1 implies 'X' was played in the cell
            else
                print(" O |") #2 implies 'O' was played in the cell
            end
        end
        println("")
    end
end

#Function to Determine if a move is legal
function validMove(pX, pO)
    if pX < 1 || pX > 3 || pO <1 || pO > 3
        return false
    elseif gameBoard[pX, pO] != 0.0
        return false
    else
        return true
    end
end

#Function to check if the game has a winner
function checkWinner()
    #Loop to check for a win in the vertical direction
    for i = 1:rows
        if gameBoard[1, i] != 0.0 && #first row has no empty cells
                gameBoard[1, i] == gameBoard[2][i] && #there exists a column i such that
                gameBoard[2, i] == gameBoard[3][i] #all its cells have the same value
            return gameBoard[1, i] #return the winning value, hence player

        #checking for a win in the horizontal direction
        elseif gameBoard[i] == [1.0, 1.0, 1.0]
            return 1.0
        elseif gameBoard[i] == [2.0, 2.0, 2.0]
            return 2.0

       #checking for a win in the first diagonal direction
        elseif gameBoard[1, 1] != 0.0 &&
                gameBoard[1, 1] == gameBoard[2, 2] &&
                gameBoard[1, 1] == gameBoard[3, 3]
            return gameBoard[1, 1]

       #checking for a win in the second diagonal direction
        elseif gameBoard[1, 3] != 0.0 &&
                gameBoard[1, 3] == gameBoard[2, 2] &&
                gameBoard[1, 3] == gameBoard[3, 1]
            return gameBoard[1, 3]

        #if no winner
        else
            for i = 1:rows
                for j = 1:columns
                    # If there exists an empty field, we continue the game
                        if gameBoard[i, j] == 0.0
                            return 0.0
                        else
                            return 3.0   # if its full, return 3.0
                        end
                end
            end
        end
    end
end

#==========================Implementation of minimax algorithm=========================#

# The AI will be player 2 (Player 'O'), which is max
function playerMax(alpha, beta)

    # Possible values for maxv are: -1 -> loss; 0  -> a tie; 1  -> win

    # initially setting AI to -2
    maxv = -2
    result = checkWinner()

    # Once the game ends, the evaluation function must be returned
    if result == 1.0
        return (-1, 1, 1) #los
    elseif result == 2.0
          return (1, 1, 1) #win
    elseif result == 3.0
        return (0, 1, 1) #draw
    end

    for i = 1:rows
        for j = 1:columns
            if gameBoard[i, j] == 0.0
                # On the empty field player 'O' makes a move and calls Min
                # That's one branch of the game tree.
                gameBoard[i, j] = 2.0
                (m, min_i, min_j) = playerMin()
                # Fixing the maxv value if needed
                if m > maxv
                    maxv = m
                    pX = i
                    pO = j

                # Setting the cell back to empty
                gameBoard[i, j] = 0.0
                end
                #=======adding alpha - beta pruning===========#
                if maxv >= beta
                    return (maxv, pX, pO)
                end
                if maxv > alpha
                    alpha = maxv
                end
        end
    end
end

    return (maxv, pX, pO)
end

#playerMax()

#The human player is playerMin, with the value of 1.0 in the natrix (displayed as "X")
function playerMin(alpha, beta)
        #Possible values for minv are: -1 -> win; 0 -> a tie, 1 -> loss
        minv = 2

        result = checkWinner()

        if result == 1.0
            return (-1, 1, 1)
        elseif result == 2.0
            return (1, 1, 1)
        elseif result == 3.0
            return (0, 1, 1)
        end

        for i = 1:rows
            for j = 1:columns
                if gameBoard[i, j] == 0.0
                    gameBoard[i, j] = 1.0
                    (m, max_i, max_j) = playerMax(alpha, beta)
                    if m < minv
                        minv = m
                        qX = i
                        qO = j
                    gameBoard[i, j] = 0.0
                    end
                    #alpha - betta pruning
                    if minv <= alpha
                        return (minv, qX, qO)
                    end

                    if minv < beta
                        beta = minv
                    end
                end
            end
        end

        return (minv, qX, qO)
end

#playerMin(19, 2)

#========================function  to play the game===========================#
function playGame()
    #Initialise the board
    gameBoard = zeros((rows, columns))
    playerTurn = 1.0

    while true
        displayBoard()
        result = checkWinner()

        if result != 0.0
            if result == 1.0
                println("The winner is X!")
            elseif result == 2.0
                println("The winner is O!")
            elseif result == 3.0
                println("It's a tie!")
                playGame = zeros((rows,columns))
                playerTurn = 1.0
            end
        end

        if playerTurn == 1.0
            while true
                (m, qX, qO) = playerMin(-2,2)
                println("Recommended move: X = ", qX, "; Y= ", qO)

                println("Insert the X coordinate: ")
                pX = parse(Int, readline())
                println("Insert the Y coordinate: ")
                pO = parse(Int, readline())

                qX = pX
                qO = pO

                if validMove(pX, pO)
                    gameBoard[pX, pO] = 1.0
                    playerTurn = 2.0
                    break
                else
                    println("The move is not valid! Try again.")
                end
            end
        else
            (m, pX, pO) = playerMax(-2, 2)
            gameBoard[pX, pO] = 2.0
            playerTurn = 1.0
        end
    end
end

playGame()
